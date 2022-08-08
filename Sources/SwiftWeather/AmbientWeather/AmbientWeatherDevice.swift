//  Created by Mike Manzo on 5/17/20.

import CoreLocation
import Foundation

///
/// [Ambient Weather Device Specification](https://github.com/ambient-weather/api-docs/wiki/Device-Data-Specs)
///
open class AmbientWeatherDevice: WeatherDevice {
    private let info: AmbientWeatherStationInfo?
    private let macAddress: WeatherDeviceID
    public let lastData: AmbientWeatherStationData?
    
    enum CodingKeys: String, CodingKey {
        case macAddress = "macAddress"
        case lastData = "lastData"
        case info = "info"
    }
    
    /// Return the timestamp from lastData, as a NSDate in UTC
    public var timestamp: Date? {
        guard let d = lastData?.dateUTC else {
            return nil
        }
        return Date(timeIntervalSince1970: TimeInterval(d / 1000))
    }
    
    /// Return any humidity sensors
    public var humiditySensors: [AmbientWeatherSensor] {
        return lastData!.HumiditySensors
    }
    
    /// Return any battery sensors
    public var batterySensors: [AmbientWeatherSensor] {
        return lastData!.BatterySensors
    }
    
    /// Return any miscellaneous sensors
    public var miscellaneousSensors: [AmbientWeatherSensor] {
        return lastData!.MiscSensors
    }
    
    /// Return any pressure sensors
    public var pressureSensors: [AmbientWeatherSensor] {
        return lastData!.PressureSensors
    }
    
    /// Return any rain sensors
    public var rainSensors: [AmbientWeatherSensor] {
        return lastData!.RainSensors
    }
    
    /// Return any relay sensors
    public var relaySensors: [AmbientWeatherSensor] {
        return lastData!.RelaySensors
    }
    
    /// Return any temperature sensors
    public var temperatureSensors: [AmbientWeatherSensor] {
        return lastData!.TemperatureSensors
    }
    
    /// Return any wind sensors
    public var windSensors: [AmbientWeatherSensor] {
        return lastData!.WindSensors
    }
    
    /// Return any air quality sensors
    public var airQualitySensors: [AmbientWeatherSensor] {
        return lastData!.AirQualitySensors
    }
    
    /// Return the MAC Address of the device as reported by AmbientWeather.net
    public var deviceID: WeatherDeviceID {
        return macAddress
    }
    
    /// Return the station info.  Note, this returns all info the *user* has entered for the device
    public var information: AmbientWeatherStationInfo? {
        return info
    }
    
    /// Return the station location (if available).
    public var position: CLLocation? {
        return info?.geolocation?.position
    }
    
    /// Returns an array containing all sensors that are reporting
    public var sensors: [AmbientWeatherSensor] {
        return lastData!.sensors as! [AmbientWeatherSensor]
    }
    
    ///
    /// Public & Codeable Initializer ... this creates the object and populates it w/ the JSON-derived decoder
    /// - Parameter decoder: JSON_Derived decoder
    /// - Throws: a decoding error if something has gone wrong
    ///
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            macAddress = try container.decodeIfPresent(String.self, forKey: .macAddress) ?? "XXX"
            lastData = try container.decode(AmbientWeatherStationData.self, forKey: .lastData)
            info = try container.decode(AmbientWeatherStationInfo.self, forKey: .info)
        } catch let error as DecodingError {
            throw error
        }
        
        //        try super.init(from: decoder)
    }
    
    /// We have to roll our own Codable class due to custom properties
    ///
    /// - Parameter encoder: encoder to act on
    /// - Throws: error
    ///
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        do {
            try container.encode(macAddress, forKey: .macAddress)
            try container.encode(lastData, forKey: .lastData)
            try container.encode(info, forKey: .info)
        } catch let error as EncodingError {
            throw error
        }
        
        //        try super.encode(to: encoder)
    }
}

extension AmbientWeatherDevice: CustomStringConvertible {
    public var description: String {
        """
        ID (MAC Address): \(deviceID)
        \(info?.description ?? "INFO: Error")
        """
    }
}
