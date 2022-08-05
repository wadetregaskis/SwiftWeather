//
//  AmbientWeather.swift
//
//
//  Created by Mike Manzo on 5/10/20.
//

import Foundation

open class AmbientWeatherStationData: WeatherDeviceData, Codable {
    internal let windDirection:Int?
    internal let windSpeedMPH:Float?
    internal let windGustMPH:Float?
    internal let windGustDailyMax:Float?
    internal let windGustDir:Int?
    internal let windSpeedAvg2Min:Float?
    internal let winDir2Min:Int?
    internal let windSpeedAvg10Min:Float?
    internal let windDir10Min:Int?
    internal let humidityOut:Int?
    internal let humidityIn:Int?
    internal let humidityOut1:Int?
    internal let humidityOut2:Int?
    internal let humidityOut3:Int?
    internal let humidityOut4:Int?
    internal let humidityOut5:Int?
    internal let humidityOut6:Int?
    internal let humidityOut7:Int?
    internal let humidityOut8:Int?
    internal let humidityOut9:Int?
    internal let humidityOut10:Int?
    internal let tempInF:Float?
    internal let tempOutF:Float?
    internal let tempOut1F:Float?
    internal let tempOut2F:Float?
    internal let tempOut3F:Float?
    internal let tempOut4F:Float?
    internal let tempOut5F:Float?
    internal let tempOut6F:Float?
    internal let tempOut7F:Float?
    internal let tempOut8F:Float?
    internal let tempOut9F:Float?
    internal let tempOut10F:Float?
    internal let soilTempOut1F:Float?
    internal let soilTempOut2F:Float?
    internal let soilTempOut3F:Float?
    internal let soilTempOut4F:Float?
    internal let soilTempOut5F:Float?
    internal let soilTempOut6F:Float?
    internal let soilTempOut7F:Float?
    internal let soilTempOut8F:Float?
    internal let soilTempOut9F:Float?
    internal let soilTempOut10F:Float?
    internal let soilHumOut1F:Int?
    internal let soilHumOut2F:Int?
    internal let soilHumOut3F:Int?
    internal let soilHumOut4F:Int?
    internal let soilHumOut5F:Int?
    internal let soilHumOut6F:Int?
    internal let soilHumOut7F:Int?
    internal let soilHumOut8F:Int?
    internal let soilHumOut9F:Int?
    internal let soilHumOut10F:Int?
    internal let batteryOut:Int?
    internal let batteryOut1:Int?
    internal let batteryOut2:Int?
    internal let batteryOut3:Int?
    internal let batteryOut4:Int?
    internal let batteryOut5:Int?
    internal let batteryOut6:Int?
    internal let batteryOut7:Int?
    internal let batteryOut8:Int?
    internal let batteryOut9:Int?
    internal let batteryOut10:Int?
    internal let batteryAQS:Int?
    internal let rainHourIn:Float?
    internal let rainDailyIn:Float?
    internal let rain24HourIn:Float?
    internal let rainWeeklyIn:Float?
    internal let rainMonthlyIn:Float?
    internal let rainYearlyIn:Float?
    internal let rainEventIn:Float?
    internal let rainTotalIn:Float?
    internal let barometerRelativeInHg:Float?
    internal let barometerAbsoluteInHg:Float?
    internal let uvIndex:Int?
    internal let solarRadiation:Float?
    internal let carbonDioxide:Float?
    internal let relay1:Int?
    internal let relay2:Int?
    internal let relay3:Int?
    internal let relay4:Int?
    internal let relay5:Int?
    internal let relay6:Int?
    internal let relay7:Int?
    internal let relay8:Int?
    internal let relay9:Int?
    internal let relay10:Int?
    internal let airQualityOut:Float?
    internal let airQualityOut24:Float?
    internal let airQualityIn:Float?
    internal let airQualityIn24:Float?
    internal let timeZone: String?
    internal let dateUTC: Int?
    internal let rainLastDate: String?
    internal let dewPointOut: Float?
    internal let dewPointIn: Float?
    internal let tempFeelsLikeOutF:Float?
    internal let tempFeelsLikeInF:Float?
    internal let dateStation: String?
    internal let tempFeelsLikeOut1:Float?
    internal let tempFeelsLikeOut2:Float?
    internal let tempFeelsLikeOut3:Float?
    internal let tempFeelsLikeOut4:Float?
    internal let tempFeelsLikeOut5:Float?
    internal let tempFeelsLikeOut6:Float?
    internal let tempFeelsLikeOut7:Float?
    internal let tempFeelsLikeOut8:Float?
    internal let tempFeelsLikeOut9:Float?
    internal let tempFeelsLikeOut10:Float?
    internal let dewPoint1:Float?
    internal let dewPoint2:Float?
    internal let dewPoint3:Float?
    internal let dewPoint4:Float?
    internal let dewPoint5:Float?
    internal let dewPoint6:Float?
    internal let dewPoint7:Float?
    internal let dewPoint8:Float?
    internal let dewPoint9:Float?
    internal let dewPoint10:Float?
    
