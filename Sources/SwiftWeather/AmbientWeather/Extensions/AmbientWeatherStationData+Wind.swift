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
        if windDirection != nil {
            return AmbientWeatherSensor(type: .WindDirection, name: "Wind Direction", sensorID: "winddir", measurement: windDirection!, unit: "º", desc: "Instantaneous wind direction, 0-360º")
        } else {
            return nil
        }
    }
    
    var WindSpeed: AmbientWeatherSensor? {
        if windSpeedMPH != nil {
            return AmbientWeatherSensor(type: .WindSpeed, name: "Wind Speed", sensorID: "windspeedmph", measurement: windSpeedMPH!, unit: "MPH", desc: "Instantaneous wind speed")
        } else {
            return nil
        }
    }
    
    var WindGust: AmbientWeatherSensor? {
        if windGustMPH != nil {
            return AmbientWeatherSensor(type: .WindSpeed, name: "Wind Gust", sensorID: "windgustmph", measurement: windGustMPH!, unit: "MPH", desc: "Maximum wind speed in the last 10 minutes")
        } else {
            return nil
        }
    }
    
    var WindGustDailyMax: AmbientWeatherSensor? {
        if windGustDailyMax != nil {
            return AmbientWeatherSensor(type: .WindSpeed, name: "Max Wind Gust Today", sensorID: "maxdailygust", measurement: windGustDailyMax!, unit: "MPH", desc: "Maximum wind speed in last day")
        } else {
            return nil
        }
    }
    
    var WindGustDirection: AmbientWeatherSensor? {
        if windGustDir != nil {
            return AmbientWeatherSensor(type: .WindDirection, name: "Wind Gust Direction", sensorID: "windgustdir", measurement: windGustDir!, unit: "º", desc: "Wind direction at which the wind gust occurred")
        } else {
            return nil
        }
    }
    
    var WindSpeed2MinAverage: AmbientWeatherSensor? {
        if windSpeedAvg2Min != nil {
            return AmbientWeatherSensor(type: .WindSpeed, name: "2 Minute Wind Speed Avg", sensorID: "windspdmph_avg2m", measurement: windSpeedAvg2Min!, unit: "MPH", desc: "Average wind speed, 2 minute average")
        } else {
            return nil
        }
    }
    
    var WindDirection2MinAverage: AmbientWeatherSensor? {
        if winDir2Min != nil {
            return AmbientWeatherSensor(type: .WindDirection, name: "2 Minute Wind Direction Avg", sensorID: "winddir_avg2m", measurement: winDir2Min!, unit: "º", desc: "Average wind direction, 2 minute average")
        } else {
            return nil
        }
    }
    
    var WindSpeed10MinAverage: AmbientWeatherSensor? {
        if windSpeedAvg10Min != nil {
            return AmbientWeatherSensor(type: .WindSpeed, name: "10 Minute Wind Speed Avg", sensorID: "windspdmph_avg10m", measurement: windSpeedAvg10Min!, unit: "MPH", desc: "Average wind speed, 10 minute average")
        } else {
            return nil
        }
    }
    
    var WindDirection10MinAverage: AmbientWeatherSensor? {
        if windDir10Min != nil {
            return AmbientWeatherSensor(type: .WindDirection, name: "10 Minute Wind Direction Avg", sensorID: "winddir_avg10m", measurement: windDir10Min!, unit: "º", desc: "Average wind direction, 10 minute average")
        } else {
            return nil
        }
    }
}
