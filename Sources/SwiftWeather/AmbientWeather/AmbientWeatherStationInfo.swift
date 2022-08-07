//  Created by Mike Manzo on 5/10/20.

import Foundation

public class AmbientWeatherStationInfo: Codable {
    public let name: String?
    public let location: String?
    public let geolocation: AmbientWeatherStationGeolocation?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case location = "location"
        case geolocation = "coords"
    }
}

extension AmbientWeatherStationInfo: CustomStringConvertible {
    public var description: String {
        """
        Info:
        Name: \(name ?? "Unknown Name")
        Location: \(location ?? "Unknown Location")
        \(geolocation?.description ?? "Unknown Location")
        """
    }
}
