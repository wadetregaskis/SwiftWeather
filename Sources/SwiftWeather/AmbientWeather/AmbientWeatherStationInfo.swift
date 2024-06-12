//  Created by Mike Manzo on 5/10/20.

public struct AmbientWeatherStationInfo: Codable, Sendable {
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
        Name: \(name ?? "Unknown")
        Location: \(location ?? "Unknown")
        \(geolocation?.description ?? "Unknown Location")
        """
    }
}
