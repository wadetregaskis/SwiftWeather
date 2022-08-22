//  Created by Mike Manzo on 5/10/20.

import Foundation


// Sigh.  Dealing with generics in Swift is real pain in the fucking arse sometimes.  All this boilerplate is because of Swift's inability to elegantly support collections of a generic type with varied specialisations.  This type-erasing "AnyMD" is the manual workaround to that stupidity.  Sigh.  Not that I'm bitter.
protocol AnyMD {
    associatedtype InputValue: Codable

    var ID: AmbientWeatherReport.CodingKeys { get }
    var sensorType: WeatherSensorType { get }
    var name: String { get }
    var description: String { get }

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
        let description: String
        let unit: UnitType
        let converter: ((InputValue) throws -> Any)?

        init(_ ID: CodingKeys,
             _ sensorType: WeatherSensorType,
             _ name: String,
             _ description: String,
             _ unit: UnitType = noUnit,
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
                             "PM2.5 Outdoor Air Quality",
                             microgramsPerCubicMetre),
            MD<Double, Unit>(.pm25_24h,
                             .AirQuality,
                             "24 Average Outdoor Air Quality",
                             "PM2.5 Outdoor Air Quality Outdoor - 24 Hour Average",
                             microgramsPerCubicMetre),
            MD<Double, Unit>(.pm25_in,
                             .AirQuality,
                             "Indoor Air Quality",
                             "PM2.5 Indoor Air Quality",
                             microgramsPerCubicMetre),
            MD<Double, Unit>(.pm25_in_24h,
                             .AirQuality,
                             "24 Average Indoor Air Quality",
                             "PM2.5 Indoor Air Quality - 24 Hour Average",
                             microgramsPerCubicMetre),
            MD<Double, UnitDispersion>(.co2,
                                       .AirQuality,
                                       "CO2 Level",
                                       "Carbon Dioxide Level",
                                       .partsPerMillion),
            MD<Double, Unit>(.solarradiation,
                             .Radiation,
                             "Solar Radiation",
                             "Solar Radiation",
                             wattsPerSquareMetre),
            MD<Int, Unit>(.uv,
                          .Radiation,
                          "UV Index",
                          "Ultra-Violet Radiation Index",
                          Unit(symbol: "UV Index")),
            MD<Int, Unit>(.batt_25,
                          .Battery,
                          "Air Quality Battery Status",
                          "PM2.5 Air Quality Sensor Battery Status"),
            MD<Int, Unit>(.battout,
                          .Battery,
                          "Outdoor Battery Status",
                          "Outdoor Battery Status"),
            MD<Int, Unit>(.humidity,
                          .Humidity,
                          "Outdoor Humidity",
                          "Outdoor Humidity, 0-l00%",
                          percentage),
            MD<Int, Unit>(.humidityin,
                          .Humidity,
                          "Indoor Humidity",
                          "Indoor Humidity, 0-100%",
                          percentage),
            MD<String, Unit>(.tz,
                             .TimeZone,
                             "Time Zone",
                             "IANA Time Zone"),
            MD<Int, Unit>(.dateutc,
                          .Date,
                          "Date",
                          "Date & time at which the set of measurements were reported",
                          noUnit,
                          { Date(timeIntervalSince1970: Double($0) / 1000) }),
            MD<Double, UnitPressure>(.baromrelin,
                                     .Pressure,
                                     "Relative Pressure",
                                     "Relative Pressure",
                                     .inchesOfMercury),
            MD<Double, UnitPressure>(.baromabsin,
                                     .Pressure,
                                     "Absolute Pressure",
                                     "Absolute Pressure",
                                     .inchesOfMercury),
            MD<Double, Unit>(.hourlyrainin,
                             .RainRate,
                             "Hourly Rain",
                             "Hourly Rain Rate",
                             inchesPerHour),
            MD<Double, UnitLength>(.todayrainin,
                                   .Rain,
                                   "Rain Today",
                                   "Daily Rain",
                                   .inches),
            MD<Double, UnitLength>(.dailyrainin,
                                   .Rain,
                                   "24 Hour Rain",
                                   "Rain over last 24 Hours",
                                   .inches),
            MD<Double, UnitLength>(.weeklyrainin,
                                   .Rain,
                                   "Weekly Rain",
                                   "Rain this week",
                                   .inches),
            MD<Double, UnitLength>(.monthlyrainin,
                                   .Rain,
                                   "Monthly Rain",
                                   "Rain this month",
                                   .inches),
            MD<Double, UnitLength>(.yearlyrainin,
                                   .Rain,
                                   "Yearly Rain",
                                   "Rain this year",
                                   .inches),
            MD<Double, UnitLength>(.eventrainin,
                                   .Rain,
                                   "Event Rain",
                                   "Event Rain",
                                   .inches),
            MD<Double, UnitLength>(.totalrainin,
                                   .Rain,
                                   "Total Rain",
                                   "Total rain since last factory reset",
                                   .inches),
            MD<String, Unit>(.lastRain,
                             .Date,
                             "Last Time it Rained",
                             "Last time it rained",
                             noUnit,
                             {
                                 guard let date = AmbientWeatherReport.rainDateFormatter.date(from: $0) else {
                                     throw AmbientWeatherError.invalidLastRainDate($0)
                                 }

                                 return date
                             }),
            MD<Int, UnitAngle>(.winddir,
                               .WindDirection,
                               "Wind Direction",
                               "Instantaneous wind direction, 0-360°",
                               .degrees),
            MD<Double, UnitSpeed>(.windspeedmph,
                                  .WindSpeed,
                                  "Wind Speed",
                                  "Instantaneous wind speed",
                                  .milesPerHour),
            MD<Double, UnitSpeed>(.windgustmph,
                                  .WindSpeed,
                                  "Wind Gust",
                                  "Maximum wind speed in the last 10 minutes",
                                  .milesPerHour),
            MD<Double, UnitSpeed>(.maxdailygust,
                                  .WindSpeed,
                                  "Max Wind Gust Today",
                                  "Maximum wind speed in last day",
                                  .milesPerHour),
            MD<Int, UnitAngle>(.windgustdir,
                               .WindDirection,
                               "Wind Gust Direction",
                               "Wind direction at which the wind gust occurred",
                               .degrees),
            MD<Double, UnitSpeed>(.windspdmph_avg2m,
                                  .WindSpeed,
                                  "2 Minute Wind Speed Avg",
                                  "Average wind speed, 2 minute average",
                                  .milesPerHour),
            MD<Int, UnitAngle>(.winddir_avg2m,
                               .WindDirection,
                               "2 Minute Wind Direction Avg",
                               "Average wind direction, 2 minute average",
                               .degrees),
            MD<Double, UnitSpeed>(.windspdmph_avg10m,
                                  .WindSpeed,
                                  "10 Minute Wind Speed Avg",
                                  "Average wind speed, 10 minute average",
                                  .milesPerHour),
            MD<Int, UnitAngle>(.winddir_avg10m,
                               .WindDirection,
                               "10 Minute Wind Direction Avg",
                               "Average wind direction, 10 minute average",
                               .degrees),
            MD<Double, UnitTemperature>(.tempinf,
                                        .Temperature,
                                        "Indoor Temperature",
                                        "Indoor Temperature",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.tempf,
                                        .Temperature,
                                        "Outdoor Temperature",
                                        "Outdoor Temperature",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.dewPoint,
                                        .Temperature,
                                        "Outdoor Dew Point",
                                        "Outdoor Dew Point",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.dewPointIn,
                                        .Temperature,
                                        "Indoor Dew Point",
                                        "Indoor Dew Point",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.feelsLike,
                                        .Temperature,
                                        "Outdoor Temperature Feels Like",
                                        "If < 50℉ => Wind Chill, if > 68℉ => Heat Index",
                                        .fahrenheit),
            MD<Double, UnitTemperature>(.feelsLikeIn,
                                        .Temperature,
                                        "Indoor Temperature Feels Like",
                                        "Indoor Feels Like",
                                        .fahrenheit)]

        metadata.append(contentsOf: [.batt1, .batt2, .batt3, .batt4, .batt5, .batt6, .batt7, .batt8, .batt9, .batt10].enumerated().map {
            MD<Int, Unit>($1,
                          .Battery,
                          "Battery Status: \($0 + 1)",
                          "Outdoor Battery Status - Sensor #\($0 + 1)") })
        metadata.append(contentsOf: [.humidity1, .humidity2, .humidity3, .humidity4, .humidity5, .humidity6, .humidity7, .humidity8, .humidity9, .humidity10].enumerated().map {
            MD<Int, Unit>($1,
                          .Humidity,
                          "Outdoor Humidity: \($0 + 1)",
                          "Outdoor Humidity Sensor #\($0 + 1), 0-l00%",
                          percentage) })
        metadata.append(contentsOf: [.soilhum1, .soilhum2, .soilhum3, .soilhum4, .soilhum5, .soilhum6, .soilhum7, .soilhum8, .soilhum9, .soilhum10].enumerated().map {
            MD<Int, Unit>($1,
                          .Humidity,
                          "Soil Humidity: \($0 + 1)",
                          "Soil Humidity Sensor #\($0 + 1), 0-l00%",
                          percentage) })
        metadata.append(contentsOf: [.relay1, .relay2, .relay3, .relay4, .relay5, .relay6, .relay7, .relay8, .relay9, .relay10].enumerated().map {
            MD<Int, Unit>($1,
                          .General,
                          "Relay \($0 + 1)",
                          "Relay Sensor #\($0 + 1)") })
        metadata.append(contentsOf: [.temp1f, .temp2f, .temp3f, .temp4f, .temp5f, .temp6f, .temp7f, .temp8f, .temp9f, .temp10f].enumerated().map {
            MD<Double, UnitTemperature>($1,
                                        .Temperature,
                                        "Outdoor Temperature: \($0 + 1)",
                                        "Outdoor Temperature Sensor #\($0 + 1)",
                                        .fahrenheit) })
        metadata.append(contentsOf: [.soiltemp1f, .soiltemp2f, .soiltemp3f, .soiltemp4f, .soiltemp5f, .soiltemp6f, .soiltemp7f, .soiltemp8f, .soiltemp9f, .soiltemp10f].enumerated().map {
            MD<Double, UnitTemperature>($1,
                                        .Temperature,
                                        "Soil Temperature: \($0 + 1)",
                                        "Soil Temperature Sensor #\($0 + 1)",
                                        .fahrenheit) })
        metadata.append(contentsOf: [.feelsLike1, .feelsLike2, .feelsLike3, .feelsLike4, .feelsLike5, .feelsLike6, .feelsLike7, .feelsLike8, .feelsLike9, .feelsLike10].enumerated().map {
            MD<Double, UnitTemperature>($1,
                                        .Temperature,
                                        "Outdoor Temperature Feels Like: \($0 + 1)",
                                        "Sensor \($0 + 1): If < 50℉ => Wind Chill, if > 68℉ => Heat Index",
                                        .fahrenheit) })
        metadata.append(contentsOf: [.dewPoint1, .dewPoint2, .dewPoint3, .dewPoint4, .dewPoint5, .dewPoint6, .dewPoint7, .dewPoint8, .dewPoint9, .dewPoint10].enumerated().map {
            MD<Double, UnitTemperature>($1,
                                        .Temperature,
                                        "Dew Point: \($0 + 1)",
                                        "Sensor \($0 + 1): Dew Point",
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
