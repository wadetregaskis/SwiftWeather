//  Created by Mike Manzo on 5/10/20.

import Foundation


public typealias WeatherDeviceID = String


public protocol WeatherPlatform {
    /// All ``WeatherDevice``s reported by the platform.
    ///
    /// Which devices are listed depends on the nature and configuration of the platform - e.g. which API key(s) were used.  This property does _not_ list all devices globally available on the platform.  For platforms which don't have an implied list of devices based on their configuration parameters, this property may be empty - for such platforms, use other methods or properties for finding weather devices.
    var devices: [WeatherDeviceID: WeatherDevice] { get async throws }
}


public protocol WeatherDevice: Codable, CustomStringConvertible {
    /// The platform the provides access to this device.
    ///
    /// While actual weather stations (in the real-world sense) can publish data to multiple platforms, each `WeatherDevice` represents a specific platform & device combination.  The same station reported via multiple platforms will appear as distinct `WeatherDevice` instances, which may even have different ``ID``s.
    var platform: WeatherPlatform { get }

    /// The unique identifier for this weather device within the source ``platform``.
    ///
    /// While actual weather stations (in the real-world sense) can publish data to multiple platforms, each `WeatherDevice` represents a specific platform & device combination.  The same station reported via multiple platforms will appear as distinct `WeatherDevice` instances, which may even have different ``ID``s.
    var ID: WeatherDeviceID { get }

    /// The latest report.  This is just a convenience over calling ``latestReports(count:)`` or ``reports(count:upToAndIncluding:)``.
    var latestReport: WeatherReport { get async throws }

    /// Fetches the latest report(s).
    ///
    /// Note that the returned stream may eagerly fetch reports, ahead of the consumption rate.  This is generally preferable as it helps hide network latency (especially if multiple round trips are required to a server in order to fetch all `count` requested reports), but be aware that if your processing of the returned stream is slow there may be non-trivial memory usage from unread reports stacking up.
    ///
    /// - Parameter count: Number of reports to retrieve.  Must be at least one.
    /// - Returns: A stream of reports in reverse chronological order (i.e. starting with the newest).
    func latestReports(count: Int) -> AsyncThrowingStream<WeatherReport, Error>

    /// Fetches the report(s) leading up to the given date.
    ///
    /// Note that the returned stream may eagerly fetch reports, ahead of the consumption rate.  This is generally preferable as it helps hide network latency (especially if multiple round trips are required to a server in order to fetch all `count` requested reports), but be aware that if your processing of the returned stream is slow there may be non-trivial memory usage from unread reports stacking up.
    ///
    /// - Parameter count: Number of reports to retrieve.  Must be at least one.
    /// - Parameter upToAndIncluding: The end date for the returned reports.
    /// - Returns: A stream of reports in reverse chronological order (i.e. starting with the newest).
    func reports(count: Int, upToAndIncluding: Date) -> AsyncThrowingStream<WeatherReport, Error>
}


public protocol WeatherReport: Codable, CustomStringConvertible {
    /// The date & time at which the report was generated.
    var date: Date { get }

    /// Returns all the sensors in the report.
    var sensors: [WeatherSensor] { get }
}


public enum WeatherPlatformType: Codable {
    case AmbientWeather(applicationKey: String, apiKey: String)
}


public class SwiftWeather {
    /// Initialize the desired service using a platform model
    /// - Parameter weatherServiceType: Desired weather service.
    /// - Returns: A new weather platform of the requested type.
    public static func create(weatherServiceType: WeatherPlatformType) throws -> WeatherPlatform {
        switch weatherServiceType {
        case .AmbientWeather(let applicationKey, let apiKey):
            return try AmbientWeather(applicationKey: applicationKey, apiKey: apiKey)
        }
    }
}
