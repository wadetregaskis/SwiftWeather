//
//  AWDevice.swift
//  
//
//  Created by Mike Manzo on 5/17/20.
//

import CoreLocation
import Foundation

///
/// [Ambient Weather Device Specification](https://github.com/ambient-weather/api-docs/wiki/Device-Data-Specs)
///
open class AWDevice: SWKDevice/*, Codable*/ {
    private let info: AWStationInfo?
    private let macAddress: String?
    public let lastData: AWStationData?
    
    enum CodingKeys: String, CodingKey {
        case macAddress = "macAddress"
        case lastData = "lastData"
        case info = "info"
    }
    
    /// Return the timestamp from lastData, as a NSDate in UTC
    public var timestamp: NSDate {
        return Date(timeIntervalSince1970: TimeInterval(lastData!.dateUTC / 1000))
    }
   
    /// Return any humidity sensors
    public var humiditySensors: [AWSensor] {
        return lastData!.HumiditySensors
    }

    /// Return any battery sensors
    public var batterySensors: [AWSensor] {
        return lastData!.BatterySensors
    }
 
    /// Return any miscellaneous sensors
    public var miscellaneousSensors: [AWSensor] {
        return lastData!.MiscSensors
    }

    /// Return any pressure sensors
    public var pressureSensors: [AWSensor] {
        return lastData!.PressureSensors
    }

    /// Return any rain sensors
    public var rainSensors: [AWSensor] {
        return lastData!.RainSensors
    }

    /// Return any relay sensors
    public var relaySensors: [AWSensor] {
        return lastData!.RelaySensors
    }

    /// Return any temperature sensors
    public var temperatureSensors: [AWSensor] {
        return lastData!.TemperatureSensors
    }
    
    /// Return any wind sensors
    public var windSensors: [AWSensor] {
        return lastData!.WindSensors
    }

    /// Return any air quality sensors
    public var airQualitySensors: [AWSensor] {
        return lastData!.AirQualitySensors
    }

    /// Return the MAC Address of the device as reported by AmbientWeather.net
    public var deviceID: String? {
        return macAddress
    }
    
    /// Return the station info.  Note, this returns all info the *user* has entered for the device
    public var information: AWStationInfo? {
        return info
    }
    
    /// Return the station location (if available).
    public var position:  CLLocation? {
        return info?.geo.position
    }
    
   /// Returns an array containing all sensors that are reporting
    public var sensors: [AWSensor] {
        return lastData!.availableSensors as! [AWSensor]
    }
    
    /// Returns an array containing of reporting sensor types
    public var availabeSensorTypes: [SWKSensorType] {
        return lastData!.availabeSensorTypes
    }
    
    ///
    /// Provides a simple way to "see" what ths device is reporting
    ///
    public var prettyString: String {
        let debugInfo = """
        MAC Address: \(macAddress!)
        \(info?.prettyString ?? "INFO: Error")
        """
        return debugInfo
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
            lastData = try container.decode(AWStationData.self, forKey: .lastData)
            info = try container.decode(AWStationInfo.self, forKey: .info)
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
