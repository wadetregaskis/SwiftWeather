//  Created by Mike Manzo on 5/10/20.

import Foundation


// Sigh.  Dealing with generics in Swift is real pain in the fucking arse sometimes.  All this boilerplate is because of Swift's inability to elegantly support collections of a generic type with varied specialisations.  This type-erasing "AnyMD" is the manual workaround to that stupidity.  Sigh.  Not that I'm bitter.
protocol AnyMD {
    associatedtype InputValue: Codable

    var ID: AmbientWeatherReport.CodingKeys { get }
    var sensorType: WeatherSensorType { get }
    var name: String { get }
    var description: String? { get }

    func createMeasurement(from: KeyedDecodingContainer<AmbientWeatherReport.CodingKeys>) throws -> (InputValue, Any)?
}


open class AmbientWeatherReport: WeatherReport {
    private let _sensors: [String: AmbientWeatherSensor]

    public var sensors: [String: WeatherSensor] {
        _sensors
    }

    private struct MD<InputValue: Codable, UnitType: Unit>: AnyMD {
        let ID: CodingKeys
        let sensorType: WeatherSensorType
        let name: String
        let description: String?
        let unit: UnitType
        let converter: ((InputValue) throws -> Any)?

        init(_ ID: CodingKeys,
             _ sensorType: WeatherSensorType,
             _ name: String,
             _ unit: UnitType = noUnit,
             _ description: String? = nil,
             _ converter: ((InputValue) throws -> Any)? = nil) {
            self.ID = ID
            self.sensorType = sensorType
            self.name = name
            self.description = description
            self.unit = unit
            self.converter = converter
        }

        func createMeasurement(from json: KeyedDecodingContainer<AmbientWeatherReport.CodingKeys>) throws -> (InputValue, Any)? {
            guard let rawValue = try json.decodeIfPresent(InputValue.self, forKey: self.ID) else {
                return nil
            }

            let value = try self.converter?(rawValue) ?? rawValue

            guard self.unit != noUnit else {
                return (rawValue, value)
            }

            let valueAsDouble: Double

            if let valueAlreadyIsDouble = value as? Double {
                valueAsDouble = valueAlreadyIsDouble
            } else if let valueAsBinaryInteger = value as? any BinaryInteger {
                valueAsDouble = Double(valueAsBinaryInteger)
            } else {
                throw AmbientWeatherError.unsupportedSensorValueType(value, unit)
            }

            return (rawValue, Measurement<UnitType>(value: valueAsDouble, unit: self.unit))
        }
    }

    internal static let rainDateFormatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let noUnit = Unit(symbol: "")
    private static let microgramsPerCubicMetre = Unit(symbol: "µg/m^3")
    private static let wattsPerSquareMetre = Unit(symbol: "W/m^2")
    private static let percentage = Unit(symbol: "%")
    private static let inchesPerHour = Unit(symbol: "in/hr")

