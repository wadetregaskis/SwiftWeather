//  Created by Mike Manzo on 5/17/20.

import CoreLocation
import Foundation

///
/// [Ambient Weather Device Specification](https://github.com/ambient-weather/api-docs/wiki/Device-Data-Specs)
///
open class AmbientWeatherDevice: WeatherDevice {
    private let info: AmbientWeatherStationInfo?
    private let macAddress: WeatherDeviceID

    enum CodingKeys: String, CodingKey {
        case macAddress = "macAddress"
        case info = "info"
    }

    internal(set) public var platform: WeatherPlatform

    public var ID: WeatherDeviceID {
        return macAddress
    }
    
    /// Return the station info.  Note, this returns all info the *user* has entered for the device
    public var information: AmbientWeatherStationInfo? {
        return info
    }

    required public init(from decoder: Decoder) throws {
        guard let platform = decoder.userInfo[AmbientWeather.platformCodingUserInfoKey] as? AmbientWeather else {
            throw AmbientWeatherError.platformMissingFromDecoderUserInfo
        }

        self.platform = platform

        let container = try decoder.container(keyedBy: CodingKeys.self)

        macAddress = try container.decodeIfPresent(String.self, forKey: .macAddress) ?? "XXX"
        //let latestData = try container.decode(AmbientWeatherStationData.self, forKey: .lastData)
        info = try container.decode(AmbientWeatherStationInfo.self, forKey: .info)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(macAddress, forKey: .macAddress)
        try container.encode(info, forKey: .info)
    }
}

extension AmbientWeatherDevice: CustomStringConvertible {
    public var description: String {
        """
        ID (MAC Address): \(ID)
        \(info?.description ?? "INFO: Error")
        """
    }
}
