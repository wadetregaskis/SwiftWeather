//  Created by Mike Manzo on 5/10/20.

import Foundation

/// Supported Service Types
public enum WeatherSensorType {
    case WindDirection
    case Temperature
    case AirQuality
    case WindSpeed
    case Radiation
    case RainRate
    case Humidity
    case RainDate
    case Pressure
    case Battery
    case General
    case Rain
}

/// 
/// Base sensor descriptor for SwiftWeather
/// Generic descriptors:
/// - _description: What the sensor does
/// - _sensorID: Uniqe Identifier of of the sensor
/// - _unit: What the measurements are in (e.g., in, W, F, etc)
/// - _name: What do you want to call the sensor
/// - _value: Current measurement for the sensor
///
open class WeatherSensor {
    internal var _type: WeatherSensorType
    internal var _description: String
    internal var _sensorID: String
    internal var _unit: String
    internal var _name: String
    internal var _value: Any
    
    /// Return the value of the measurement for this sensor as reported by the API
    open var measurement: Any {
        return _value
    }
    
    /// Return the value of the measurement for this sensor as reported by the API
    open var type: WeatherSensorType {
        return _type
    }
    
    /// Return the user-defined name for this sensor
    open var name: String {
        return _name
    }
    
    /// Return the api-defined ID for this sensor
    open var sensorID: String {
        return _sensorID
    }
    
    /// Return the ap-defined default unit for this sensor
    open var unit: String {
        return _unit
    }
    
    /// Return the user-defined description for this sensor
    open var description: String {
        return _description
    }
    
    ///
    /// A compact way to progamatically represent a "sensor" as defined in the API docs
    /// - Parameters:
    ///   - type: sensor type (e.g.,  Temperature, AirQuality, Pressure, Battery, Humidty, General, Rain, Wind)
    ///   - name: user-defined name for the senor
    ///   - sensorID: api-defined JSON key for the sensor
    ///   - measurement: the current value the sensor is reporting
    ///   - unit: api-defined default unit
    ///   - desc: user-defined free-text description of what the sensor does and/or measures
    ///
    required public init (type: WeatherSensorType, name: String, sensorID: String, measurement: Any, unit: String, desc: String) {
        _value = measurement
        _sensorID = sensorID
        _description = desc
        _name = name
        _unit = unit
        _type = type
    }
}

extension MeasurementFormatter.UnitOptions: Hashable {}
extension Formatter.UnitStyle: Hashable {}

extension WeatherSensor { // Formatting
    public struct FormatStyle: Foundation.FormatStyle {
        public typealias FormatInput = WeatherSensor
        public typealias FormatOutput = String

        public struct Components: OptionSet, Hashable, Sendable {
            public static let name =         Components(rawValue: 0b00000001)
            public static let valueAndUnit = Components(rawValue: 0b00000110)
            public static let unit =         Components(rawValue: 0b00000100)
            public static let description =  Components(rawValue: 0b00001000)
            public static let type =         Components(rawValue: 0b00010000)
            public static let sensorID =     Components(rawValue: 0b00100000)

            public let rawValue: UInt8

            public init(rawValue: UInt8) {
                self.rawValue = rawValue
            }
        }

        public var components: Components
        public var units: MeasurementFormatter.UnitOptions {
            didSet { measurementFormatter.unitOptions = units }}
        public var unitStyle: MeasurementFormatter.UnitStyle {
            didSet { measurementFormatter.unitStyle = unitStyle }}
        public var numbers: NumberFormatter {
            didSet { measurementFormatter.numberFormatter = numbers }}
        public var dates: Date.FormatStyle

        private var measurementFormatter = MeasurementFormatter()

        private func recreateMeasurementFormatter() {
            let formatter = MeasurementFormatter()
            formatter.unitOptions = units
            formatter.unitStyle = unitStyle
            formatter.numberFormatter = numbers
        }

        public init(components: Components = [.name, .valueAndUnit],
                    numbers: NumberFormatter? = nil,
                    dates: Date.FormatStyle = .dateTime,
                    units: MeasurementFormatter.UnitOptions = .naturalScale,
                    unitStyle: MeasurementFormatter.UnitStyle = .short) {
            self.components = components
            self.units = units
            self.unitStyle = unitStyle
            self.numbers = numbers ?? {
                let formatter = NumberFormatter()
                formatter.maximumFractionDigits = 1
                return formatter
            }()
            self.dates = dates
        }

        public func format(_ value: WeatherSensor) -> String {
            var result = [String]()

            if components.contains(.name) {
                if components.contains(.sensorID) {
                    result.append("\(value.name) (\(value.sensorID))")
                } else {
                    result.append(value.name)
                }
            } else if components.contains(.sensorID) {
                result.append(value.sensorID)
            }

            if components.contains(.type) {
                if components.isEmpty {
                    result.append(String(describing: value.type))
                } else {
                    result.append("[\(value.type)]")
                }
            }

            if !result.isEmpty && !components.isSubset(of: [.name, .sensorID, .type]) {
                result[result.count - 1].append(":")
            }

            if components.contains(.valueAndUnit) {
                if let date = value.measurement as? Date {
                    result.append(dates.format(date))
                } else if value.type == .Battery, let measurement = value.measurement as? Int {
                    switch measurement {
                    case 0:
                        result.append("Low")
                    case 1:
                        result.append("Good")
                    default:
                        result.append("Unknown (\(measurement))")
                    }
                } else {
                    result.append(measurementFormatter.string(for: value.measurement)
                                  ?? String(describing: value.measurement))
                }
            } else if components.contains(.unit) {
                result.append(value.unit) // TODO:  Use the proper Unit from the Measurement, where applicable.  Unfortunately doing so appears to be impossible given the Measurement is hidden behind Any and there's no way to cast it back.
            }

            if components.contains(.description) {
                if result.isEmpty {
                    result.append(value.description)
                } else {
                    result.append("(\(value.description))")
                }
            }

            return result.joined(separator: " ")
        }

        enum Error: Swift.Error {
            case notImplemented
        }

        public init(from: Decoder) throws {
            throw Error.notImplemented
        }

        public func encode(to: Encoder) throws {
            throw Error.notImplemented
        }
    }

    private static let defaultFormatter = FormatStyle()

    public func formatted<S>(_ style: S) -> S.FormatOutput where S : Foundation.FormatStyle, S.FormatInput == WeatherSensor {
        style.format(self)
    }

    public func formatted() -> String {
        WeatherSensor.defaultFormatter.format(self)
    }
}
