//  Created by Mike Manzo on 5/10/20.

import Foundation
import CoreLocation

public class AmbientWeatherStationCoordinates: Codable {
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    /// If the data is present, return a CLLocation object from the reporting lat/lon
    open var latLon: CLLocation? {
        if latitude != nil && longitude != nil {
            return CLLocation(latitude: latitude!, longitude: longitude!)
        } else {
            return nil
        }
    }
}
