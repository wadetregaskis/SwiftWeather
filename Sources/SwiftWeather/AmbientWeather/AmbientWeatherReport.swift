//  Created by Mike Manzo on 5/10/20.

import Foundation

open class AmbientWeatherReport: WeatherReport {
    private let _sensors: [String: AmbientWeatherSensor]

    public var sensors: [String: WeatherSensor] {
        _sensors
    }

    private struct MD {
        let ID: CodingKeys
        let sensorType: WeatherSensorType
        let valueType: Codable.Type
        let name: String
        let description: String
        let unit: String
        let converter: ((Any) throws -> Any)?

        init(_ ID: CodingKeys,
             _ sensorType: WeatherSensorType,
             _ valueType: Codable.Type,
             _ name: String,
             _ description: String,
             _ unit: String,
             _ converter: ((Any) throws -> Any)? = nil) {
            self.ID = ID
            self.sensorType = sensorType
            self.valueType = valueType
            self.name = name
            self.description = description
            self.unit = unit
            self.converter = converter
        }
    }

    internal static let rainDateFormatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let sensorMetadata: [MD] = {
        var metadata: [MD] = [
            MD(.pm25,
               .AirQuality,
               Double.self,
               "Outdoor Air Quality",
               "PM2.5 Outdoor Air Quality",
               "µg/m^3"),
            MD(.pm25_24h,
               .AirQuality,
               Double.self,
               "24 Average Outdoor Air Quality",
               "PM2.5 Outdoor Air Quality Outdoor - 24 Hour Average",
               "µg/m^3"),
            MD(.pm25_in,
               .AirQuality,
               Double.self,
               "Indoor Air Quality",
               "PM2.5 Indoor Air Quality",
               "µg/m^3"),
            MD(.pm25_in_24h,
               .AirQuality,
               Double.self,
               "24 Average Indoor Air Quality",
               "PM2.5 Indoor Air Quality - 24 Hour Average",
               "µg/m^3"),
            MD(.co2,
               .AirQuality,
               Double.self,
               "CO2 Level",
               "Carbon Dioxide Level",
               "ppm"),
            MD(.solarradiation,
               .Radiation,
               Double.self,
               "Solar Radiation",
               "Solar Radiation",
               "W/m^2"),
            MD(.uv,
               .Radiation,
               Int.self,
               "UV Index",
               "Ultra-Violet Radiation Index",
               "None"),
            MD(.batt_25,
               .Battery,
               Int.self,
               "Air Quality Battery Status",
               "PM2.5 Air Quality Sensor Battery Status",
               "None"),
            MD(.battout,
               .Battery,
               Int.self,
               "Outdoor Battery Status",
               "Outdoor Battery Status",
               "None"),
            MD(.humidity,
               .Humidity,
               Int.self,
               "Outdoor Humidity",
               "Outdoor Humidity, 0-l00%",
               "%"),
            MD(.humidityin,
               .Humidity,
               Int.self,
               "Indoor Humidity",
               "Indoor Humidity, 0-100%",
               "%"),
            MD(.tz,
               .TimeZone,
               String.self,
               "Time Zone",
               "IANA Time Zone",
               "None"),
            MD(.dateutc,
               .Date,
               Int.self,
               "Date",
               "Date & time at which the set of measurements were reported",
               "None",
               {
                   guard let input = $0 as? Int else {
                       throw AmbientWeatherError.internalInconsistencyRegardingSensorValueFormats(Int.self, $0)
                   }

                   return Date(timeIntervalSince1970: Double(input) / 1000) }),
            MD(.baromrelin,
               .Pressure,
               Double.self,
               "Relative Pressure",
               "Relative Pressure",
               "inHg"),
            MD(.baromabsin,
               .Pressure,
               Double.self,
               "Absolute Pressure",
               "Absolute Pressure",
               "inHg"),
            MD(.hourlyrainin,
               .RainRate,
               Double.self,
               "Hourly Rain",
               "Hourly Rain Rate",
               "in/hr"),
            MD(.todayrainin,
               .Rain,
               Double.self,
               "Rain Today",
               "Daily Rain",
               "in"),
            MD(.dailyrainin,
               .Rain,
               Double.self,
               "24 Hour Rain",
               "Rain over last 24 Hours",
               "in"),
            MD(.weeklyrainin,
               .Rain,
               Double.self,
               "Weekly Rain",
               "Rain this week",
               "in"),
            MD(.monthlyrainin,
               .Rain,
               Double.self,
               "Monthly Rain",
               "Rain this month",
               "in"),
            MD(.yearlyrainin,
               .Rain,
               Double.self,
               "Yearly Rain",
               "Rain this year",
               "in"),
            MD(.eventrainin,
               .Rain,
               Double.self,
               "Event Rain",
               "Event Rain",
               "in"),
            MD(.totalrainin,
               .Rain,
               Double.self,
               "Total Rain",
               "Total rain since last factory reset",
               "in"),
            MD(.lastRain,
               .Date,
               String.self,
               "Last Time it Rained",
               "Last time it rained",
               "None",
               {
                   guard let input = $0 as? String else {
                       throw AmbientWeatherError.internalInconsistencyRegardingSensorValueFormats(String.self, $0)
                   }

                   guard let date = AmbientWeatherReport.rainDateFormatter.date(from: input) else {
                       throw AmbientWeatherError.invalidLastRainDate(input)
                   }

                   return date
               }),
            MD(.winddir,
               .WindDirection,
               Int.self,
               "Wind Direction",
               "Instantaneous wind direction, 0-360°",
               "°"),
            MD(.windspeedmph,
               .WindSpeed,
               Double.self,
               "Wind Speed",
               "Instantaneous wind speed",
               "MPH"),
            MD(.windgustmph,
               .WindSpeed,
               Double.self,
               "Wind Gust",
               "Maximum wind speed in the last 10 minutes",
               "MPH"),
            MD(.maxdailygust,
               .WindSpeed,
               Double.self,
               "Max Wind Gust Today",
               "Maximum wind speed in last day",
               "MPH"),
            MD(.windgustdir,
               .WindDirection,
               Int.self,
               "Wind Gust Direction",
               "Wind direction at which the wind gust occurred",
               "°"),
            MD(.windspdmph_avg2m,
               .WindSpeed,
               Double.self,
               "2 Minute Wind Speed Avg",
               "Average wind speed, 2 minute average",
               "MPH"),
            MD(.winddir_avg2m,
               .WindDirection,
               Int.self,
               "2 Minute Wind Direction Avg",
               "Average wind direction, 2 minute average",
               "°"),
            MD(.windspdmph_avg10m,
               .WindSpeed,
               Double.self,
               "10 Minute Wind Speed Avg",
               "Average wind speed, 10 minute average",
               "MPH"),
            MD(.winddir_avg10m,
               .WindDirection,
               Int.self,
               "10 Minute Wind Direction Avg",
               "Average wind direction, 10 minute average",
               "°"),
            MD(.tempinf,
               .Temperature,
               Double.self,
               "Indoor Temperature",
               "Indoor Temperature",
               "℉"),
            MD(.tempf,
               .Temperature,
               Double.self,
               "Outdoor Temperature",
               "Outdoor Temperature",
               "℉"),
            MD(.dewPoint,
               .Temperature,
               Double.self,
               "Outdoor Dew Point",
               "Outdoor Dew Point",
               "℉"),
            MD(.dewPointIn,
               .Temperature,
               Double.self,
               "Indoor Dew Point",
               "Indoor Dew Point",
               "℉"),
            MD(.feelsLike,
               .Temperature,
               Double.self,
               "Outdoor Temperature Feels Like",
               "If < 50℉ => Wind Chill, if > 68℉ => Heat Index",
               "℉"),
            MD(.feelsLikeIn,
               .Temperature,
               Double.self,
               "Indoor Temperature Feels Like",
               "Indoor Feels Like",
               "℉")]

        metadata.append(contentsOf: [.batt1, .batt2, .batt3, .batt4, .batt5, .batt6, .batt7, .batt8, .batt9, .batt10].enumerated().map {
            MD($1,
               .Battery,
               Int.self,
               "Battery Status: \($0 + 1)",
               "Outdoor Battery Status - Sensor #\($0 + 1)",
               "None") })
        metadata.append(contentsOf: [.humidity1, .humidity2, .humidity3, .humidity4, .humidity5, .humidity6, .humidity7, .humidity8, .humidity9, .humidity10].enumerated().map {
            MD($1,
               .Humidity,
               Int.self,
               "Outdoor Humidity: \($0 + 1)",
               "Outdoor Humidity Sensor #\($0 + 1), 0-l00%",
               "%") })
        metadata.append(contentsOf: [.soilhum1, .soilhum2, .soilhum3, .soilhum4, .soilhum5, .soilhum6, .soilhum7, .soilhum8, .soilhum9, .soilhum10].enumerated().map {
            MD($1,
               .Humidity,
               Int.self,
               "Soil Humidity: \($0 + 1)",
               "Soil Humidity Sensor #\($0 + 1), 0-l00%",
               "%") })
        metadata.append(contentsOf: [.relay1, .relay2, .relay3, .relay4, .relay5, .relay6, .relay7, .relay8, .relay9, .relay10].enumerated().map {
            MD($1,
               .General,
               Int.self,
               "Relay \($0 + 1)",
               "Relay Sensor #\($0 + 1)",
               "None") })
        metadata.append(contentsOf: [.temp1f, .temp2f, .temp3f, .temp4f, .temp5f, .temp6f, .temp7f, .temp8f, .temp9f, .temp10f].enumerated().map {
            MD($1,
               .Temperature,
               Double.self,
               "Outdoor Temperature: \($0 + 1)",
               "Outdoor Temperature Sensor #\($0 + 1)",
               "℉") })
        metadata.append(contentsOf: [.soiltemp1f, .soiltemp2f, .soiltemp3f, .soiltemp4f, .soiltemp5f, .soiltemp6f, .soiltemp7f, .soiltemp8f, .soiltemp9f, .soiltemp10f].enumerated().map {
            MD($1,
               .Temperature,
               Double.self,
               "Soil Temperature: \($0 + 1)",
               "Soil Temperature Sensor #\($0 + 1)",
               "℉") })
        metadata.append(contentsOf: [.feelsLike1, .feelsLike2, .feelsLike3, .feelsLike4, .feelsLike5, .feelsLike6, .feelsLike7, .feelsLike8, .feelsLike9, .feelsLike10].enumerated().map {
            MD($1,
               .Temperature,
               Double.self,
               "Outdoor Temperature Feels Like: \($0 + 1)",
               "Sensor \($0 + 1): If < 50℉ => Wind Chill, if > 68℉ => Heat Index",
               "℉") })
        metadata.append(contentsOf: [.dewPoint1, .dewPoint2, .dewPoint3, .dewPoint4, .dewPoint5, .dewPoint6, .dewPoint7, .dewPoint8, .dewPoint9, .dewPoint10].enumerated().map {
            MD($1,
               .Temperature,
               Double.self,
               "Dew Point: \($0 + 1)",
               "Sensor \($0 + 1): Dew Point",
               "℉") })

        return metadata
    }()

    public required init(from decoder: Decoder) throws {
        let json = try decoder.container(keyedBy: CodingKeys.self)

        self._sensors = try Dictionary(
            try AmbientWeatherReport.sensorMetadata.compactMap { md -> AmbientWeatherSensor? in
                guard let rawValue = try json.decodeIfPresent(md.valueType, forKey: md.ID) else {
                    return nil
                }

                var value: Any = rawValue

                if let converter = md.converter {
                    value = try converter(value)
                }

                return AmbientWeatherSensor(type: md.sensorType,
                                            sensorID: md.ID.rawValue,
                                            name: md.name,
                                            description: md.description,
                                            measurement: value,
                                            unit: md.unit,
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
