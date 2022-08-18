//  Created by Mike Manzo on 5/10/20.

import Foundation

/// Supported Service Types
public enum WeatherSensorType {
    case AirQuality
    case Battery
    case General
    case Humidity
    case Pressure
    case Radiation
    case Rain
    case RainDate
    case RainRate
    case Temperature
    case WindDirection
    case WindSpeed
}

/// Base class for weather sensors.
open class WeatherSensor {
    public let type: WeatherSensorType
    public let ID: String
    public let name: String
    public let description: String
    public let measurement: Any
    public let unit: String

    required public init(type: WeatherSensorType,
                         sensorID: String,
                         name: String,
                         description: String,
                         measurement: Any,
                         unit: String) {
        self.type = type
        self.ID = sensorID
        self.name = name
        self.description = description
        self.measurement = measurement
        self.unit = unit
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
                    result.append("\(value.name) (\(value.ID))")
                } else {
                    result.append(value.name)
                }
            } else if components.contains(.sensorID) {
                result.append(value.ID)
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
