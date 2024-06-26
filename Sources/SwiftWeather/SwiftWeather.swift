//  Created by Mike Manzo on 5/10/20.

public import CoreLocation
internal import Foundation


/// The type for all weather device IDs.
///
/// Though this _happens_ to be a String currently, you should not assume that will always be the case.  You may assume it is Equatable, Hashable, and CustomStringConvertible.
public typealias WeatherDeviceID = String


/// A service that provides access to weather devices & their sensor data.
///
/// Currently this exposes no methods or properties.  It might in future.  Even in their absence, it can be convenient as a way to refer abstractly to a weather platform (e.g. if you wish to store a heterogeneous collection of platforms you're using, which can be convenient for providing a user interface that allows your user to select which platform to work with).
public protocol WeatherPlatform: Sendable {}


/// A weather device (e.g. weather station) that reports weather data for a specific location.
public protocol WeatherDevice: Sendable, CustomStringConvertible {
    associatedtype Platform

    /// The platform the provides access to this device.
    ///
    /// While actual weather stations (in the real-world sense) can publish data to multiple platforms, each ``WeatherDevice`` represents a specific platform & device combination.  The same station reported via multiple platforms will appear as distinct WeatherDevice instances, which may even have different ``ID``s.
    var platform: Platform { get }

    /// The unique identifier for this weather device within the source ``platform``.
    ///
    /// While actual weather stations (in the real-world sense) can publish data to multiple platforms, each ``WeatherDevice`` represents a specific platform & device combination.  The same station reported via multiple platforms will appear as distinct WeatherDevice instances, which may even have different ``ID``s.
    var ID: WeatherDeviceID { get }

    /// The name of the weather device, as specified by its owner.
    var name: String? { get }

    /// The location of the weather device, as specified by its owner.
    ///
    /// The format of this field is undefined - it is typically freeform text set by the owner.  Thus it could be anything from precise latitude & longitude to a street address to a region name to something abstract like "Home".
    var locationSummary: String? { get }

    /// The location of the weather device.
    ///
    /// It is unusual to find a weather device that does _not_ provide its geolocation, but it is possible.  You should handle this gracefully (e.g. by deferring to ``locationSummary`` or ``name`` if possible).
    ///
    /// The precision of this location is undefined, and may vary between platforms and stations.  Likewise it might or might not include elevation.
    var location: CLLocation? { get }

    /// The address of the weather device, as specified by its owner.
    ///
    /// This is not guaranteed to be correct, or even to match ``location``.  It might be specified manually by the device owner.  Its format is undefined.
    ///
    /// You may wish to reverse-geocode the address based on ``location`` (if available) when technical accuracy is most important.
    var address: String? { get }

    /// The latest report.  This is just a convenience over calling ``latestReports(count:)`` or ``reports(count:upToAndIncluding:)``.
    var latestReport: any WeatherReport { get async throws }

    /// Fetches the latest report(s).
    ///
    /// Note that the returned stream may eagerly fetch reports, ahead of the consumption rate.  This is generally preferable as it helps hide network latency (especially if multiple round trips are required to a server in order to fetch all `count` requested reports), but be aware that if your processing of the returned stream is slow there may be non-trivial memory usage from unread reports stacking up.
    ///
    /// - Parameter count: Number of reports to retrieve.  Must be at least one.
    /// - Returns: A stream of reports in reverse chronological order (i.e. starting with the newest).  Note that this may be empty.
    func latestReports(count: Int) -> AsyncThrowingStream<any WeatherReport, any Error>

    /// Fetches the report(s) leading up to the given date.
    ///
    /// Note that the returned stream may eagerly fetch reports, ahead of the consumption rate.  This is generally preferable as it helps hide network latency (especially if multiple round trips are required to a server in order to fetch all `count` requested reports), but be aware that if your processing of the returned stream is slow there may be non-trivial memory usage from unread reports stacking up.
    ///
    /// - Parameter count: Number of reports to retrieve.  Must be at least one.
    /// - Parameter upToAndIncluding: The end date for the returned reports.
    /// - Returns: A stream of reports in reverse chronological order (i.e. starting with the newest).  Note that this may be empty, if the device simply has no reports available prior to the given date.
    func reports(count: Int, upToAndIncluding: Date) -> AsyncThrowingStream<any WeatherReport, any Error>
}


/// The type for all weather sensor IDs.
///
/// Though this _happens_ to be a String currently, you should not assume that will always be the case.  You may assume it is Equatable, Hashable, and CustomStringConvertible.
public typealias WeatherSensorID = String


/// A specific report from a ``WeatherDevice``, containing sensor measurements for a particular date & time.
public protocol WeatherReport: Codable, CustomStringConvertible {
    /// The date & time at which the report was generated.
    var date: Date { get }

    /// Returns all the sensors in the report.
    var sensors: [WeatherSensorID: WeatherSensor] { get }
}

extension WeatherReport {
    public var description: String {
        sensors.sorted { $0.key < $1.key }.map { $0.value.formatted() }.joined(separator: "\n")
    }
}
