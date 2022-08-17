//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherReport {
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

        return AmbientWeatherSensor(type: .WindDirection, sensorID: "winddir", name: "Wind Direction", description: "Instantaneous wind direction, 0-360º", measurement: windDirection, unit: "º")
    }
    
    var WindSpeed: AmbientWeatherSensor? {
        guard let windSpeedMPH else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, sensorID: "windspeedmph", name: "Wind Speed", description: "Instantaneous wind speed", measurement: windSpeedMPH, unit: "MPH")
    }
    
    var WindGust: AmbientWeatherSensor? {
        guard let windGustMPH else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, sensorID: "windgustmph", name: "Wind Gust", description: "Maximum wind speed in the last 10 minutes", measurement: windGustMPH, unit: "MPH")
    }
    
    var WindGustDailyMax: AmbientWeatherSensor? {
        guard let windGustDailyMax else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, sensorID: "maxdailygust", name: "Max Wind Gust Today", description: "Maximum wind speed in last day", measurement: windGustDailyMax, unit: "MPH")
    }
    
    var WindGustDirection: AmbientWeatherSensor? {
        guard let windGustDir else { return nil }

        return AmbientWeatherSensor(type: .WindDirection, sensorID: "windgustdir", name: "Wind Gust Direction", description: "Wind direction at which the wind gust occurred", measurement: windGustDir, unit: "º")
    }
    
    var WindSpeed2MinAverage: AmbientWeatherSensor? {
        guard let windSpeedAvg2Min else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, sensorID: "windspdmph_avg2m", name: "2 Minute Wind Speed Avg", description: "Average wind speed, 2 minute average", measurement: windSpeedAvg2Min, unit: "MPH")
    }
    
    var WindDirection2MinAverage: AmbientWeatherSensor? {
        guard let winDir2Min else { return nil }

        return AmbientWeatherSensor(type: .WindDirection, sensorID: "winddir_avg2m", name: "2 Minute Wind Direction Avg", description: "Average wind direction, 2 minute average", measurement: winDir2Min, unit: "º")
    }
    
    var WindSpeed10MinAverage: AmbientWeatherSensor? {
        guard let windSpeedAvg10Min else { return nil }

        return AmbientWeatherSensor(type: .WindSpeed, sensorID: "windspdmph_avg10m", name: "10 Minute Wind Speed Avg", description: "Average wind speed, 10 minute average", measurement: windSpeedAvg10Min, unit: "MPH")
    }
    
    var WindDirection10MinAverage: AmbientWeatherSensor? {
        guard let windDir10Min else { return nil }

        return AmbientWeatherSensor(type: .WindDirection, sensorID: "winddir_avg10m", name: "10 Minute Wind Direction Avg", description: "Average wind direction, 10 minute average", measurement: windDir10Min, unit: "º")
    }
}
