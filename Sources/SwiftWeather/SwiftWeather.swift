//  Created by Mike Manzo on 5/10/20.

import Foundation

/// Platform protocol for weather platforms to be added
public protocol WeatherPlatform {
    func getHistoricalMeasurements(uniqueID: String?, count: Int, completionHandler: @escaping ([WeatherDeviceData]?) -> Void)
    func getLastMeasurement(uniqueID: String?, completionHandler: @escaping (WeatherDeviceData?) -> Void)
    func setupService(completionHandler: @escaping (WeatherServiceStatus) -> Void)
    
    var  reportingDevices: [[String: WeatherDevice]] { get }
}

public protocol WeatherDeviceData: Codable, CustomStringConvertible {
    var availableSensors: [WeatherSensor] { get }
}

/// Testing something
public protocol WeatherDevice: Codable, CustomStringConvertible {
    var deviceID: String? { get }
}

/// Service Status
public enum WeatherServiceStatus {
    case NotReporting
    case Reporting
    case Error(Error)
}

/// Supported Service Types
public enum WeatherServiceType: String, Codable {
    case AmbientWeather
}

public class SwiftWeather {
    /// Initialize the desired service using a platform model
    /// - Parameters:
    ///   - weatherServiceType: desired weather service.
    ///   - apiKeys: key(s) that are required to initialize the service; it's up to the resulting service to handle the order and # of keys.
    /// - Returns: A new weather platform of the requested type.
    public static func create(weatherServiceType: WeatherServiceType, apiKeys: [String]) -> WeatherPlatform {
        switch weatherServiceType {
        case .AmbientWeather:
            return AmbientWeather(apiKeys: apiKeys)
        }
    }
}
