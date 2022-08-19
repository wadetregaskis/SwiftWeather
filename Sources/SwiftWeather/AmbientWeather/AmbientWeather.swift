//  Created by Mike Manzo on 5/10/20.

import Foundation


/// Error messages specific to the Ambient Weather API
enum AmbientWeatherError: Error {
    case invalidApplicationKey
    case invalidAPIKey

    /// Thrown whenever two devices appear with the same device ID in the list of available devices from the AmbientWeather API.
    case conflictingDeviceIDs(AmbientWeatherDevice, AmbientWeatherDevice)

    case invalidReportCount(Int)

    case measurementLimitOutOfRange
    case userRateExceeded
    case invalidURL

    case platformMissingFromDecoderUserInfo

    case unknown

    internal static func from(apiResponse: Data?, else otherError: Error? = nil) -> Error {
        guard let apiResponse,
              let json = try? JSONDecoder().decode([String:String].self, from: apiResponse),
              let errorString = json["error"] else {
            return otherError ?? unknown
        }

        switch errorString {
        case "applicationKey-invalid":
            return invalidApplicationKey
        case "apiKey-invalid":
            return invalidAPIKey
        case "above-user-rate-limit":
            return userRateExceeded
        default:
            return unknown
        }
    }
}

/// Localized error messages
extension AmbientWeatherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .measurementLimitOutOfRange:
            return NSLocalizedString(
                "AmbientWeather: Measurements can only be between 1 and 288.",
                comment: "Incorrect measurement range")
        case .userRateExceeded:
            return NSLocalizedString(
                "AmbientWeather: Too many requests; user rate exceeded.",
                comment: "Rate Exceeded")
        case .unknown:
            return NSLocalizedString(
                "AmbientWeather: Unknown Error Encountered.",
                comment: "Unkown Error")
        case .invalidApplicationKey:
            return NSLocalizedString(
                "AmbientWether: Invalid Application (Developer) Key.",
                comment: "Invalid Application Key")
        case .invalidURL:
            return NSLocalizedString(
                "AmbientWeather: Invalid Endpoint URL.",
                comment: "Invalid URL")
        case .invalidAPIKey:
            return NSLocalizedString(
                "AmbientWeather: Invalid API (User) Key.",
                comment: "Invalid API Key")
        case .conflictingDeviceIDs(let a, let b):
            return NSLocalizedString(
                "AmbientWeather: API reported two devices with the same ID (\(a.ID)):\n\n\(a)\n\n\(b)",
                comment: "Two (or more) devices reported that have the same ID.")
        case .platformMissingFromDecoderUserInfo:
            return NSLocalizedString(
                "AmbientWeather: Parent AmbientWeather[Platform] missing from Decoder userInfo.",
                comment: "When the WeatherPlatform object that is creating a WeatherDevice is not found in the Decoder's userInfo dictionary")
        case .invalidReportCount(let count):
            return NSLocalizedString(
                "At least 1 weather report must be requested, not \(count).",
                comment: "When a caller asks for an invalid number of weather reports (i.e. 0 or a negative number).")
        }
    }
}

public final class AmbientWeather: WeatherPlatform, Codable {
    private let apiHostname = "api.ambientweather.net"
    private let apiVersion = "v1"
    private let applicationKey: String
    private let apiKey: String

    enum CodingKeys: CodingKey {
        case applicationKey
        case apiKey
    }

    internal init(applicationKey: String, apiKey: String) throws {
        guard !applicationKey.isEmpty else {
            throw AmbientWeatherError.invalidApplicationKey
        }

        guard !apiKey.isEmpty else {
            throw AmbientWeatherError.invalidAPIKey
        }

        self.applicationKey = applicationKey
        self.apiKey = apiKey
    }

    internal static let platformCodingUserInfoKey = CodingUserInfoKey(rawValue: "Platform")!

    public var devices: [WeatherDeviceID: WeatherDevice] {
        get async throws {
            let endpoint = try deviceEndPoint()
            let (data, response) = try await URLSession.shared.data(from: endpoint)

            if let httpResponse = response as? HTTPURLResponse {
                guard 200 == httpResponse.statusCode else {
                    print("AmbientWeather API \(endpoint) responded with HTTP status \(httpResponse.statusCode).\nHeaders:\n\(httpResponse)\nBody:\n\(data.asString(encoding: .utf8) ?? data.debugDescription)")
                    throw AmbientWeatherError.from(apiResponse: data)
                }
            }

            let decoder = JSONDecoder()
            decoder.userInfo[AmbientWeather.platformCodingUserInfoKey] = self

            do {
                let deviceList = try decoder.decode([AmbientWeatherDevice].self, from: data)
                return try Dictionary(
                    deviceList.map { ($0.ID, $0) },
                    uniquingKeysWith: { throw AmbientWeatherError.conflictingDeviceIDs($0, $1) })
            } catch {
                throw AmbientWeatherError.from(apiResponse: data, else: error)
            }
        }
    }

    private var baseURLComponents: URLComponents {
        var components = URLComponents()

        components.scheme = "https"
        components.host = apiHostname
        components.path = "/\(apiVersion)"
        components.queryItems = [URLQueryItem(name: "applicationKey", value: applicationKey),
                                 URLQueryItem(name: "apiKey", value: apiKey)]

        return components
    }

    private func deviceEndPoint() throws -> URL {
        var components = baseURLComponents

        components.path.append("/devices")

        guard let url = components.url else {
            throw AmbientWeatherError.invalidURL
        }

        return url
    }

    private static let formatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    internal func dataEndPoint(macAddress: String, limit: Int = 1, date: Date? = nil) throws -> URL {
        guard limit >= 1 && limit <= 288 else {
            throw AmbientWeatherError.measurementLimitOutOfRange
        }

        var components = baseURLComponents

        components.path.append("/devices/\(macAddress)")

        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: "limit", value: limit.description))

        if let date {
            queryItems.append(URLQueryItem(name: "endDate", value: AmbientWeather.formatter.string(from: date)))
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw AmbientWeatherError.invalidURL
        }

        return url
    }
}
