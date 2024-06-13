//  Created by Wade Tregaskis on 26/8/2022.

public import Foundation


open class WundergroundCurrentReport: WeatherReport {
    public var date: Date

    public let sensors: [WeatherSensorID: WeatherSensor]

    private static func sensor<Input: Codable & Sendable,
                               Keys: CodingKey & RawRepresentable,
                               UnitType: Unit & Sendable>(from json: KeyedDecodingContainer<Keys>,
                                                          _ ID: Keys,
                                                          _ valueType: Input.Type,
                                                          _ type: WeatherSensorType,
                                                          _ name: String,
                                                          _ unit: UnitType = Unit.none,
                                                          description: String? = nil,
                                                          converter: ((Input) throws -> any Sendable)? = nil) throws -> WeatherSensor?
                               where Keys.RawValue == String {
        guard let rawValue = try json.decodeIfPresent(Input.self, forKey: ID) else {
            return nil
        }

        var value = try converter?(rawValue) ?? rawValue

        if .none != unit {
            let valueAsDouble: Double

            if let valueAlreadyIsDouble = value as? Double {
                valueAsDouble = valueAlreadyIsDouble
            } else if let valueAsBinaryInteger = value as? any BinaryInteger {
                valueAsDouble = Double(valueAsBinaryInteger)
            } else {
                throw WeatherError.unsupportedSensorValueType(ID: ID.rawValue, value: value)
            }

            value = Measurement(value: valueAsDouble, unit: unit)
        }

        return WeatherSensor(type: type,
                             sensorID: ID.rawValue,
                             name: name,
                             description: description,
                             measurement: value)
    }

