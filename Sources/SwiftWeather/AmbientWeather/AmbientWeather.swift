//  Created by Mike Manzo on 5/10/20.

import Foundation


/// Error messages specific to the Ambient Weather API
enum AmbientWeatherError: Error {
    case invalidApplicationKey

    case invalidReportCount(Int)
    case unsupportedReportCount(Int)

    case userRateExceeded
    case invalidURL

    case platformMissingFromDecoderUserInfo
    case sensorNotSupportedForCodable(WeatherSensor)

    case noAPIResponse
    case unrecognisedAPIFailure(String)

    internal static func from(apiResponse: Data?, else otherError: Error? = nil) -> Error {
        guard let apiResponse else {
            return otherError ?? noAPIResponse
        }

        guard let json = try? JSONDecoder().decode([String:String].self, from: apiResponse),
              let errorString = json["error"] else {
            return otherError ?? unrecognisedAPIFailure("No error information included in response.")
        }

        switch errorString {
        case "applicationKey-invalid":
            return invalidApplicationKey
        case "apiKey-invalid":
            return WeatherError.invalidAPIKey
        case "above-user-rate-limit":
            return userRateExceeded
        default:
            return unrecognisedAPIFailure(errorString)
        }
    }
}

/// Localized error messages
extension AmbientWeatherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidApplicationKey:
            return NSLocalizedString(
                "invalidApplicationKey",
                value: "Invalid AmbientWeather application (developer) key.",
                comment: "When the application key is either obviously invalid (e.g. an empty string) or rejected by the AmbientWeather API.")

        case .invalidReportCount(let count):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "invalidReportCount",
                    value: "At least 1 weather report must be requested, not \(count).",
                    comment: "When a caller asks for an invalid number of weather reports (i.e. 0 or a negative number).  The count requested is provided as an integer parameter."),
                count)

        case .unsupportedReportCount(let count):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "unsupportedReportCount",
                    value: "AmbientWeather only supports returning between 1 and 288 weather reports per API call, not %d.",
                    comment: "When a nominally valid (i.e. >0) report count is requested, but it's simply not supported.  \"invalidReportCount\" is used for outright bogus values (e.g. zero, or negative counts).  The count requested is provided as an integer parameter."),
                count)

        case .userRateExceeded:
            return NSLocalizedString(
                "userRateExceeded",
                value: "The AmbientWeather API rejected the request because [it believes] too many requests have been made recently, and it is enforcing a rate limit (which is or at least was one request per second).",
                comment: "When the AmbientWeather API rejects a request with a 429 (or similar indicator of rate-limiting).")

        case .invalidURL:
            return NSLocalizedString(
                "invalidURL",
                value: "Invalid AmbientWeather endpoint URL.",
                comment: "In principle should never happen - indicates that the hard-coded URL(s) for working with the AmbientWeather API are invalid in some way, at least according to the URL or URLComponents classes.")

        case .platformMissingFromDecoderUserInfo:
            return NSLocalizedString(
                "platformMissingFromDecoderUserInfo",
                value: "Parent AmbientWeather[Platform] missing from Decoder userInfo.",
                comment: "In principle should never happen.  This means the AmbientWeather (platform) that is creating an AmbientWeatherDevice is not found in the Decoder's userInfo dictionary.")

        case .sensorNotSupportedForCodable(let sensor):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "sensorNotSupportedForCodable",
                    value: "AmbientWeatherSensor is not supported for encoding (per Codable protocol) because its ID (%@) is not recognised:\n%@",
                    comment: "In principle should never happens.  This means there's an internal inconsistency - code bug - in which a sensor is somehow constructed that cannot be encoded, even though construction should have been via the same list of known sensor IDs as encoding supports.  The sensor ID is passed as the first parameter (as a String), followed by a description of the sensor overall (also as a String)."),
                sensor.ID,
                String(describing: sensor))

        case .noAPIResponse:
            return NSLocalizedString(
                "noAPIResponse",
                value: "The AmbientWeather API did not provide a response.",
                comment: "This covers both whether the API outright failed and therefore there was no response (logically), and when the API did _seem_ to work but the literal HTTP response body was empty.")
            
        case .unrecognisedAPIFailure(let message):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "unrecognisedAPIFailure",
                    value: "Unrecognised error when calling the AmbientWeather API: %@",
                    comment: "This indicates that there _was_ a response - so it's not merely that the API was unreachable or somesuch - but the response was either unintelligible (not the expected JSON format & structure) or specified an error code that is not recognised.  An error message is included as the parameter, though it may itself just be a localised placeholder saying that there was no error message."),
                message)
        }
    }
}

public final class AmbientWeather: WeatherPlatform {
    private let apiHostname = "api.ambientweather.net"
    private let apiVersion = "v1"

    private let applicationKey: String
    private let apiKey: String

    internal let session: URLSession

    private static var defaultConfiguration: URLSessionConfiguration {
        let config = URLSessionConfiguration.ephemeral

        config.timeoutIntervalForResource = 120
        config.waitsForConnectivity = true

        config.httpCookieAcceptPolicy = .never
        config.httpShouldSetCookies = false

        config.httpMaximumConnectionsPerHost = 1
        config.httpShouldUsePipelining = true

        config.requestCachePolicy = .reloadRevalidatingCacheData

        // Weather data is quite small and compresses very well (with gzip transfer compression) so it's unlikely to be a concern regarding use over cellular or "expensive" connections.  Framework users can always override this if they wish (by providing a custom URLSessionConfiguration), to better match their app's needs.
        config.allowsCellularAccess = true
        config.allowsExpensiveNetworkAccess = true
        config.allowsConstrainedNetworkAccess = true

        config.tlsMinimumSupportedProtocolVersion = .TLSv13

        return config
    }

    internal init(applicationKey: String,
                  apiKey: String,
                  sessionConfiguration: URLSessionConfiguration?) throws {
        guard !applicationKey.isEmpty else {
            throw AmbientWeatherError.invalidApplicationKey
        }

        guard !apiKey.isEmpty else {
            throw WeatherError.invalidAPIKey
        }

        self.applicationKey = applicationKey
        self.apiKey = apiKey
        self.session = URLSession(configuration: sessionConfiguration?.copy() as! URLSessionConfiguration? ?? AmbientWeather.defaultConfiguration)
    }

    internal static let platformCodingUserInfoKey = CodingUserInfoKey(rawValue: "Platform")!

    public var usersDevices: [WeatherDeviceID: WeatherDevice] {
        get async throws {
            let endpoint = try deviceEndPoint()
            let (data, response) = try await session.data(from: endpoint)

            if let httpResponse = response as? HTTPURLResponse {
                guard 200 == httpResponse.statusCode else {
                    print("AmbientWeather API \(endpoint) responded with HTTP status \(httpResponse.statusCode).\nHeaders:\n\(httpResponse)\nBody:\n\(data.asString(encoding: .utf8) ?? data.asHexString())")
                    throw AmbientWeatherError.from(apiResponse: data)
                }
            }

            let decoder = JSONDecoder()
            decoder.userInfo[AmbientWeather.platformCodingUserInfoKey] = self

            do {
                let deviceList = try decoder.decode([AmbientWeatherDevice].self, from: data)
                return try Dictionary(
                    deviceList.map { ($0.ID, $0) },
                    uniquingKeysWith: { throw WeatherError.conflictingDeviceIDs($0, $1) })
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
            throw AmbientWeatherError.unsupportedReportCount(limit)
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