    enum CodingKeys: String, CodingKey {
        case windDirection = "winddir"
        case windSpeedMPH = "windspeedmph"
        case windGustMPH = "windgustmph"
        case windGustDailyMax = "maxdailygust"
        case windGustDir = "windgustdir"
        case windSpeedAvg2Min = "windspdmph_avg2m"
        case winDir2Min = "winddir_avg2m"
        case windSpeedAvg10Min = "windspdmph_avg10m"
        case windDir10Min = "winddir_avg10m"
        case humidityOut = "humidity"
        case humidityIn = "humidityin"
        case humidityOut1 = "humidity1"
        case humidityOut2 = "humidity2"
        case humidityOut3 = "humidity3"
        case humidityOut4 = "humidity4"
        case humidityOut5 = "humidity5"
        case humidityOut6 = "humidity6"
        case humidityOut7 = "humidity7"
        case humidityOut8 = "humidity8"
        case humidityOut9 = "humidity9"
        case humidityOut10 = "humidity10"
        case tempInF = "tempinf"
        case tempOutF = "tempf"
        case tempOut1F = "temp1f"
        case tempOut2F = "temp2f"
        case tempOut3F = "temp3f"
        case tempOut4F = "temp4f"
        case tempOut5F = "temp5f"
        case tempOut6F = "temp6f"
        case tempOut7F = "temp7f"
        case tempOut8F = "temp8f"
        case tempOut9F = "temp9f"
        case tempOut10F = "temp10f"
        case soilTempOut1F = "soiltemp1f"
        case soilTempOut2F = "soiltemp2f"
        case soilTempOut3F = "soiltemp3f"
        case soilTempOut4F = "soiltemp4f"
        case soilTempOut5F = "soiltemp5f"
        case soilTempOut6F = "soiltemp6f"
        case soilTempOut7F = "soiltemp7f"
        case soilTempOut8F = "soiltemp8f"
        case soilTempOut9F = "soiltemp9f"
        case soilTempOut10F = "soiltemp10f"
        case soilHumOut1F = "soilhum1"
        case soilHumOut2F = "soilhum2"
        case soilHumOut3F = "soilhum3"
        case soilHumOut4F = "soilhum4"
        case soilHumOut5F = "soilhum5"
        case soilHumOut6F = "soilhum6"
        case soilHumOut7F = "soilhum7"
        case soilHumOut8F = "soilhum8"
        case soilHumOut9F = "soilhum9"
        case soilHumOut10F = "soilhum10"
        case batteryOut = "battout"
        case batteryOut1 = "batt1"
        case batteryOut2 = "batt2"
        case batteryOut3 = "batt3"
        case batteryOut4 = "batt4"
        case batteryOut5 = "batt5"
        case batteryOut6 = "batt6"
        case batteryOut7 = "batt7"
        case batteryOut8 = "batt8"
        case batteryOut9 = "batt9"
        case batteryOut10 = "batt10"
        case batteryAQS = "batt_25"
        case rainHourIn = "hourlyrainin"
        case rainDailyIn = "dailyrainin"
        case rain24HourIn = "24hourrainin"
        case rainWeeklyIn = "weeklyrainin"
        case rainMonthlyIn = "monthlyrainin"
        case rainYearlyIn = "yearlyrainin"
        case rainEventIn = "eventrainin"
        case rainTotalIn = "totalrainin"
        case barometerRelativeInHg = "baromrelin"
        case barometerAbsoluteInHg = "baromabsin"
        case uvIndex = "uv"
        case solarRadiation = "solarradiation"
        case carbonDioxide = "co2"
        case relay1 = "relay1"
        case relay2 = "relay2"
        case relay3 = "relay3"
        case relay4 = "relay4"
        case relay5 = "relay5"
        case relay6 = "relay6"
        case relay7 = "relay7"
        case relay8 = "relay8"
        case relay9 = "relay9"
        case relay10 = "relay10"
        case airQualityOut = "pm25"
        case airQualityOut24 = "pm25_24h"
        case airQualityIn = "pm25_in"
        case airQualityIn24 = "pm25_in_24h"
        case timeZone = "tz"
        case dateUTC = "dateutc"
        case rainLastDate = "lastRain"
        case dewPointOut = "dewPoint"
        case dewPointIn = "dewPomtIn"
        case tempFeelsLikeOutF = "feelsLike"
        case tempFeelsLikeInF = "feelsLikeIn"
        case dateStation = "date"
        case tempFeelsLikeOut1 = "feelsLike1"
        case tempFeelsLikeOut2 = "feelsLike2"
        case tempFeelsLikeOut3 = "feelsLike3"
        case tempFeelsLikeOut4 = "feelsLike4"
        case tempFeelsLikeOut5 = "feelsLike5"
        case tempFeelsLikeOut6 = "feelsLike6"
        case tempFeelsLikeOut7 = "feelsLike7"
        case tempFeelsLikeOut8 = "feelsLike8"
        case tempFeelsLikeOut9 = "feelsLike9"
        case tempFeelsLikeOut10 = "feelsLike10"
        case dewPoint1 = "dewPoint1"
        case dewPoint2 = "dewPoint2"
        case dewPoint3 = "dewPoint3"
        case dewPoint4 = "dewPoint4"
        case dewPoint5 = "dewPoint5"
        case dewPoint6 = "dewPoint6"
        case dewPoint7 = "dewPoint7"
        case dewPoint8 = "dewPoint8"
        case dewPoint9 = "dewPoint9"
        case dewPoint10 = "dewPoint10"
    }
    
