//
//  SwiftWeatherKit.swift
//
//
//  Created by Mike Manzo on 5/10/20.
//

import Alamofire
import Foundation

/// Platform protocol for weather platforms to be added
public protocol WeatherPlatform {
    func getHistoricalMeasurements(uniqueID: String?, count: Int, completionHandler: @escaping ([WeatherDeviceData]?) -> Void)
    func getLastMeasurement(uniqueID: String?, completionHandler: @escaping (WeatherDeviceData?) -> Void)
    func setupService(completionHandler: @escaping (WeatherServiceStatus) -> Void)
    func description(uniqueID: String)
    
    var  reportingDevices: [[String: WeatherDevice]] { get }
}

public protocol WeatherDeviceData {
    var prettyString: String { get }
    var availableSensors: [WeatherSensor] { get }
}

/// Testing something
public protocol WeatherDevice: Codable {
    var prettyString: String { get }
    var deviceID: String? { get }
}

/// Testing something
/*
 public protocol WeatherReportingDevice {
 var prettyString: String { get }
 var deviceID: String? { get }
 }
 */

/// Service Status
public enum WeatherServiceStatus: Int {
    case NotReporting
    case Reporting
    case Error
}

/// Supported Service Types
public enum WeatherServiceType: Int {
    case Undefined
    case Ambient
}

extension WeatherServiceType: Codable {
    public static func enumvValue(value: Int) -> WeatherServiceType {
        switch value {
        case 0 : return .Undefined
        case 1 : return .Ambient
        default: return .Undefined
        }
    }
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .Undefined
        case 1:
            self = .Ambient
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        switch self {
        case .Undefined:
            try container.encode(0, forKey: .rawValue)
        case .Ambient:
            try container.encode(1, forKey: .rawValue)
        }
    }
}

/*
 /// Abstract base class for weather devices
 open class WeatherDevice: Codable, WeatherReportingDevice {
 public var deviceID: String? {
 return nil
 }
 
 public var prettyString: String {
 return ""
 }
 
 required public init(from decoder: Decoder) throws {
 // Empty
 }
 
 public func encode(to encoder: Encoder) throws {
 // empty
 }
 }*/

/// Weather Factory
public class SwiftWeather {
    public static let description = "Swift Weather"
    public static var WeatherFactory = SwiftWeather()
    
    open class func shared() -> SwiftWeather {
        return WeatherFactory
    }
    
    /// Initialize the desired service using a platform model
    /// - Parameters:
    ///   - weatherServiceType: desired weather service
    ///   - apiKeys: key(s) that are required to initialize the service; it's up to the resulting service to handle the order and # of keys.
    /// - Returns: a fully formed weather platform
    public func getService(weatherServiceType: WeatherServiceType, apiKeys: [String]) -> WeatherPlatform? {
        switch weatherServiceType {
        case .Ambient:
            return AmbientWeather(apiKeys: apiKeys)
        case .Undefined:
            return nil
        }
    }
}
