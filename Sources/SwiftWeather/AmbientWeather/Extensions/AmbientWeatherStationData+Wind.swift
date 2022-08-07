//
//  StationData+Wind.swift
//  
//
//  Created by Mike Manzo on 5/11/20.
//

import Foundation

extension AmbientWeatherStationData {
    var WindSensors: [AmbientWeatherSensor] {
        get {
            let sensors: [AmbientWeatherSensor?] = [WindDirection, WindSpeed, WindGust, WindGustDailyMax,
                                                    WindGustDirection, WindSpeed2MinAverage, WindSpeed10MinAverage,
                                                    WindDirection10MinAverage]
            return sensors.compactMap{ $0 }
        }
    }
    
    var WindDirection: AmbientWeatherSensor? {
        guard let windDirection else { return nil }

        return AmbientWeatherSensor(type: .WindDirection, name: "Wind Direction", sensorID: "winddir", measurement: windDirection, unit: "º", desc: "Instantaneous wind direction, 0-360º")
    }
    
    var WindSpeed: AmbientWeatherSensor? {
        guard let windSpeedMPH else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, name: "Wind Speed", sensorID: "windspeedmph", measurement: windSpeedMPH, unit: "MPH", desc: "Instantaneous wind speed")
    }
    
    var WindGust: AmbientWeatherSensor? {
        guard let windGustMPH else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, name: "Wind Gust", sensorID: "windgustmph", measurement: windGustMPH, unit: "MPH", desc: "Maximum wind speed in the last 10 minutes")
    }
    
    var WindGustDailyMax: AmbientWeatherSensor? {
        guard let windGustDailyMax else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, name: "Max Wind Gust Today", sensorID: "maxdailygust", measurement: windGustDailyMax, unit: "MPH", desc: "Maximum wind speed in last day")
    }
    
    var WindGustDirection: AmbientWeatherSensor? {
        guard let windGustDir else { return nil }

        return AmbientWeatherSensor(type: .WindDirection, name: "Wind Gust Direction", sensorID: "windgustdir", measurement: windGustDir, unit: "º", desc: "Wind direction at which the wind gust occurred")
    }
    
    var WindSpeed2MinAverage: AmbientWeatherSensor? {
        guard let windSpeedAvg2Min else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, name: "2 Minute Wind Speed Avg", sensorID: "windspdmph_avg2m", measurement: windSpeedAvg2Min, unit: "MPH", desc: "Average wind speed, 2 minute average")
    }
    
    var WindDirection2MinAverage: AmbientWeatherSensor? {
        guard let winDir2Min else { return nil }

        return AmbientWeatherSensor(type: .WindDirection, name: "2 Minute Wind Direction Avg", sensorID: "winddir_avg2m", measurement: winDir2Min, unit: "º", desc: "Average wind direction, 2 minute average")
    }
    
    var WindSpeed10MinAverage: AmbientWeatherSensor? {
        guard let windSpeedAvg10Min else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, name: "10 Minute Wind Speed Avg", sensorID: "windspdmph_avg10m", measurement: windSpeedAvg10Min, unit: "MPH", desc: "Average wind speed, 10 minute average")
    }
    
    var WindDirection10MinAverage: AmbientWeatherSensor? {
        guard let windDir10Min else { return nil }

        return AmbientWeatherSensor(type: .WindDirection, name: "10 Minute Wind Direction Avg", sensorID: "winddir_avg10m", measurement: windDir10Min, unit: "º", desc: "Average wind direction, 10 minute average")
    }
}
