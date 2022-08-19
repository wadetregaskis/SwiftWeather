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

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            location = try container.decodeIfPresent(String.self, forKey: .location)
            address = try container.decodeIfPresent(String.self, forKey: .address)
            elevation = try container.decodeIfPresent(Double.self, forKey: .elevation)
            geoType = try container.decodeIfPresent(AmbientWeatherStationGeoType.self, forKey: .geoType)
        }
        catch let error as DecodingError {
            throw error
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        do {
            try container.encode(location, forKey: .location)
            try container.encode(address, forKey: .address)
            try container.encode(elevation, forKey: .elevation)
            try container.encode(geoType, forKey: .geoType)
        } catch let error as EncodingError {
            throw error
        }
    }
}

extension AmbientWeatherStationGeolocation: CustomStringConvertible {
    public var description: String {
        """
        GeoLocation:
        \t\tLocation: \(location ?? "Unknown")
        \t\tAddress: \(address ?? "Unknown")
        \t\tElevation: \(elevation ?? -1.0)
        \t\t\(geoType?.description ?? "Unknown coordinates")
        """
    }
}
