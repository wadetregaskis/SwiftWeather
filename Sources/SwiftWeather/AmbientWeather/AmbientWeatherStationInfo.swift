//  Created by Mike Manzo on 5/10/20.

import Foundation

public class AmbientWeatherStationInfo: Codable {
    private let stationGeoLocation: AmbientWeatherStationGeolocation
    private let stationLocation: String?
    private let stationName: String?
    
    enum CodingKeys: String, CodingKey {
        case stationGeoLocation = "coords"
        case stationLocation = "location"
        case stationName = "name"
    }
    
    /// Return the user-defined name of the device (station)
    public var name: String? {
        get { return stationName }
    }
    
    /// Return the userdefined location of the device (station)
    public var location: String? {
        get { return stationLocation }
    }
    
    /// Return a AmbientWeatherStationGeolocation object
    public var geo: AmbientWeatherStationGeolocation {
        get { return stationGeoLocation }
    }
    
    ///
    /// Empty init
    ///
    init () {
        stationLocation = nil
        stationName = nil
        stationGeoLocation = AmbientWeatherStationGeolocation()
    }
    
    ///
    /// Public & Codeable Initializer ... this creates the object and populates it w/ the JSON-derived decoer
    /// - Parameter decoder: JSON_Derived decoder
    /// - Throws: a decoding error if something has gone wrong
    ///
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            stationLocation = try container.decodeIfPresent(String.self, forKey: .stationLocation)
            stationName = try container.decodeIfPresent(String.self, forKey: .stationName)
            stationGeoLocation = try container.decodeIfPresent(AmbientWeatherStationGeolocation.self, forKey: .stationGeoLocation) ?? AmbientWeatherStationGeolocation()
        } catch let error as DecodingError {
            throw error
        }
    }
    
    /// We have to roll our own Codable class due to MKMeteoPolyline
    ///
    /// - Parameter encoder: encoder to act on
    /// - Throws: error
    ///
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        do {
            try container.encode(stationLocation, forKey: .stationLocation)
            try container.encode(stationName, forKey: .stationName)
            try container.encode(stationGeoLocation, forKey: .stationGeoLocation)
        } catch let error as EncodingError {
            throw error
        }
    }
}

extension AmbientWeatherStationInfo: CustomStringConvertible {
    public var description: String {
        """
        Info:
        Name: \(name ?? "Unknown Name")
        Location: \(location ?? "Unknown Location")
        \(geo)
        """
    }
}
