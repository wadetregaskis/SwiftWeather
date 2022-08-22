//  Created by Mike Manzo on 5/10/20.

import Foundation


// Sigh.  Dealing with generics in Swift is real pain in the fucking arse sometimes.  All this boilerplate is because of Swift's inability to elegantly support collections of a generic type with varied specialisations.  This type-erasing "AnyMD" is the manual workaround to that stupidity.  Sigh.  Not that I'm bitter.
protocol AnyMD {
    var ID: AmbientWeatherReport.CodingKeys { get }
    var sensorType: WeatherSensorType { get }
    var valueType: Codable.Type { get }
    var name: String { get }
    var description: String { get }
    var converter: ((Any) throws -> Any)? { get }

    func createMeasurement(value: Any) throws -> Any
}


open class AmbientWeatherReport: WeatherReport {
    private let _sensors: [String: AmbientWeatherSensor]

    public var sensors: [String: WeatherSensor] {
        _sensors
    }

    private struct MD<UnitType: Unit>: AnyMD {
        let ID: CodingKeys
        let sensorType: WeatherSensorType
        let valueType: Codable.Type
        let name: String
        let description: String
        let unit: UnitType
        let converter: ((Any) throws -> Any)?

        init(_ ID: CodingKeys,
             _ sensorType: WeatherSensorType,
             _ valueType: Codable.Type,
             _ name: String,
             _ description: String,
             _ unit: UnitType = noUnit,
             _ converter: ((Any) throws -> Any)? = nil) {
            self.ID = ID
            self.sensorType = sensorType
            self.valueType = valueType
            self.name = name
            self.description = description
            self.unit = unit
            self.converter = converter
        }

