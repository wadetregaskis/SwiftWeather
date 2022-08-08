//  Created by Mike Manzo on 5/30/20.

import Foundation

open class AmbientWeatherSensor: WeatherSensor {
    required public init(type: WeatherSensorType,
                         sensorID: String,
                         name: String,
                         description: String,
                         measurement: Any,
                         unit: String) {
        var value = measurement

        switch type {
        case .Pressure:
            if let measurement = measurement as? Float {
                value = Measurement(value: Double(measurement), unit: UnitPressure.inchesOfMercury)
            }
        case .Temperature:
            if let measurement = measurement as? Float {
                value = Measurement(value: Double(measurement), unit: UnitTemperature.fahrenheit)
            }
        case .AirQuality:
            if let measurement = measurement as? Float {
                value = Measurement(value: Double(measurement), unit: Unit(symbol: "µg/m^3"))
            }
        case .WindSpeed:
            if let measurement = measurement as? Float {
                value = Measurement(value: Double(measurement), unit: UnitSpeed.milesPerHour)
            }
        case .RainRate:
            if let measurement = measurement as? Float {
                value = Measurement(value: Double(measurement) , unit: Unit(symbol: "in/hr"))
            }
        case .Rain:
            if let measurement = measurement as? Float {
                value = Measurement(value: Double(measurement) , unit: UnitLength.inches)
            }
        case .Humidity:
            if let measurement = measurement as? Int {
                value = Measurement(value: Double(measurement), unit: Unit(symbol: "%"))
            }
        case .WindDirection:
            if let measurement = measurement as? Int {
                value = Measurement(value: Double(measurement), unit: UnitAngle.degrees)
            }
        case .Radiation, .Battery, .RainDate, .General: // Unit-less
            break
        }

        super.init(type: type, sensorID: sensorID, name: name, description: description, measurement: value, unit: unit)
    }
}
