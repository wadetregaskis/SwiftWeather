//  Created by Mike Manzo on 5/10/20.

import Foundation


public typealias WeatherDeviceID = String


public protocol WeatherPlatform {
    var devices: [WeatherDeviceID: WeatherDevice] { get async throws }
}


public protocol WeatherDevice: Codable, CustomStringConvertible {
    var platform: WeatherPlatform { get }
    var ID: WeatherDeviceID { get }

    /// The latest report.  This is just a convenience over calling latestReports(count:) or reports(count:upToAndIncluding:).
    var latestReport: WeatherReport { get async throws }

    /// Fetches the latest report(s).
    /// - Parameter count: Number of reports to retrieve.  Must be at least one.
    /// - Returns A stream of reports in reverse chronological order (i.e. starting with the newest).
    func latestReports(count: Int) -> AsyncThrowingStream<WeatherReport, Error>

    /// Fetches the report(s) leading up to the given date.
    /// - Parameter count: Number of reports to retrieve.  Must be at least one.
    /// - Parameter upToAndIncluding: The end date for the returned reports.
    /// - Returns A stream of reports in reverse chronological order (i.e. starting with the newest).
    func reports(count: Int, upToAndIncluding: Date) -> AsyncThrowingStream<WeatherReport, Error>
}


public protocol WeatherReport: Codable, CustomStringConvertible {
    /// The date & time at which the report was generated.
    var date: Date { get }

    /// Returns all the sensors in the report.
    var sensors: [WeatherSensor] { get }
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
