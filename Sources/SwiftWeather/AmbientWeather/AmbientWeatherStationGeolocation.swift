//  Created by Mike Manzo on 5/10/20.

import Foundation
import CoreLocation

public class AmbientWeatherStationGeolocation: Codable {
    let location: String?
    let address: String?
    let elevation: Double?
    let geoType: AmbientWeatherStationGeoType?
    
    enum CodingKeys: String, CodingKey {
        case elevation = "elevation"
        case location = "location"
        case address = "address"
        case geoType = "geo"
    }
    
    /// If the data is present, return a CLLocation object from the reporting lat/lon
    open var position: CLLocation? {
        guard let coordinate = geoType?.coordinate else {return nil}
        guard let altitude = elevation else {return nil}
        return CLLocation(coordinate: coordinate,
                          altitude: altitude,
                          horizontalAccuracy: kCLLocationAccuracyNearestTenMeters,
                          verticalAccuracy: kCLLocationAccuracyNearestTenMeters,
                          timestamp: Date())
    }
}

extension AmbientWeatherStationGeolocation: CustomStringConvertible {
    public var description: String {
        """
        GeoLocation:
        \t\tLocation: \(location ?? "Unknown")
        \t\tAddress: \(address ?? "Unknown")
        \t\tElevation: \(elevation?.description ?? "Unknown")
        \t\t\(geoType?.description ?? "Unknown coordinates")
        """
    }
}