    private nonisolated(unsafe) static let dateFormatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter
    }()

    internal let stationID: String

    public required init(from decoder: any Decoder) throws {
        let json = try decoder.container(keyedBy: CodingKeys.self)

        self.stationID = try json.decode(type(of: self.stationID), forKey: .stationID)

        let metrics = try json.nestedContainer(keyedBy: MetricCodingKeys.self, forKey: .metric)

        self.sensors = try Dictionary(
            [WundergroundCurrentReport.sensor(from: json,
                                              .country,
                                              String.self,
                                              .General,
                                              "Country Code",
                                              description: "The country in which the weather device is located."),
             WundergroundCurrentReport.sensor(from: json,
                                              .epoch,
                                              Int.self,
                                              .Date,
                                              "Date",
                                              description: "Date & time at which the measurements were reported",
                                              converter: { Date(timeIntervalSince1970: Double($0)) }),
             WundergroundCurrentReport.sensor(from: json,
                                              .humidity,
                                              Double.self,
                                              .Humidity,
                                              "Humidity",
                                              Unit.percentage),
             WundergroundCurrentReport.sensor(from: json,
                                              .lat,
                                              Double.self,
                                              .General,
                                              "Latitude"),
             WundergroundCurrentReport.sensor(from: json,
                                              .lon,
                                              Double.self,
                                              .General,
                                              "Longitude"),
             WundergroundCurrentReport.sensor(from: json,
                                              .neighborhood,
                                              String.self,
                                              .General,
                                              "Neighbourhood"),
             WundergroundCurrentReport.sensor(from: json,
                                              .obsTimeUtc,
                                              String.self,
                                              .Date,
                                              "Date",
                                              description: "Date & time at which the measurements were reported",
                                              converter: {
                                                  guard let date = WundergroundCurrentReport.dateFormatter.date(from: $0) else {
                                                      throw WeatherError.invalidDate(string: $0, expectedFormat: "ISO-8601")
                                                  }

                                                  return date
                                              }),
             WundergroundCurrentReport.sensor(from: json,
                                              .qcStatus,
                                              WundergroundDevice.QualityControlStatus.self,
                                              .General,
                                              "Quality Control Status"),
             WundergroundCurrentReport.sensor(from: json,
                                              .realtimeFrequency,
                                              Double.self,
                                              .General,
                                              "Update Frequency",
                                              description: "Expected interval between reports from this weather device.",
                                              converter: { $0 * 60 }),
             WundergroundCurrentReport.sensor(from: json,
                                              .softwareType,
                                              String.self,
                                              .General,
                                              "Device Model",
                                              description: "The model and version of the weather device that generated this report."),
             WundergroundCurrentReport.sensor(from: json,
                                              .solarRadiation,
                                              Double.self,
                                              .Radiation,
                                              "Solar Radiation",
                                              Unit.wattsPerSquareMetre),
             WundergroundCurrentReport.sensor(from: json,
                                              .uv,
                                              Double.self,
                                              .Radiation,
                                              "UV Index",
                                              Unit.uv),
             WundergroundCurrentReport.sensor(from: json,
                                              .winddir,
                                              Double.self,
                                              .WindDirection,
                                              "Wind Direction",
                                              UnitAngle.degrees),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .dewpt,
                                              Double.self,
                                              .Temperature,
                                              "Dew Point",
                                              UnitTemperature.celsius,
                                              description: "The temperature at which humidity would be 100%.  Condensation / precipitation will form at temperatures below this threshold."),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .elev,
                                              Double.self,
                                              .General,
                                              "Elevation",
                                              UnitLength.meters,
                                              description: "The height above sea level of the weather device."),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .heatIndex,
                                              Double.self,
                                              .Temperature,
                                              "Heat Index",
                                              UnitTemperature.celsius,
                                              // TODO: Figure out what algorithm Wunderground uses, and whether it does in fact ignore wind speed.
                                              description: "The indoor \"feels like\" temperature - the temperature accounting for humidity (but ignoring wind speed) and how that affects the effectiveness of sweating and thus the perceived temperature."),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .precipRate,
                                              Double.self,
                                              .RainRate,
                                              "Rain Rate",
                                              UnitSpeed.millimetresPerHour),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .precipTotal,
                                              Double.self,
                                              .Rain,
                                              "Rain Today",
                                              UnitLength.millimeters),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .pressure,
                                              Double.self,
                                              .Pressure,
                                              "Relative Pressure",
                                              UnitPressure.millibars),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .temp,
                                              Double.self,
                                              .Temperature,
                                              "Temperature",
                                              UnitTemperature.celsius),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .windChill,
                                              Double.self,
                                              .Temperature,
                                              "Wind Chill",
                                              UnitTemperature.celsius,
                                              // TODO: Figure out what algorithm Wunderground uses, and whether it does in fact ignore humidity.  Wikipedia suggests it does, saying that in North America the old, overly-simplistic model of apparent temperature is typically used (e.g. by the National Weather Service).
                                              description: "The outdoor \"feels like\" temperature - the temperature accounting for wind speed (but ignoring humidity) and how that influences body temperature."),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .windGust,
                                              Double.self,
                                              .WindSpeed,
                                              "Wind Gust",
                                              UnitSpeed.kilometersPerHour),
             WundergroundCurrentReport.sensor(from: metrics,
                                              .windSpeed,
                                              Double.self,
                                              .WindSpeed,
                                              "Wind Speed",
                                              UnitSpeed.kilometersPerHour)]
            .compactMap {
                guard let value = $0 else { return nil }
                return (value.ID, value)
            },
            uniquingKeysWith: {
                throw WeatherError.conflictingSensorIDs($0, $1)
            })

        guard let dateSensor = self.sensors[CodingKeys.obsTimeUtc.rawValue] ?? self.sensors[CodingKeys.epoch.rawValue] else {
            throw WeatherError.missingReportDate(availableSensors: Array(self.sensors.keys))
        }

        guard let date = dateSensor.measurement as? Date else {
            throw WeatherError.unexpectedSensorValueType(sensorID: dateSensor.ID, value: dateSensor.measurement, expectedType: Date.self)
        }

        self.date = date
    }

    public func encode(to encoder: any Encoder) throws {
        var json = encoder.container(keyedBy: CodingKeys.self)

        for sensor in self.sensors {
            guard let codingKey = CodingKeys(rawValue: sensor.value.ID) else {
                throw AmbientWeatherError.sensorNotSupportedForCodable(sensor.value)
            }

            try json.encode(String(describing: sensor.value), forKey: codingKey)
        }
    }

    enum CodingKeys: String, CodingKey {
        case country
        case epoch
        case humidity
        case lat
        case lon
        case neighborhood
        //case obsTimeLocal // Useless without knowing the time zone, which _maybe_ could be deduced from the lat & lon but in any case it's pointless since there's "obsTimeUtc" instead.
        case obsTimeUtc
        case qcStatus
        case realtimeFrequency
        case softwareType
        case solarRadiation
        case stationID
        case uv
        case winddir
        case metric
    }

    enum MetricCodingKeys: String, CodingKey {
        case dewpt
        case elev
        case heatIndex
        case precipRate
        case precipTotal
        case pressure
        case temp
        case windChill
        case windGust
        case windSpeed
    }
}
