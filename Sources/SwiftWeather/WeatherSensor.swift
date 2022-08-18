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
    /// The weather sensor type.
    ///
    /// In addition to direct utility for e.g. categorising / grouping sensors in UI, this can be helpful to infer the units of the ``measurement`` - but only when ``measurement`` isn't a ``Measurement`` instance.  When it is such an instance the exact units are specified within the measurement.
    public let type: WeatherSensorType

    /// A unique identifier for this sensor within the given device.
    ///
    /// This identifier is not guaranteed to be consistent across different weather devices or weather platforms.
    public let ID: String

    /// A human-readable name for the sensor.
    ///
    /// e.g. "Outdoor Humidity", "Weekly Rain", "Date", "Wind Direction", etc.
    ///
    /// This should not be used for identification, as it is:
    ///   * Not guaranteed to be unique within any given weather device.
    ///   * Not guaranteed to be consistent across weather devices or platforms.
    ///   * Subject to change over time.
    ///
    /// Use ``ID`` to uniquely identify a sensor within a weather device.
    public let name: String

    /// A human-readable description of the sensor.
    ///
    /// This may provide additional details or context regarding the sensor.
    public let description: String

    /// The sensor measurement.
    ///
    /// Most sensors use the Foundation ``Measurement`` data type, but some use other types - e.g. ``Date`` for dates & times, ``Int`` for battery status / levels, etc.
    public let measurement: Any

    /// The unit of the measurement.
    ///
    /// When the ``measurement`` is a ``Measurement``, the units are also specified in that ``Measurement`` instance.  This property exists mainly to support non-``Measurement`` values for ``measurement``.
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
    /// A FormatStyle that creates human-readable representations, as ``String``s, from ``WeatherSensor``s.
    ///
    /// Warning: while nominally this supports the ``Codable`` protocol (as required of all FormatStyles), it actually does not.  Attempts to use it for coding or decoding will throw an exception.
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

        /// Initialises a new format style with the specified configuration.
        ///
        /// - Parameters:
        ///   - components: Specifies which data components are included in the output.
        ///   - numbers: Specifies how to format numbers (sensor measurement values, where applicable).
        ///   - dates: Specifies how to format dates (sensor measurement values, where applicable).
        ///   - units: Specifies how to format units w.r.t. equivalent scales (e.g. Celsius vs Fahrenheit).
        ///
        ///      Note that this only applies to ``WeatherSensor/measurement``s  that are ``Measurement`` instances - for all other types, where the units are only available via ``WeatherSensor/unit``, the units are used as-is.
        ///   - unitStyle: Specifies how to format units w.r.t. style / brevity.
        ///
        ///      Note that this only applies to ``WeatherSensor/measurement``s  that are ``Measurement`` instances - for all other types, where the units are only available via ``WeatherSensor/unit``, the units are used as-is.
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

            self.measurementFormatter.numberFormatter = self.numbers
            self.measurementFormatter.unitStyle = self.unitStyle
            self.measurementFormatter.unitOptions = self.units
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

    /// Returns a human-readable string representation of the sensor with the given formatting style / configuration.
    public func formatted<S>(_ style: S) -> S.FormatOutput where S : Foundation.FormatStyle, S.FormatInput == WeatherSensor {
        style.format(self)
    }

    /// Returns a human-readable string representation of the sensor.
    ///
    /// This representation is guaranteed to include the sensor name and measurement (including units), but other information - such as type, its description, and unique ID - might or might not be included.
    ///
    /// The representation might change in future versions of ``SwiftWeather``.
    ///
    /// If you need specific formatting, or formatting that is consistent across all versions of ``SwiftWeather``, use ``formatted(_:)``.
    public func formatted() -> String {
        WeatherSensor.defaultFormatter.format(self)
    }
}
