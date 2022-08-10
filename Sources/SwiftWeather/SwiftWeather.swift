//  Created by Mike Manzo on 5/10/20.

import Foundation


public typealias WeatherDeviceID = String


public protocol WeatherPlatform {
    func getHistoricalMeasurements(device: WeatherDeviceID, count: Int, completionHandler: @escaping ([WeatherReport]?) -> Void)
    func getLastMeasurement(device: WeatherDeviceID, completionHandler: @escaping (WeatherReport?) -> Void)
    func setupService(completionHandler: @escaping (WeatherServiceStatus) -> Void)
}


public protocol WeatherDevice: Codable, CustomStringConvertible {
    var ID: WeatherDeviceID { get }
}


public protocol WeatherReport: Codable, CustomStringConvertible {
    /// The date & time at which the report was generated.
    var date: Date { get }

    /// Returns all the sensors in the report.
    var sensors: [WeatherSensor] { get }
}


public enum WeatherServiceStatus {
    case NotReporting
    case Reporting([WeatherDeviceID: WeatherDevice])
    case Error(Error)
}


public enum WeatherServiceType: String, Codable {
    case AmbientWeather
}


public class SwiftWeather {
    /// Initialize the desired service using a platform model
    /// - Parameters:
    ///   - weatherServiceType: desired weather service.
    ///   - apiKeys: key(s) that are required to initialize the service; it's up to the resulting service to handle the order and # of keys.
    /// - Returns: A new weather platform of the requested type.
    public static func create(weatherServiceType: WeatherServiceType, apiKeys: [String]) throws -> WeatherPlatform {
        switch weatherServiceType {
        case .AmbientWeather:
            return try AmbientWeather(apiKeys: apiKeys)
        }
    }
}
