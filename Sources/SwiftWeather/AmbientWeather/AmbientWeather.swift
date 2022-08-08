//  Created by Mike Manzo on 5/10/20.

import Foundation


/// Error messages specific to the Ambient Weather API
enum AmbientWeatherError: Error {
    case missingApplicationKey
    case invalidApplicationKey

    case missingAPIKey
    case invalidAPIKey

    case tooManyAPIKeys

    /// Thrown whenever two devices appear with the same device ID in the list of available devices from the AmbientWeather API.
    case conflictingDeviceIDs(AmbientWeatherDevice, AmbientWeatherDevice)

    case measurementLimitOutOfRange
    case userRateExceeded
    case corruptJSON
    case invalidURL
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
                comment: "Incorrect measurement range"
            )
        case .userRateExceeded:
            return NSLocalizedString(
                "AmbientWeather: Too many requests; user rate exceeded.",
                comment: "Rate Exceeded"
            )
        case .unknown:
            return NSLocalizedString(
                "AmbientWeather: Unknown Error Encountered.",
                comment: "Unkown Error"
            )
        case .invalidApplicationKey:
            return NSLocalizedString(
                "AmbientWether: Invalid Application (Developer) Key.",
                comment: "Invalid Application Key"
            )
        case .corruptJSON:
            return NSLocalizedString(
                "AmbientWeather: Corrupt JSON detected.",
                comment: "Corrupt JSON"
            )
        case .invalidURL:
            return NSLocalizedString(
                "AmbientWeather: Invalid Endpoint URL.",
                comment: "Invalid URL"
            )
        case .invalidAPIKey:
            return NSLocalizedString(
                "AmbientWeather: Invalid API (User) Key.",
                comment: "Invalid API Key"
            )
        case .missingApplicationKey:
            return NSLocalizedString(
                "AmbientWeather: Missing Application (Developer) Key.",
                comment: "Missing Application Key"
            )
        case .missingAPIKey:
            return NSLocalizedString(
                "AmbientWeather: Missing API (User) Key.",
                comment: "Missing API Key"
            )
        case .tooManyAPIKeys:
            return NSLocalizedString(
                "AmbientWeather: Too many keys provided.  AmbientWeather requires two keys: Application (Developer) and API (User)..",
                comment: "Too many API Keys"
            )
        case .conflictingDeviceIDs(let a, let b):
            return NSLocalizedString(
                "AmbientWeather: API reported two devices with the same ID (\(a.ID)):\n\n\(a)\n\n\(b)", comment: "Two (or more) devices reported that have the same ID.")
        }
    }
}

public final class AmbientWeather: WeatherPlatform, Codable {
    private let apiEndPoint = "https://api.ambientweather.net/"
    public var devices: [WeatherDeviceID: WeatherDevice]?
    private let apiVersion = "v1"
    private let applicationKey: String
    private let apiKey: String

    enum CodingKeys: CodingKey {
        case applicationKey
        case apiKey
    }

    /// - Parameter apiKeys: API keys to be used.  You need two keys:
    ///  - apiKeys[0] == Application Key (Developer Key)
    ///  - apiKeys[1] == API Key (Customer/User Key)
    ///
    internal init(apiKeys: [String]) throws {
        guard let applicationKey = apiKeys.first else {
            throw AmbientWeatherError.missingApplicationKey
        }

        guard !applicationKey.isEmpty else {
            throw AmbientWeatherError.missingApplicationKey
        }

        guard 2 <= apiKeys.count else {
            throw AmbientWeatherError.missingAPIKey
        }

        guard 2 == apiKeys.count else {
            throw AmbientWeatherError.tooManyAPIKeys
        }

        apiKey = apiKeys[1]

        guard !apiKey.isEmpty else {
            throw AmbientWeatherError.invalidAPIKey
        }

        self.applicationKey = applicationKey
    }

