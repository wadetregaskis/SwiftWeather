//
//  AmbientWeather.swift
//  
//
//  Created by Mike Manzo on 5/10/20.
//

import Foundation


/// Error messages specific to the Ambient Weather API
enum AmbientWeatherError: Error {
    case measurementLimitOutOfRange
    case invalidApplicationKey
    case userRateExceeded
    case invalidAPIKey
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
                "AmbientWether: Invalid Application Key.",
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
                "AmbientWeather: Invalid API Key.",
                comment: "Invalid API Key"
            )
        }
    }
}

public final class AmbientWeather: WeatherPlatform, Codable {
    private(set) var apiEndPoint    = "https://api.ambientweather.net/"
    private var knownDevices        = [[String: AmbientWeatherDevice]]()
    private(set) var apiVersion     = "v1"
    private var _applicationKey     = ""
    private var _apiKey             = ""
    
    /// Returns an array containing the devices AmbientWeather is reporting
    public var reportingDevices: [[String: WeatherDevice]] {
        get {
            return knownDevices
        }
    }
    
    /// Returns the number of devices AmbientWeather is reporting
    var numberOfReportingDevices: Int {
        get {
            return knownDevices.count
        }
    }
    
    ///
    /// Initialize the service with the keys needed
    /// This is a per-service customization.  Some services will need more than one key
    ///
    /// - Parameter apiKeys: api Keys to be used
    /// For AmbientWeather.Net, you need two keys
    ///  - apiKeys[0] == API Key (Customer/User Key)
    ///  - apiKeys[1] == Applicaion Key (Developer Key)
    ///
    public init(apiKeys: [String]) {
        _applicationKey = apiKeys[1]
        _apiKey = apiKeys[0]
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

            do {
                for device in try JSONDecoder().decode([AmbientWeatherDevice].self, from: data) {
                    self.knownDevices.append([device.deviceID!: device])
                }
            } catch {
                completionHandler(.Error(AmbientWeatherError.from(apiResponse: data, else: error)))
                return
            }

            completionHandler(self.knownDevices.count > 0 ? .Reporting : .NotReporting)
        }.resume()
    }
    
    ///
    /// WeatherService protocol function
    /// Get the last measurement's worth of data from the station with the identified ID
    /// - Parameter uniqueID: MAC address of the weather station
    /// - Parameter completionHandler: Return the last data collected by the station; returns nil if a failure occurs.
    ///
    public func getLastMeasurement(uniqueID: String?, completionHandler: @escaping (WeatherDeviceData?) -> Void) {
        getHistoricalMeasurements(uniqueID: uniqueID, count: 1) { result in
            completionHandler(result?.first)
        }
    }

    ///
    /// WeatherService protocol function
    /// Get the last measurement's worth of data from the station with the identified ID
    /// - Parameter uniqueID: MAC address of the weather station
    /// - Parameter completionHandler: Return the last data collected by the station; returns nil if a failure occurs.
    /// - Parameter count: number of entries that we want to get.  Min is 1: Max is 288
    ///
    public func getHistoricalMeasurements(uniqueID: String?, count: Int, completionHandler: @escaping ([WeatherDeviceData]?) -> Void) {
        let endpoint: URL

        do {
            endpoint = try dataEndPoint(macAddress: uniqueID!, limit: count)
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
                completionHandler((try JSONDecoder().decode([AmbientWeatherStationData].self, from: data)))
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
        guard !_applicationKey.isEmpty else {
            throw AmbientWeatherError.invalidApplicationKey
        }

        guard !_apiKey.isEmpty else {
            throw AmbientWeatherError.invalidAPIKey
        }

        guard let url = URL(string: apiEndPoint + apiVersion + "/devices?applicationKey=\(_applicationKey)&apiKey=\(_apiKey)") else {
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
        guard !_applicationKey.isEmpty else {
            throw AmbientWeatherError.invalidApplicationKey
        }

        guard !_apiKey.isEmpty else {
            throw AmbientWeatherError.invalidAPIKey
        }

        guard limit >= 1 && limit <= 288 else {
            throw AmbientWeatherError.measurementLimitOutOfRange
        }

        guard let url = URL(string: apiEndPoint + apiVersion + "/devices/\(macAddress)?apiKey=\(_apiKey)&applicationKey=\(_applicationKey)&limit=\(limit)") else {
            throw AmbientWeatherError.invalidURL
        }

        return url
    }
}
