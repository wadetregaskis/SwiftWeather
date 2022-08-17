//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherReport {
    var AirQualitySensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [AirQualityOutdoor, AirQualityOutdoor24Avg, AirQualityIndoor,
                                                AirQualityIndoor24Avg, UVIndex, SolarRadiation, CarbonDioxide]
        return sensors.compactMap{ $0 }
    }
    
    var AirQualityOutdoor: AmbientWeatherSensor? {
        guard let airQualityOut else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, sensorID: "pm25", name: "Outdoor Air Quality", description: "PM2.5 Outdoor Air Quality", measurement: airQualityOut, unit: "µg/m^3")
    }
    
    var AirQualityOutdoor24Avg: AmbientWeatherSensor? {
        guard let airQualityOut24 else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, sensorID: "pm25_24h", name: "24 Average Outdoor Air Quality", description: "PM2.5 Outdoor Air Quality Outdoor - 24 Hour Average", measurement: airQualityOut24, unit: "µg/m^3")
    }
    
    var AirQualityIndoor: AmbientWeatherSensor? {
        guard let airQualityIn else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, sensorID: "pm25_in", name: "Indoor Air Quality", description: "PM2.5 Indoor Air Quality", measurement: airQualityIn, unit: "µg/m^3")
    }
    
    var AirQualityIndoor24Avg: AmbientWeatherSensor? {
        guard let airQualityIn24 else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, sensorID: "pm25_in_24h", name: "24 Average Indoor Air Quality", description: "PM2.5 Indoor Air Quality - 24 Hour Average", measurement: airQualityIn24, unit: "µg/m^3")
    }
    
    var UVIndex: AmbientWeatherSensor? {
        guard let uvIndex else { return nil }

        return AmbientWeatherSensor(type: .Radiation, sensorID: "uv", name: "UV Index", description: "Ultra-Violet Radiation Index", measurement: uvIndex, unit: "None")
    }
    
    var SolarRadiation: AmbientWeatherSensor? {
        guard let solarRadiation else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, sensorID: "solarradiation", name: "Solar Radiation", description: "Solar Radiation", measurement: solarRadiation, unit: "W/m^2")
    }
    
    var CarbonDioxide: AmbientWeatherSensor? {
        guard let carbonDioxide else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, sensorID: "co2", name: "CO2 Level", description: "Carbon Dioxide Level", measurement: carbonDioxide, unit: "ppm")
    }
}
