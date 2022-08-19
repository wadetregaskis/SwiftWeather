//  Created by Mike Manzo on 5/10/20.

import Foundation
import CoreLocation

public class AmbientWeatherStationGeoType: Codable {
    private let coordinates: [Double]
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case coordinates = "coordinates"
    }
    
    /// If the data is present, return a CLLocation object from the reporting lat/lon
    var latLon: CLLocation? {
        if coordinates[0] != -1000.0 && coordinates[1] != -1000 {
            return CLLocation(latitude: coordinates[1], longitude: coordinates[0])
        } else {
            return nil
        }
    }
    
    /// If the data is present, return a CLLocationCoordinate2D object from the reporting lat/lon
    var coordinate: CLLocationCoordinate2D? {
        guard let latLon else { return nil }

        return latLon.coordinate
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            type = try container.decodeIfPresent(String.self, forKey: .type) ?? "XXX"
            coordinates = try container.decodeIfPresent([Double].self, forKey: .coordinates) ?? [-1000.0]
        } catch let error as DecodingError {
            throw error
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        do {
            try container.encode(type, forKey: .type)
            try container.encode(coordinates, forKey: .coordinates)
        } catch let error as EncodingError {
            throw error
        }
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