    private static let sensorMetadata: [any AnyMD] = {
        // The "as AnyMD" crap on the end of all these is because the Swift compiler shits itself if there's more than a couple of entries with different UnitTypes, even though it's utterly explicit from the variable's type declaration what the expected result is.  Thankfully the "as AnyMD" _doesn't_ change the actual type it instantiates - that's still a suitably specific type like MD<UnitTemperature>.
        var metadata: [any AnyMD] = [
            MD<Double, Unit>(.pm25,
                             .AirQuality,
                             "Outdoor Air Quality",
                             microgramsPerCubicMetre,
                             "Measuring PM2.5"),
            MD<Double, Unit>(.pm25_24h,
                             .AirQuality,
                             "24 Average Outdoor Air Quality",
                             microgramsPerCubicMetre,
                             "Measuring PM2.5"),
            MD<Double, Unit>(.pm25_in,
                             .AirQuality,
                             "Indoor Air Quality",
                             microgramsPerCubicMetre,
                             "Measuring PM2.5"),
            MD<Double, Unit>(.pm25_in_24h,
                             .AirQuality,
                             "24 Average Indoor Air Quality",
                             microgramsPerCubicMetre,
                             "Measuring PM2.5"),
            MD<Double, UnitDispersion>(.co2,
                                       .AirQuality,
                                       "CO2 Level",
                                       .partsPerMillion),
            MD<Double, Unit>(.solarradiation,
                             .Radiation,
                             "Solar Radiation",
                             wattsPerSquareMetre),
            MD<Int, Unit>(.uv,
                          .Radiation,
                          "UV Index",
                          Unit(symbol: "UV Index")),
            MD<Int, Unit>(.batt_25,
                          .Battery,
                          "Air Quality Sensor Battery Status"),
            MD<Int, Unit>(.battout,
                          .Battery,
                          "Outdoor Sensor Battery Status"),
            MD<Int, Unit>(.humidity,
                          .Humidity,
                          "Outdoor Humidity",
                          percentage),
            MD<Int, Unit>(.humidityin,
                          .Humidity,
                          "Indoor Humidity",
                          percentage),
            MD<String, Unit>(.tz,
                             .TimeZone,
                             "Time Zone"),
            MD<Int, Unit>(.dateutc,
                          .Date,
                          "Date",
                          noUnit,
                          "Date & time at which the measurements were reported",
                          { Date(timeIntervalSince1970: Double($0) / 1000) }),
            MD<Double, UnitPressure>(.baromrelin,
                                     .Pressure,
                                     "Relative Pressure",
                                     .inchesOfMercury),
            MD<Double, UnitPressure>(.baromabsin,
                                     .Pressure,
                                     "Absolute Pressure",
                                     .inchesOfMercury),
            MD<Double, Unit>(.hourlyrainin,
                             .RainRate,
                             "Hourly Rain",
                             inchesPerHour),
            MD<Double, UnitLength>(.todayrainin,
                                   .Rain,
                                   "Rain Today",
                                   .inches),
            MD<Double, UnitLength>(.dailyrainin,
                                   .Rain,
                                   "Last 24 Hours Rain",
                                   .inches),
            MD<Double, UnitLength>(.weeklyrainin,
                                   .Rain,
                                   "Weekly Rain",
                                   .inches),
            MD<Double, UnitLength>(.monthlyrainin,
                                   .Rain,
                                   "Monthly Rain",
                                   .inches),
            MD<Double, UnitLength>(.yearlyrainin,
                                   .Rain,
                                   "Yearly Rain",
                                   .inches),
            MD<Double, UnitLength>(.eventrainin,
                                   .Rain,
                                   "Event Rain",
                                   .inches,
                                   "Total precipitation the last time it rained"),
            MD<Double, UnitLength>(.totalrainin,
                                   .Rain,
                                   "Total Rain",
                                   .inches,
                                   "Total precipitation in the station's lifetime (or since it was last factory reset)"),
            MD<String, Unit>(.lastRain,
                             .Date,
                             "Last Rain",
                             noUnit,
                             nil,
                             {
                                 guard let date = AmbientWeatherReport.rainDateFormatter.date(from: $0) else {
                                     throw AmbientWeatherError.invalidLastRainDate($0)
                                 }

                                 return date
                             }),
            MD<Int, UnitAngle>(.winddir,
                               .WindDirection,
                               "Wind Direction",
                               .degrees),
            MD<Double, UnitSpeed>(.windspeedmph,
                                  .WindSpeed,
                                  "Wind Speed",
                                  .milesPerHour),
            MD<Double, UnitSpeed>(.windgustmph,
                                  .WindSpeed,
                                  "Wind Gust",
                                  .milesPerHour,
                                  "Peak wind speed in the last 10 minutes"),
            MD<Double, UnitSpeed>(.maxdailygust,
                                  .WindSpeed,
                                  "Max Wind Gust Today",
                                  .milesPerHour),
            MD<Int, UnitAngle>(.windgustdir,
                               .WindDirection,
                               "Wind Gust Direction",
                               .degrees,
                               "Wind direction of the peak wind gust (in the last 10 minutes)"),
            MD<Double, UnitSpeed>(.windspdmph_avg2m,
                                  .WindSpeed,
                                  "Average Wind Speed (Last 2 Minutes)",
                                  .milesPerHour),
            MD<Int, UnitAngle>(.winddir_avg2m,
                               .WindDirection,
                               "Average Wind Direction (Last 2 Minutes)",
                               .degrees),
            MD<Double, UnitSpeed>(.windspdmph_avg10m,
                                  .WindSpeed,
                                  "Average Wind Speed (Last 10 Minutes)",
                                  .milesPerHour),
            MD<Int, UnitAngle>(.winddir_avg10m,
                               .WindDirection,
                               "Average Wind Direction (Last 10 Minutes)",
                               .degrees),
            MD<Double, UnitTemperature>(.tempinf,
                                        .Temperature,
                                        "Indoor Temperature",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.tempf,
                                        .Temperature,
                                        "Outdoor Temperature",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.dewPoint,
                                        .Temperature,
                                        "Outdoor Dew Point",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.dewPointIn,
                                        .Temperature,
                                        "Indoor Dew Point",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.feelsLike,
                                        .Temperature,
                                        "Outdoor Temperature Feels Like",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.feelsLikeIn,
                                        .Temperature,
                                        "Indoor Temperature Feels Like",
                                        .fahrenheit)]

        metadata.append(contentsOf: [.batt1, .batt2, .batt3, .batt4, .batt5, .batt6, .batt7, .batt8, .batt9, .batt10].enumerated().map {
            MD<Int, Unit>($1,
                          .Battery,
                          "Sensor #\($0 + 1) Battery Status") })
        metadata.append(contentsOf: [.humidity1, .humidity2, .humidity3, .humidity4, .humidity5, .humidity6, .humidity7, .humidity8, .humidity9, .humidity10].enumerated().map {
            MD<Int, Unit>($1,
                          .Humidity,
                          "Sensor #\($0 + 1) Humidity",
                          percentage) })
        metadata.append(contentsOf: [.soilhum1, .soilhum2, .soilhum3, .soilhum4, .soilhum5, .soilhum6, .soilhum7, .soilhum8, .soilhum9, .soilhum10].enumerated().map {
            MD<Int, Unit>($1,
                          .Humidity,
                          "Soil Sensor #\($0 + 1) Humidity",
                          percentage) })
        metadata.append(contentsOf: [.relay1, .relay2, .relay3, .relay4, .relay5, .relay6, .relay7, .relay8, .relay9, .relay10].enumerated().map {
            MD<Int, Unit>($1,
                          .General,
                          "Relay Sensor #\($0 + 1)") })
        metadata.append(contentsOf: [.temp1f, .temp2f, .temp3f, .temp4f, .temp5f, .temp6f, .temp7f, .temp8f, .temp9f, .temp10f].enumerated().map {
            MD<Double, UnitTemperature>($1,
                                        .Temperature,
                                        "Sensor #\($0 + 1) Temperature",
                                        .fahrenheit) })
        metadata.append(contentsOf: [.soiltemp1f, .soiltemp2f, .soiltemp3f, .soiltemp4f, .soiltemp5f, .soiltemp6f, .soiltemp7f, .soiltemp8f, .soiltemp9f, .soiltemp10f].enumerated().map {
            MD<Double, UnitTemperature>($1,
                                        .Temperature,
                                        "Soil Sensor #\($0 + 1) Temperature",
                                        .fahrenheit) })
        metadata.append(contentsOf: [.feelsLike1, .feelsLike2, .feelsLike3, .feelsLike4, .feelsLike5, .feelsLike6, .feelsLike7, .feelsLike8, .feelsLike9, .feelsLike10].enumerated().map {
            MD<Double, UnitTemperature>($1,
                                        .Temperature,
                                        "Temperature Sensor #\($0 + 1) Feels Like",
                                        .fahrenheit) })
        metadata.append(contentsOf: [.dewPoint1, .dewPoint2, .dewPoint3, .dewPoint4, .dewPoint5, .dewPoint6, .dewPoint7, .dewPoint8, .dewPoint9, .dewPoint10].enumerated().map {
            MD<Double, UnitTemperature>($1,
                                        .Temperature,
                                        "Sensor #\($0 + 1) Dew Point: \($0 + 1)",
                                        .fahrenheit) })

        return metadata
    }()