        func createMeasurement(value rawValue: Any) throws -> Any {
            let value = try self.converter?(rawValue) ?? rawValue

            guard self.unit != noUnit else {
                return value
            }

            let valueAsDouble: Double

            if let valueAlreadyIsDouble = value as? Double {
                valueAsDouble = valueAlreadyIsDouble
            } else if let valueAsBinaryInteger = value as? any BinaryInteger {
                valueAsDouble = Double(valueAsBinaryInteger)
            } else {
                throw AmbientWeatherError.unsupportedSensorValueType(value, unit)
            }

            return Measurement<UnitType>(value: valueAsDouble, unit: self.unit)
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

    private static let sensorMetadata: [AnyMD] = {
        // The "as AnyMD" crap on the end of all these is because the Swift compiler shits itself if there's more than a couple of entries with different UnitTypes, even though it's utterly explicit from the variable's type declaration what the expected result is.  Thankfully the "as AnyMD" _doesn't_ change the actual type it instantiates - that's still a suitably specific type like MD<UnitTemperature>.
        var metadata: [AnyMD] = [
            MD(.pm25,
               .AirQuality,
               Double.self,
               "Outdoor Air Quality",
               "PM2.5 Outdoor Air Quality",
               microgramsPerCubicMetre) as AnyMD,
            MD(.pm25_24h,
               .AirQuality,
               Double.self,
               "24 Average Outdoor Air Quality",
               "PM2.5 Outdoor Air Quality Outdoor - 24 Hour Average",
               microgramsPerCubicMetre) as AnyMD,
            MD(.pm25_in,
               .AirQuality,
               Double.self,
               "Indoor Air Quality",
               "PM2.5 Indoor Air Quality",
               microgramsPerCubicMetre) as AnyMD,
            MD(.pm25_in_24h,
               .AirQuality,
               Double.self,
               "24 Average Indoor Air Quality",
               "PM2.5 Indoor Air Quality - 24 Hour Average",
               microgramsPerCubicMetre) as AnyMD,
            MD(.co2,
               .AirQuality,
               Double.self,
               "CO2 Level",
               "Carbon Dioxide Level",
               UnitDispersion.partsPerMillion) as AnyMD,
            MD(.solarradiation,
               .Radiation,
               Double.self,
               "Solar Radiation",
               "Solar Radiation",
               wattsPerSquareMetre) as AnyMD,
            MD(.uv,
               .Radiation,
               Int.self,
               "UV Index",
               "Ultra-Violet Radiation Index",
               Unit(symbol: "UV Index")) as AnyMD,
            MD(.batt_25,
               .Battery,
               Int.self,
               "Air Quality Battery Status",
               "PM2.5 Air Quality Sensor Battery Status") as AnyMD,
            MD(.battout,
               .Battery,
               Int.self,
               "Outdoor Battery Status",
               "Outdoor Battery Status") as AnyMD,
            MD(.humidity,
               .Humidity,
               Int.self,
               "Outdoor Humidity",
               "Outdoor Humidity, 0-l00%",
               percentage) as AnyMD,
            MD(.humidityin,
               .Humidity,
               Int.self,
               "Indoor Humidity",
               "Indoor Humidity, 0-100%",
               percentage) as AnyMD,
            MD(.tz,
               .TimeZone,
               String.self,
               "Time Zone",
               "IANA Time Zone") as AnyMD,
            MD(.dateutc,
               .Date,
               Int.self,
               "Date",
               "Date & time at which the set of measurements were reported",
               noUnit,
               {
                   guard let input = $0 as? Int else {
                       throw AmbientWeatherError.internalInconsistencyRegardingSensorValueFormats(Int.self, $0)
                   }

                   return Date(timeIntervalSince1970: Double(input) / 1000) }) as AnyMD,
            MD(.baromrelin,
               .Pressure,
               Double.self,
               "Relative Pressure",
               "Relative Pressure",
               UnitPressure.inchesOfMercury) as AnyMD,
            MD(.baromabsin,
               .Pressure,
               Double.self,
               "Absolute Pressure",
               "Absolute Pressure",
               UnitPressure.inchesOfMercury) as AnyMD,
            MD(.hourlyrainin,
               .RainRate,
               Double.self,
               "Hourly Rain",
               "Hourly Rain Rate",
               inchesPerHour) as AnyMD,
            MD(.todayrainin,
               .Rain,
               Double.self,
               "Rain Today",
               "Daily Rain",
               UnitLength.inches) as AnyMD,
            MD(.dailyrainin,
               .Rain,
               Double.self,
               "24 Hour Rain",
               "Rain over last 24 Hours",
               UnitLength.inches) as AnyMD,
            MD(.weeklyrainin,
               .Rain,
               Double.self,
               "Weekly Rain",
               "Rain this week",
               UnitLength.inches) as AnyMD,
            MD(.monthlyrainin,
               .Rain,
               Double.self,
               "Monthly Rain",
               "Rain this month",
               UnitLength.inches) as AnyMD,
            MD(.yearlyrainin,
               .Rain,
               Double.self,
               "Yearly Rain",
               "Rain this year",
               UnitLength.inches) as AnyMD,
            MD(.eventrainin,
               .Rain,
               Double.self,
               "Event Rain",
               "Event Rain",
               UnitLength.inches) as AnyMD,
            MD(.totalrainin,
               .Rain,
               Double.self,
               "Total Rain",
               "Total rain since last factory reset",
               UnitLength.inches) as AnyMD,
            MD(.lastRain,
               .Date,
               String.self,
               "Last Time it Rained",
               "Last time it rained",
               noUnit,
               {
                   guard let input = $0 as? String else {
                       throw AmbientWeatherError.internalInconsistencyRegardingSensorValueFormats(String.self, $0)
                   }

                   guard let date = AmbientWeatherReport.rainDateFormatter.date(from: input) else {
                       throw AmbientWeatherError.invalidLastRainDate(input)
                   }

                   return date
               }) as AnyMD,
            MD(.winddir,
               .WindDirection,
               Int.self,
               "Wind Direction",
               "Instantaneous wind direction, 0-360°",
               UnitAngle.degrees) as AnyMD,
            MD(.windspeedmph,
               .WindSpeed,
               Double.self,
               "Wind Speed",
               "Instantaneous wind speed",
               UnitSpeed.milesPerHour) as AnyMD,
            MD(.windgustmph,
               .WindSpeed,
               Double.self,
               "Wind Gust",
               "Maximum wind speed in the last 10 minutes",
               UnitSpeed.milesPerHour) as AnyMD,
            MD(.maxdailygust,
               .WindSpeed,
               Double.self,
               "Max Wind Gust Today",
               "Maximum wind speed in last day",
               UnitSpeed.milesPerHour) as AnyMD,
            MD(.windgustdir,
               .WindDirection,
               Int.self,
               "Wind Gust Direction",
               "Wind direction at which the wind gust occurred",
               UnitAngle.degrees) as AnyMD,
            MD(.windspdmph_avg2m,
               .WindSpeed,
               Double.self,
               "2 Minute Wind Speed Avg",
               "Average wind speed, 2 minute average",
               UnitSpeed.milesPerHour) as AnyMD,
            MD(.winddir_avg2m,
               .WindDirection,
               Int.self,
               "2 Minute Wind Direction Avg",
               "Average wind direction, 2 minute average",
               UnitAngle.degrees) as AnyMD,
            MD(.windspdmph_avg10m,
               .WindSpeed,
               Double.self,
               "10 Minute Wind Speed Avg",
               "Average wind speed, 10 minute average",
               UnitSpeed.milesPerHour) as AnyMD,
            MD(.winddir_avg10m,
               .WindDirection,
               Int.self,
               "10 Minute Wind Direction Avg",
               "Average wind direction, 10 minute average",
               UnitAngle.degrees) as AnyMD,
            MD(.tempinf,
               .Temperature,
               Double.self,
               "Indoor Temperature",
               "Indoor Temperature",
               UnitTemperature.fahrenheit) as AnyMD,
            MD(.tempf,
               .Temperature,
               Double.self,
               "Outdoor Temperature",
               "Outdoor Temperature",
               UnitTemperature.fahrenheit) as AnyMD,
            MD(.dewPoint,
               .Temperature,
               Double.self,
               "Outdoor Dew Point",
               "Outdoor Dew Point",
               UnitTemperature.fahrenheit) as AnyMD,
            MD(.dewPointIn,
               .Temperature,
               Double.self,
               "Indoor Dew Point",
               "Indoor Dew Point",
               UnitTemperature.fahrenheit) as AnyMD,
            MD(.feelsLike,
               .Temperature,
               Double.self,
               "Outdoor Temperature Feels Like",
               "If < 50℉ => Wind Chill, if > 68℉ => Heat Index",
               UnitTemperature.fahrenheit) as AnyMD,
            MD(.feelsLikeIn,
               .Temperature,
               Double.self,
               "Indoor Temperature Feels Like",
               "Indoor Feels Like",
               UnitTemperature.fahrenheit) as AnyMD]

        metadata.append(contentsOf: [.batt1, .batt2, .batt3, .batt4, .batt5, .batt6, .batt7, .batt8, .batt9, .batt10].enumerated().map {
            MD($1,
               .Battery,
               Int.self,
               "Battery Status: \($0 + 1)",
               "Outdoor Battery Status - Sensor #\($0 + 1)") })
        metadata.append(contentsOf: [.humidity1, .humidity2, .humidity3, .humidity4, .humidity5, .humidity6, .humidity7, .humidity8, .humidity9, .humidity10].enumerated().map {
            MD($1,
               .Humidity,
               Int.self,
               "Outdoor Humidity: \($0 + 1)",
               "Outdoor Humidity Sensor #\($0 + 1), 0-l00%",
               percentage) })
        metadata.append(contentsOf: [.soilhum1, .soilhum2, .soilhum3, .soilhum4, .soilhum5, .soilhum6, .soilhum7, .soilhum8, .soilhum9, .soilhum10].enumerated().map {
            MD($1,
               .Humidity,
               Int.self,
               "Soil Humidity: \($0 + 1)",
               "Soil Humidity Sensor #\($0 + 1), 0-l00%",
               percentage) })
        metadata.append(contentsOf: [.relay1, .relay2, .relay3, .relay4, .relay5, .relay6, .relay7, .relay8, .relay9, .relay10].enumerated().map {
            MD($1,
               .General,
               Int.self,
               "Relay \($0 + 1)",
               "Relay Sensor #\($0 + 1)") })
        metadata.append(contentsOf: [.temp1f, .temp2f, .temp3f, .temp4f, .temp5f, .temp6f, .temp7f, .temp8f, .temp9f, .temp10f].enumerated().map {
            MD($1,
               .Temperature,
               Double.self,
               "Outdoor Temperature: \($0 + 1)",
               "Outdoor Temperature Sensor #\($0 + 1)",
               UnitTemperature.fahrenheit) })
        metadata.append(contentsOf: [.soiltemp1f, .soiltemp2f, .soiltemp3f, .soiltemp4f, .soiltemp5f, .soiltemp6f, .soiltemp7f, .soiltemp8f, .soiltemp9f, .soiltemp10f].enumerated().map {
            MD($1,
               .Temperature,
               Double.self,
               "Soil Temperature: \($0 + 1)",
               "Soil Temperature Sensor #\($0 + 1)",
               UnitTemperature.fahrenheit) })
        metadata.append(contentsOf: [.feelsLike1, .feelsLike2, .feelsLike3, .feelsLike4, .feelsLike5, .feelsLike6, .feelsLike7, .feelsLike8, .feelsLike9, .feelsLike10].enumerated().map {
            MD($1,
               .Temperature,
               Double.self,
               "Outdoor Temperature Feels Like: \($0 + 1)",
               "Sensor \($0 + 1): If < 50℉ => Wind Chill, if > 68℉ => Heat Index",
               UnitTemperature.fahrenheit) })
        metadata.append(contentsOf: [.dewPoint1, .dewPoint2, .dewPoint3, .dewPoint4, .dewPoint5, .dewPoint6, .dewPoint7, .dewPoint8, .dewPoint9, .dewPoint10].enumerated().map {
            MD($1,
               .Temperature,
               Double.self,
               "Dew Point: \($0 + 1)",
               "Sensor \($0 + 1): Dew Point",
               UnitTemperature.fahrenheit) })

        return metadata
    }()

    public required init(from decoder: Decoder) throws {
        let json = try decoder.container(keyedBy: CodingKeys.self)

        self._sensors = try Dictionary(
            try AmbientWeatherReport.sensorMetadata.compactMap { md -> AmbientWeatherSensor? in
                guard let value = try json.decodeIfPresent(md.valueType, forKey: md.ID) else {
                    return nil
                }

                return AmbientWeatherSensor(type: md.sensorType,
                                            sensorID: md.ID.rawValue,
                                            name: md.name,
                                            description: md.description,
                                            measurement: try md.createMeasurement(value: value),
                                            rawValue: value)
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
