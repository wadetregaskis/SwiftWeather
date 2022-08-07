//
//  AmbientWeather.swift
//  
//
//  Created by Mike Manzo on 5/10/20.
//

import Foundation
import SwiftyJSON
import Alamofire

/// Error messages specific to the Ambient Weather API
enum AmbientWeatherError: Error {
    case measurementLimitOutOfRange
    case invalidApplicationKey
    case userRateExceeded
    case invalidAPIKey
    case corruptJSON
    case invalidURL
    case unknown
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
        do {
            AF.request(try deviceEndPoint()).response { [weak self] response in
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    if let error = json["error"].string {
                        switch error {
                        case "applicationKey-invalid":
                            completionHandler(.Error)
                            throw AmbientWeatherError.invalidApplicationKey
                        case "apiKey-invalid":
                            completionHandler(.Error)
                            throw AmbientWeatherError.invalidAPIKey
                        case "above-user-rate-limit":
                            completionHandler(.Error)
                            throw AmbientWeatherError.userRateExceeded
                        default:
                            completionHandler(.Error)
                            throw AmbientWeatherError.unknown
                        }
                    } else {
                        for device in try JSONDecoder().decode([AmbientWeatherDevice].self, from: data) {
                            //                            self?.knownDevices[device.deviceID!] = device
                            self?.knownDevices.append([device.deviceID!: device])
                        }
                    }
                } catch let error { // JSON / Decoder 'do'
                    completionHandler(.Error)
                    print(error)
                }
                (self?.knownDevices.count)! > 0 ? completionHandler(.Reporting) : completionHandler(.NotReporting)
            }
        } catch let error { // AlamoFire 'do'
            completionHandler(.Error)
            print(error)
        }
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
        do {
            AF.request(try dataEndPoint(macAddress: uniqueID!, limit: count)).response { response in
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    if let error = json["error"].string {
                        switch error {
                        case "applicationKey-invalid":
                            throw AmbientWeatherError.invalidApplicationKey
                        case "apiKey-invalid":
                            throw AmbientWeatherError.invalidAPIKey
                        case "above-user-rate-limit":
                            throw AmbientWeatherError.userRateExceeded
                        default:
                            print("Unknown Error: \(error)")
                            throw AmbientWeatherError.unknown
                        }
                    } else {
                        completionHandler((try JSONDecoder().decode([AmbientWeatherStationData].self, from: data)))
                    }
                } catch let error { // JSON Decoder 'do'
                    print(error)
                    completionHandler(nil)
                }
            }
        } catch let error { // AlamoFire 'do'
            print(error)
            completionHandler(nil)
        }
    }

    
    ///
    /// Provides a simple way to "see" what ths device is reporting
    /// - Parameter uniqueID: MAC address of the weather station
    ///
    public func description(uniqueID: String) {
        //        print(knownDevices[uniqueID]?.prettyString ?? AmbientWeatherError.unknown.errorDescription!)  // Original
        //        let newArray = knownDevices.filter { $0.keys.contains(uniqueID) }.flatMap { $0 }.first
        guard let element = knownDevices.filter({ $0.keys.contains(uniqueID) }).flatMap({ $0 }).first else {
            print(AmbientWeatherError.unknown.errorDescription!)
            return
        }
        print (element.value.prettyString)
    }
    
    ///
    /// Build Device End Point URL so we can determine the number of devices supported by the account
    /// - Throws: SwiftWeatherError
    /// - Returns: Fully-formedDevince endpoint URL
    ///
    private func deviceEndPoint() throws -> String {
        if _applicationKey == "" && _apiKey == "" {
            throw AmbientWeatherError.invalidURL
        } else {
            return apiEndPoint + apiVersion + "/devices?applicationKey=\(_applicationKey)&apiKey=\(_apiKey)"
        }
    }
    
    ///
    /// Build Device Data End Point URL so we can query the device for data
    /// - Parameters:
    ///   - macAddress: MAC address of the weather station
    ///   - limit: the number of measurements you wish to recive.  The bounds on limit are 1 and 288
    /// - Throws: SwiftWeatherError
    /// - Returns: Fully-formedDevince endpoint URL
    ///
    private func dataEndPoint(macAddress: String, limit: Int = 1) throws -> String {
        if _applicationKey == "" && _apiKey == "" {
            throw AmbientWeatherError.invalidURL
        } else {
            if limit < 1 || limit > 288 {
                throw AmbientWeatherError.measurementLimitOutOfRange
            }
            return apiEndPoint + apiVersion + "/devices/\(macAddress)?apiKey=\(_apiKey)&applicationKey=\(_applicationKey)&limit=\(limit)"
        }
    }
}
