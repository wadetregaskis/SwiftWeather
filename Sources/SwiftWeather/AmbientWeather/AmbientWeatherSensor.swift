//  Created by Mike Manzo on 5/30/20.

import Foundation

public class AmbientWeatherSensor: WeatherSensor {
    internal let rawValue: any Codable

    required internal init(type: WeatherSensorType,
                  sensorID: String,
                  name: String,
                  description: String,
                  measurement: Any,
                  unit: String,
                  rawValue: any Codable) {
        var value = measurement

        switch type {
        case .Pressure:
            if let measurement = measurement as? Double {
                value = Measurement(value: Double(measurement), unit: UnitPressure.inchesOfMercury)
            }
        case .Temperature:
            if let measurement = measurement as? Double {
                value = Measurement(value: Double(measurement), unit: UnitTemperature.fahrenheit)
            }
        case .AirQuality:
            if let measurement = measurement as? Double {
                value = Measurement(value: Double(measurement), unit: Unit(symbol: unit))
            }
        case .WindSpeed:
            if let measurement = measurement as? Double {
                value = Measurement(value: Double(measurement), unit: UnitSpeed.milesPerHour)
            }
        case .RainRate:
            if let measurement = measurement as? Double {
                value = Measurement(value: Double(measurement) , unit: Unit(symbol: unit))
            }
        case .Rain:
            if let measurement = measurement as? Double {
                value = Measurement(value: Double(measurement) , unit: UnitLength.inches)
            }
        case .Humidity:
            if let measurement = measurement as? Int {
                value = Measurement(value: Double(measurement), unit: Unit(symbol: unit))
            }
        case .WindDirection:
            if let measurement = measurement as? Int {
                value = Measurement(value: Double(measurement), unit: UnitAngle.degrees)
            }
        case .Radiation, .Battery, .RainDate, .General: // Unit-less
            break
        }

        self.rawValue = rawValue
        
        super.init(type: type,
                   sensorID: sensorID,
                   name: name,
                   description: description,
                   measurement: value,
                   unit: unit)
    }

    required public convenience init(type: WeatherSensorType,
                sensorID: String,
                name: String,
                description: String,
                measurement: Any,
                unit: String) {
        self.init(type: type, sensorID: sensorID, name: name, description: description, measurement: measurement, unit: unit, rawValue: measurement as! Codable) // TODO: Get rid of this forced cast.
    }
}
