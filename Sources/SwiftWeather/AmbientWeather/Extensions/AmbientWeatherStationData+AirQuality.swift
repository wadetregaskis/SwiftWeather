//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherStationData {
    var AirQualitySensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [AirQualityOutdoor, AirQualityOutdoor24Avg, AirQualityIndoor,
                                                AirQualityIndoor24Avg, UVIndex, SolarRadiation, CarbonDioxide]
        return sensors.compactMap{ $0 }
    }
    
    var AirQualityOutdoor: AmbientWeatherSensor? {
        guard let airQualityOut else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, name: "Outdoor Air Quality", sensorID: "pm25", measurement: airQualityOut, unit: "µg/m^3", desc: "PM2.5 Outdoor Air Quality")
    }
    
    var AirQualityOutdoor24Avg: AmbientWeatherSensor? {
        guard let airQualityOut24 else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, name: "24 Average Outdoor Air Quality", sensorID: "pm25_24h", measurement: airQualityOut24, unit: "µg/m^3", desc: "PM2.5 Outdoor Air Quality Outdoor - 24 Hour Average")
    }
    
    var AirQualityIndoor: AmbientWeatherSensor? {
        guard let airQualityIn else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, name: "Indoor Air Quality", sensorID: "pm25_in", measurement: airQualityIn, unit: "µg/m^3", desc: "PM2.5 Indoor Air Quality")
    }
    
    var AirQualityIndoor24Avg: AmbientWeatherSensor? {
        guard let airQualityIn24 else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, name: "24 Average Indoor Air Quality", sensorID: "pm25_in_24h", measurement: airQualityIn24, unit: "µg/m^3", desc: "PM2.5 Indoor Air Quality - 24 Hour Average")
    }
    
    var UVIndex: AmbientWeatherSensor? {
        guard let uvIndex else { return nil }

        return AmbientWeatherSensor(type: .Radiation, name: "UV Index", sensorID: "uv", measurement: uvIndex, unit: "None", desc: "Ultra-Violet Radiation Index")
    }
    
    var SolarRadiation: AmbientWeatherSensor? {
        guard let solarRadiation else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, name: "Solar Radiation", sensorID: "solarradiation", measurement: solarRadiation, unit: "W/m^2", desc: "Solar Radiation")
    }
    
    var CarbonDioxide: AmbientWeatherSensor? {
        guard let carbonDioxide else { return nil }

        return AmbientWeatherSensor(type: .AirQuality, name: "CO2 Level", sensorID: "co2", measurement: carbonDioxide, unit: "ppm", desc: "Carbon Dioxide Level")
    }
}