    /// Returns an array containing all sensors that are reporting
    public var availableSensors: [WeatherSensor] {
        let sensors = BatterySensors + MiscSensors + PressureSensors + RainSensors +
        RelaySensors + TemperatureSensors + WindSensors + AirQualitySensors +
        HumiditySensors
        
        return sensors.compactMap{ $0 }
    }
    
    /// Returns an array containing of reporting sensor types
    public var availabeSensorTypes: [WeatherSensorType] {
        var types = [WeatherSensorType]()
        
        if TemperatureSensors.count > 0 {
            types.append(WeatherSensorType.Temperature)
        }
        
        if AirQualitySensors.count > 0 {
            types.append(WeatherSensorType.AirQuality)
        }
        
        if WindSensors.count > 0 {
            types.append(WeatherSensorType.WindSpeed)
        }
        
        if HumiditySensors.count > 0 {
            types.append(WeatherSensorType.Humidity)
        }
        
        if PressureSensors.count > 0 {
            types.append(WeatherSensorType.Pressure)
        }
        
        if BatterySensors.count > 0 {
            types.append(WeatherSensorType.Battery)
        }
        
        if RelaySensors.count > 0 {
            types.append(WeatherSensorType.General)
        }
        
        if RainSensors.count > 0 {
            types.append(WeatherSensorType.Rain)
        }
        
        return types
    }
    
    ///
    /// Provides a simple way to "see" what ths device is reporting
    ///
    public var prettyString: String {
        var debugInfo = String()
        
        for sensor in availableSensors {
            debugInfo = "\(debugInfo)\n\(sensor.prettyString)"
        }
        return debugInfo
    }
    
    /// Initizlize the object from a JSON decoded string
    /// For a more thorough explaination of the API, please refer to [Ambient Weather](https://github.com/ambient-weather/api-docs/wiki/Device-Data-Specs)
    /// - Parameter decoder: decoder from a properly formatted JSON input
    /// - Throws: a decoding error if something has gone wrong
    ///
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            windDirection = try container.decodeIfPresent(Int.self, forKey: .windDirection)
            windSpeedMPH = try container.decodeIfPresent(Float.self, forKey: .windSpeedMPH)
            windGustMPH = try container.decodeIfPresent(Float.self, forKey: .windGustMPH)
            windGustDailyMax = try container.decodeIfPresent(Float.self, forKey: .windGustDailyMax)
            windGustDir = try container.decodeIfPresent(Int.self, forKey: .windGustDir)
            windSpeedAvg2Min = try container.decodeIfPresent(Float.self, forKey: .windSpeedAvg2Min)
            winDir2Min = try container.decodeIfPresent(Int.self, forKey: .winDir2Min)
            windSpeedAvg10Min = try container.decodeIfPresent(Float.self, forKey: .windSpeedAvg2Min)
            windDir10Min = try container.decodeIfPresent(Int.self, forKey: .windDir10Min)
            