    public required init(from decoder: Decoder) throws {
        let json = try decoder.container(keyedBy: CodingKeys.self)

        self._sensors = try Dictionary(
            try AmbientWeatherReport.sensorMetadata.compactMap { md -> AmbientWeatherSensor? in
                guard let (rawValue, value) = try md.createMeasurement(from: json) else {
                    return nil
                }

                return AmbientWeatherSensor(type: md.sensorType,
                                            sensorID: md.ID.rawValue,
                                            name: md.name,
                                            description: md.description,
                                            measurement: value,
                                            rawValue: rawValue)
            }.map { ($0.ID, $0) },
            uniquingKeysWith: {
                throw AmbientWeatherError.conflictingSensorIDs($0, $1)
            })
    }

    public func encode(to encoder: Encoder) throws {
        var json = encoder.container(keyedBy: CodingKeys.self)

        try self._sensors.forEach {
            guard let codingKey = CodingKeys(rawValue: $0.value.ID) else {
                throw AmbientWeatherError.sensorNotSupportedForCodable($0.value)
            }

            try json.encode($0.value.rawValue, forKey: codingKey)
        }
    }

    enum CodingKeys: String, CodingKey {
        case winddir
        case windspeedmph
        case windgustmph
        case maxdailygust
        case windgustdir
        case windspdmph_avg2m
        case winddir_avg2m
        case windspdmph_avg10m
        case winddir_avg10m
        case humidity
        case humidityin
        case humidity1
        case humidity2
        case humidity3
        case humidity4
        case humidity5
        case humidity6
        case humidity7
        case humidity8
        case humidity9
        case humidity10
        case tempinf
        case tempf
        case temp1f
        case temp2f
        case temp3f
        case temp4f
        case temp5f
        case temp6f
        case temp7f
        case temp8f
        case temp9f
        case temp10f
        case soiltemp1f
        case soiltemp2f
        case soiltemp3f
        case soiltemp4f
        case soiltemp5f
        case soiltemp6f
        case soiltemp7f
        case soiltemp8f
        case soiltemp9f
        case soiltemp10f
        case soilhum1
        case soilhum2
        case soilhum3
        case soilhum4
        case soilhum5
        case soilhum6
        case soilhum7
        case soilhum8
        case soilhum9
        case soilhum10
        case battout
        case batt1
        case batt2
        case batt3
        case batt4
        case batt5
        case batt6
        case batt7
        case batt8
        case batt9
        case batt10
        case batt_25
        case hourlyrainin
        case todayrainin = "dailyrainin"
        case dailyrainin = "24hourrainin"
        case weeklyrainin
        case monthlyrainin
        case yearlyrainin
        case eventrainin
        case totalrainin
        case baromrelin
        case baromabsin
        case uv
        case solarradiation
        case co2
        case relay1
        case relay2
        case relay3
        case relay4
        case relay5
        case relay6
        case relay7
        case relay8
        case relay9
        case relay10
        case pm25
        case pm25_24h
        case pm25_in
        case pm25_in_24h
        case tz
        case dateutc
        case lastRain
        case dewPoint
        case dewPointIn
        case feelsLike
        case feelsLikeIn
        case feelsLike1
        case feelsLike2
        case feelsLike3
        case feelsLike4
        case feelsLike5
        case feelsLike6
        case feelsLike7
        case feelsLike8
        case feelsLike9
        case feelsLike10
        case dewPoint1
        case dewPoint2
        case dewPoint3
        case dewPoint4
        case dewPoint5
        case dewPoint6
        case dewPoint7
        case dewPoint8
        case dewPoint9
        case dewPoint10
    }

    public var date: Date {
        (self.sensors["dateutc"]?.measurement as? Date) ?? Date(timeIntervalSince1970: 0) // This value _really_ shouldn't be missing, so this icky, arbitrary 'else' value should never actually be used.  In theory.
    }
}

extension AmbientWeatherReport: CustomStringConvertible {
    public var description: String {
        sensors.map { $0.value.formatted() }.joined(separator: "\n")
    }
}
