//  Created by Mike Manzo on 5/10/20.

import CoreLocation

public class AmbientWeatherStationGeoType: Codable {
    private let coordinates: [Double]
    let type: String

    /// If the data is present, return a CLLocation object from the reporting lat/lon
    var latLon: CLLocation? {
        guard 2 <= coordinates.count else {
            return nil
        }

        return CLLocation(latitude: coordinates[1], longitude: coordinates[0])
    }
    
    /// If the data is present, return a CLLocationCoordinate2D object from the reporting lat/lon
    var coordinate: CLLocationCoordinate2D? {
        guard let latLon else { return nil }

        return latLon.coordinate
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