            humidityOut = try container.decodeIfPresent(Int.self, forKey: .humidityOut)
            humidityIn = try container.decodeIfPresent(Int.self, forKey: .humidityIn)
            humidityOut1 = try container.decodeIfPresent(Int.self, forKey: .humidityOut1)
            humidityOut2 = try container.decodeIfPresent(Int.self, forKey: .humidityOut2)
            humidityOut3 = try container.decodeIfPresent(Int.self, forKey: .humidityOut3)
            humidityOut4 = try container.decodeIfPresent(Int.self, forKey: .humidityOut4)
            humidityOut5 = try container.decodeIfPresent(Int.self, forKey: .humidityOut5)
            humidityOut6 = try container.decodeIfPresent(Int.self, forKey: .humidityOut6)
            humidityOut7 = try container.decodeIfPresent(Int.self, forKey: .humidityOut7)
            humidityOut8 = try container.decodeIfPresent(Int.self, forKey: .humidityOut8)
            humidityOut9 = try container.decodeIfPresent(Int.self, forKey: .humidityOut9)
            humidityOut10 = try container.decodeIfPresent(Int.self, forKey: .humidityOut10)
            
            tempInF = try container.decodeIfPresent(Float.self, forKey: .tempInF)
            tempOutF = try container.decodeIfPresent(Float.self, forKey: .tempOutF)
            tempOut1F = try container.decodeIfPresent(Float.self, forKey: .tempOut1F)
            tempOut2F = try container.decodeIfPresent(Float.self, forKey: .tempOut2F)
            tempOut3F = try container.decodeIfPresent(Float.self, forKey: .tempOut3F)
            tempOut4F = try container.decodeIfPresent(Float.self, forKey: .tempOut4F)
            tempOut5F = try container.decodeIfPresent(Float.self, forKey: .tempOut5F)
            tempOut6F = try container.decodeIfPresent(Float.self, forKey: .tempOut6F)
            tempOut7F = try container.decodeIfPresent(Float.self, forKey: .tempOut7F)
            tempOut8F = try container.decodeIfPresent(Float.self, forKey: .tempOut8F)
            tempOut9F = try container.decodeIfPresent(Float.self, forKey: .tempOut9F)
            tempOut10F = try container.decodeIfPresent(Float.self, forKey: .tempOut10F)
            soilTempOut1F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut1F)
            soilTempOut2F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut2F)
            soilTempOut3F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut3F)
            soilTempOut4F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut4F)
            soilTempOut5F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut5F)
            soilTempOut6F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut6F)
            soilTempOut7F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut7F)
            soilTempOut8F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut8F)
            soilTempOut9F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut9F)
            soilTempOut10F = try container.decodeIfPresent(Float.self, forKey: .soilTempOut10F)
            soilHumOut1F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut1F)
            soilHumOut2F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut2F)
            soilHumOut3F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut3F)
            soilHumOut4F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut4F)
            soilHumOut5F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut5F)
            soilHumOut6F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut6F)
            soilHumOut7F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut7F)
            soilHumOut8F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut8F)
            soilHumOut9F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut9F)
            soilHumOut10F = try container.decodeIfPresent(Int.self, forKey: .soilHumOut10F)
            
            batteryOut = try container.decodeIfPresent(Int.self, forKey: .batteryOut)
            batteryOut1 = try container.decodeIfPresent(Int.self, forKey: .batteryOut1)
            batteryOut2 = try container.decodeIfPresent(Int.self, forKey: .batteryOut2)
            batteryOut3 = try container.decodeIfPresent(Int.self, forKey: .batteryOut3)
            batteryOut4 = try container.decodeIfPresent(Int.self, forKey: .batteryOut4)
            batteryOut5 = try container.decodeIfPresent(Int.self, forKey: .batteryOut5)
            batteryOut6 = try container.decodeIfPresent(Int.self, forKey: .batteryOut6)
            batteryOut7 = try container.decodeIfPresent(Int.self, forKey: .batteryOut7)
            batteryOut8 = try container.decodeIfPresent(Int.self, forKey: .batteryOut8)
            batteryOut9 = try container.decodeIfPresent(Int.self, forKey: .batteryOut9)
            batteryOut10 = try container.decodeIfPresent(Int.self, forKey: .batteryOut10)
            batteryAQS = try container.decodeIfPresent(Int.self, forKey: .batteryAQS)
            
            rainHourIn = try container.decodeIfPresent(Float.self, forKey: .rainHourIn)
            rainDailyIn = try container.decodeIfPresent(Float.self, forKey: .rainDailyIn)
            rain24HourIn = try container.decodeIfPresent(Float.self, forKey: .rain24HourIn)
            rainWeeklyIn = try container.decodeIfPresent(Float.self, forKey: .rainWeeklyIn)
            rainMonthlyIn = try container.decodeIfPresent(Float.self, forKey: .rainMonthlyIn)
            rainYearlyIn = try container.decodeIfPresent(Float.self, forKey: .rainYearlyIn)
            rainEventIn = try container.decodeIfPresent(Float.self, forKey: .rainEventIn)
            rainTotalIn = try container.decodeIfPresent(Float.self, forKey: .rainTotalIn)
            barometerRelativeInHg = try container.decodeIfPresent(Float.self, forKey: .barometerRelativeInHg)
            barometerAbsoluteInHg = try container.decodeIfPresent(Float.self, forKey: .barometerAbsoluteInHg)
            uvIndex = try container.decodeIfPresent(Int.self, forKey: .uvIndex)
            solarRadiation = try container.decodeIfPresent(Float.self, forKey: .solarRadiation)
            carbonDioxide = try container.decodeIfPresent(Float.self, forKey: .carbonDioxide)
            
            relay1 = try container.decodeIfPresent(Int.self, forKey: .relay1)
            relay2 = try container.decodeIfPresent(Int.self, forKey: .relay2)
            relay3 = try container.decodeIfPresent(Int.self, forKey: .relay3)
            relay4 = try container.decodeIfPresent(Int.self, forKey: .relay4)
            relay5 = try container.decodeIfPresent(Int.self, forKey: .relay5)
            relay6 = try container.decodeIfPresent(Int.self, forKey: .relay6)
            relay7 = try container.decodeIfPresent(Int.self, forKey: .relay7)
            relay8 = try container.decodeIfPresent(Int.self, forKey: .relay8)
            relay9 = try container.decodeIfPresent(Int.self, forKey: .relay9)
            relay10 = try container.decodeIfPresent(Int.self, forKey: .relay10)
            
            airQualityOut = try container.decodeIfPresent(Float.self, forKey: .airQualityOut)
            airQualityOut24 = try container.decodeIfPresent(Float.self, forKey: .airQualityOut24)
            airQualityIn = try container.decodeIfPresent(Float.self, forKey: .airQualityIn)
            airQualityIn24 = try container.decodeIfPresent(Float.self, forKey: .airQualityIn24)
            
            timeZone = try container.decodeIfPresent(String.self, forKey: .timeZone)
            dateUTC = try container.decodeIfPresent(Int.self, forKey: .dateUTC)
            rainLastDate = try container.decodeIfPresent(String.self, forKey: .rainLastDate)
            dewPointOut = try container.decodeIfPresent(Float.self, forKey: .dewPointOut)
            dewPointIn = try container.decodeIfPresent(Float.self, forKey: .dewPointIn)
            tempFeelsLikeOutF = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOutF)
            tempFeelsLikeInF = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeInF)
            dateStation = try container.decodeIfPresent(String.self, forKey: .dateStation)
            
            tempFeelsLikeOut1 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut1)
            tempFeelsLikeOut2 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut2)
            tempFeelsLikeOut3 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut3)
            tempFeelsLikeOut4 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut4)
            tempFeelsLikeOut5 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut5)
            tempFeelsLikeOut6 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut6)
            tempFeelsLikeOut7 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut7)
            tempFeelsLikeOut8 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut8)
            tempFeelsLikeOut9 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut9)
            tempFeelsLikeOut10 = try container.decodeIfPresent(Float.self, forKey: .tempFeelsLikeOut10)
            dewPoint1 = try container.decodeIfPresent(Float.self, forKey: .dewPoint1)
            dewPoint2 = try container.decodeIfPresent(Float.self, forKey: .dewPoint2)
            dewPoint3 = try container.decodeIfPresent(Float.self, forKey: .dewPoint3)
            dewPoint4 = try container.decodeIfPresent(Float.self, forKey: .dewPoint4)
            dewPoint5 = try container.decodeIfPresent(Float.self, forKey: .dewPoint5)
            dewPoint6 = try container.decodeIfPresent(Float.self, forKey: .dewPoint6)
            dewPoint7 = try container.decodeIfPresent(Float.self, forKey: .dewPoint7)
            dewPoint8 = try container.decodeIfPresent(Float.self, forKey: .dewPoint8)
            dewPoint9 = try container.decodeIfPresent(Float.self, forKey: .dewPoint9)
            dewPoint10 = try container.decodeIfPresent(Float.self, forKey: .dewPoint10)
        } catch let error as DecodingError {
            throw error
        }
    }
}
