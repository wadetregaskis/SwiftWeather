//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherReport {
    var AirQualitySensors: [AmbientWeatherSensor] {
        let sensorMetadata: [(type: WeatherSensorType,
                              ID: String,
                              keyPath: PartialKeyPath<AmbientWeatherReport>,
                              name: String,
                              description: String,
                              unit: String)] = [
            (.AirQuality,
             "pm25",
             \.airQualityOut,
             "Outdoor Air Quality",
             "PM2.5 Outdoor Air Quality",
             "µg/m^3"),
            (.AirQuality,
             "pm25_24h",
             \.airQualityOut24,
             "24 Average Outdoor Air Quality",
             "PM2.5 Outdoor Air Quality Outdoor - 24 Hour Average",
             "µg/m^3"),
            (.AirQuality,
             "pm25_in",
             \.airQualityIn,
             "Indoor Air Quality",
             "PM2.5 Indoor Air Quality",
             "µg/m^3"),
            (.AirQuality,
             "pm25_in_24h",
             \.airQualityIn24,
             "24 Average Indoor Air Quality",
             "PM2.5 Indoor Air Quality - 24 Hour Average",
             "µg/m^3"),
            (.AirQuality,
             "solarradiation",
             \.solarRadiation,
             "Solar Radiation",
             "Solar Radiation",
             "W/m^2"),
            (.AirQuality,
             "co2",
             \.carbonDioxide,
             "CO2 Level",
             "Carbon Dioxide Level",
             "ppm"),
            (.Radiation,
             "uv",
             \.uvIndex,
             "UV Index",
             "Ultra-Violet Radiation Index",
             "None")]

        return sensorMetadata.compactMap {
            var value = self[keyPath: $0.keyPath]
            let mirror = Mirror(reflecting: value)

            if mirror.displayStyle == .optional {
                guard let first = mirror.children.first else {
                    return nil
                }

                value = first.value
            }

            return AmbientWeatherSensor(type: $0.type,
                                        sensorID: $0.ID,
                                        name: $0.name,
                                        description: $0.description,
                                        measurement: value,
                                        unit: $0.unit)
        }
    }
}
