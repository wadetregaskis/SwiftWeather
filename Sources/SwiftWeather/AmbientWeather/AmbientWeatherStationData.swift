//
//  AmbientWeather.swift
//
//
//  Created by Mike Manzo on 5/10/20.
//

import Foundation

open class AmbientWeatherStationData: WeatherDeviceData, Codable {
    internal let windDirection: Int?
    internal let windSpeedMPH: Float?
    internal let windGustMPH: Float?
    internal let windGustDailyMax: Float?
    internal let windGustDir: Int?
    internal let windSpeedAvg2Min: Float?
    internal let winDir2Min: Int?
    internal let windSpeedAvg10Min: Float?
    internal let windDir10Min: Int?
    internal let humidityOut: Int?
    internal let humidityIn: Int?
    internal let humidityOut1: Int?
    internal let humidityOut2: Int?
    internal let humidityOut3: Int?
    internal let humidityOut4: Int?
    internal let humidityOut5: Int?
    internal let humidityOut6: Int?
    internal let humidityOut7: Int?
    internal let humidityOut8: Int?
    internal let humidityOut9: Int?
    internal let humidityOut10: Int?
    internal let tempInF: Float?
    internal let tempOutF: Float?
    internal let tempOut1F: Float?
    internal let tempOut2F: Float?
    internal let tempOut3F: Float?
    internal let tempOut4F: Float?
    internal let tempOut5F: Float?
    internal let tempOut6F: Float?
    internal let tempOut7F: Float?
    internal let tempOut8F: Float?
    internal let tempOut9F: Float?
    internal let tempOut10F: Float?
    internal let soilTempOut1F: Float?
    internal let soilTempOut2F: Float?
    internal let soilTempOut3F: Float?
    internal let soilTempOut4F: Float?
    internal let soilTempOut5F: Float?
    internal let soilTempOut6F: Float?
    internal let soilTempOut7F: Float?
    internal let soilTempOut8F: Float?
    internal let soilTempOut9F: Float?
    internal let soilTempOut10F: Float?
    internal let soilHumOut1: Int?
    internal let soilHumOut2: Int?
    internal let soilHumOut3: Int?
    internal let soilHumOut4: Int?
    internal let soilHumOut5: Int?
    internal let soilHumOut6: Int?
    internal let soilHumOut7: Int?
    internal let soilHumOut8: Int?
    internal let soilHumOut9: Int?
    internal let soilHumOut10: Int?
    internal let batteryOut: Int?
    internal let batteryOut1: Int?
    internal let batteryOut2: Int?
    internal let batteryOut3: Int?
    internal let batteryOut4: Int?
    internal let batteryOut5: Int?
    internal let batteryOut6: Int?
    internal let batteryOut7: Int?
    internal let batteryOut8: Int?
    internal let batteryOut9: Int?
    internal let batteryOut10: Int?
    internal let batteryAQS: Int?
    internal let rainHourIn: Float?
    internal let rainDailyIn: Float?
    internal let rain24HourIn: Float?
    internal let rainWeeklyIn: Float?
    internal let rainMonthlyIn: Float?
    internal let rainYearlyIn: Float?
    internal let rainEventIn: Float?
    internal let rainTotalIn: Float?
    internal let barometerRelativeInHg: Float?
    internal let barometerAbsoluteInHg: Float?
    internal let uvIndex: Int?
    internal let solarRadiation: Float?
    internal let carbonDioxide: Float?
    internal let relay1: Int?
    internal let relay2: Int?
    internal let relay3: Int?
    internal let relay4: Int?
    internal let relay5: Int?
    internal let relay6: Int?
    internal let relay7: Int?
    internal let relay8: Int?
    internal let relay9: Int?
    internal let relay10: Int?
    internal let airQualityOut: Float?
    internal let airQualityOut24: Float?
    internal let airQualityIn: Float?
    internal let airQualityIn24: Float?
    internal let timeZone:  String?
    internal let dateUTC:  Int?
    internal let rainLastDate:  String?
    internal let dewPointOut:  Float?
    internal let dewPointIn:  Float?
    internal let tempFeelsLikeOutF: Float?
    internal let tempFeelsLikeInF: Float?
    internal let dateStation:  String?
    internal let tempFeelsLikeOut1: Float?
    internal let tempFeelsLikeOut2: Float?
    internal let tempFeelsLikeOut3: Float?
    internal let tempFeelsLikeOut4: Float?
    internal let tempFeelsLikeOut5: Float?
    internal let tempFeelsLikeOut6: Float?
    internal let tempFeelsLikeOut7: Float?
    internal let tempFeelsLikeOut8: Float?
    internal let tempFeelsLikeOut9: Float?
    internal let tempFeelsLikeOut10: Float?
    internal let dewPoint1: Float?
    internal let dewPoint2: Float?
    internal let dewPoint3: Float?
    internal let dewPoint4: Float?
    internal let dewPoint5: Float?
    internal let dewPoint6: Float?
    internal let dewPoint7: Float?
    internal let dewPoint8: Float?
    internal let dewPoint9: Float?
    internal let dewPoint10: Float?
    
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
        case soilHumOut1 = "soilhum1"
        case soilHumOut2 = "soilhum2"
        case soilHumOut3 = "soilhum3"
        case soilHumOut4 = "soilhum4"
        case soilHumOut5 = "soilhum5"
        case soilHumOut6 = "soilhum6"
        case soilHumOut7 = "soilhum7"
        case soilHumOut8 = "soilhum8"
        case soilHumOut9 = "soilhum9"
        case soilHumOut10 = "soilhum10"
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
        
        return sensors.compactMap { $0 }
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
            debugInfo = "\(debugInfo)\n\(sensor.formatted())"
        }
        return debugInfo
    }
}