    ///
    /// WeatherService protocol function
    /// All this function does (for now) is grab the devices that are associated with the account
    ///
    /// - Parameter completionHandler: returns one of three states to the caller: NotReporting; Reporting; Error
    ///
    public func setupService(completionHandler: @escaping (WeatherServiceStatus) -> Void) {
        let endpoint: URL

        do {
            endpoint = try deviceEndPoint()
        } catch let error {
            completionHandler(.Error(error))
            return
        }

        URLSession.shared.dataTask(with: endpoint) { [weak self] data, response, downloadError in
            guard let self else { return }

            if let httpResponse = response as? HTTPURLResponse {
                guard 200 == httpResponse.statusCode else {
                    print("AmbientWeather API \(endpoint) responded with HTTP status \(httpResponse.statusCode).\nHeaders:\n\(httpResponse)\nBody:\n\(data?.asString(encoding: .utf8) ?? data.debugDescription)")
                    completionHandler(.Error(AmbientWeatherError.from(apiResponse: data)))
                    return
                }
            }

            guard let data else {
                completionHandler(.Error(downloadError ?? AmbientWeatherError.unknown))
                return
            }

            let deviceList: [AmbientWeatherDevice]

            do {
                deviceList = try JSONDecoder().decode(type(of: deviceList), from: data)

                self.devices = try Dictionary(
                    deviceList.map { ($0.ID, $0) },
                    uniquingKeysWith: { throw AmbientWeatherError.conflictingDeviceIDs($0, $1) })
            } catch {
                completionHandler(.Error(AmbientWeatherError.from(apiResponse: data, else: error)))
                return
            }

            completionHandler(deviceList.count > 0 ? .Reporting : .NotReporting)
        }.resume()
    }
    
    ///
    /// WeatherService protocol function
    /// Get the last measurement's worth of data from the station with the identified ID
    /// - Parameter device: The weather device of interest.
    /// - Parameter completionHandler: Return the last data collected by the station; returns nil if a failure occurs.
    ///
    public func getLastMeasurement(device: WeatherDeviceID, completionHandler: @escaping (WeatherReport?) -> Void) {
        getHistoricalMeasurements(device: device, count: 1) { result in
            completionHandler(result?.first)
        }
    }

    ///
    /// WeatherService protocol function
    /// Get the last measurement's worth of data from the station with the identified ID
    /// - Parameter device: The weather device of interest.
    /// - Parameter completionHandler: Return the last data collected by the station; returns nil if a failure occurs.
    /// - Parameter count: number of entries that we want to get.  Min is 1: Max is 288
    ///
    public func getHistoricalMeasurements(device: WeatherDeviceID, count: Int, completionHandler: @escaping ([WeatherReport]?) -> Void) {
        let endpoint: URL

        do {
            endpoint = try dataEndPoint(macAddress: device, limit: count)
        } catch let error {
            print(error)
            completionHandler(nil)
            return
        }

        URLSession.shared.dataTask(with: endpoint) { data, response, downloadError in
            if let httpResponse = response as? HTTPURLResponse {
                guard 200 == httpResponse.statusCode else {
                    print("AmbientWeather API \(endpoint) responded with HTTP status \(httpResponse.statusCode).\nHeaders:\n\(httpResponse)\nBody:\n\(data?.asString(encoding: .utf8) ?? data.debugDescription)")
                    completionHandler(nil)
                    return
                }
            }

            guard let data else {
                print("Failed to fetch data from \(endpoint): \(downloadError?.localizedDescription ?? "no error details given")\nResponse:\n\(response?.debugDescription ?? "<missing>")")
                completionHandler(nil)
                return
            }

            do {
                completionHandler(try JSONDecoder().decode([AmbientWeatherStationData].self, from: data))
            } catch {
                print("Failed to decode response as weather station data: \(error)\nResponse body:\n\(String(data: data, encoding: .utf8) ?? data.debugDescription)")
                completionHandler(nil)
            }
        }.resume()
    }
    
    ///
    /// Build Device End Point URL so we can determine the number of devices supported by the account
    /// - Throws: AmbientWeatherError
    /// - Returns: Fully-formedDevince endpoint URL
    ///
    private func deviceEndPoint() throws -> URL {
        guard let url = URL(string: apiEndPoint + apiVersion + "/devices?applicationKey=\(applicationKey)&apiKey=\(apiKey)") else {
            throw AmbientWeatherError.invalidURL
        }

        return url
    }
    
    ///
    /// Build Device Data End Point URL so we can query the device for data
    /// - Parameters:
    ///   - macAddress: MAC address of the weather station
    ///   - limit: the number of measurements you wish to recive.  The bounds on limit are 1 and 288
    /// - Throws: AmbientWeatherError
    /// - Returns: Fully-formedDevince endpoint URL
    ///
    private func dataEndPoint(macAddress: String, limit: Int = 1) throws -> URL {
        guard limit >= 1 && limit <= 288 else {
            throw AmbientWeatherError.measurementLimitOutOfRange
        }

        guard let url = URL(string: apiEndPoint + apiVersion + "/devices/\(macAddress)?apiKey=\(apiKey)&applicationKey=\(applicationKey)&limit=\(limit)") else {
            throw AmbientWeatherError.invalidURL
        }

        return url
    }
}
