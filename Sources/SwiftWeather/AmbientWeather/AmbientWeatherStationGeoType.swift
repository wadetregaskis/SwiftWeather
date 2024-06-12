//  Created by Mike Manzo on 5/10/20.

public import CoreLocation

public struct AmbientWeatherStationGeoType: Codable, Sendable {
    private let coordinates: [Double]
    public let type: String

    /// If the data is present, return a CLLocationCoordinate2D object from the reporting lat/lon
    public var coordinate: CLLocationCoordinate2D? {
        guard 2 <= coordinates.count else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
    }
}

extension AmbientWeatherStationGeoType: CustomStringConvertible {
    public var description: String {
        """
        Coordiates:
        \t\tType: \(type)
        \t\tLatitude: \(coordinates[0])
        \t\tLongitude: \(coordinates[1])
        """
    }
}
