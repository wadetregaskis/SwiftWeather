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
            value = Measurement(value: Double(measurement as! Float), unit: UnitPressure.inchesOfMercury)
        case .Temperature:
            value = Measurement(value: Double(measurement as! Float), unit: UnitTemperature.fahrenheit)
        case .AirQuality:
            value = Measurement(value: Double(measurement as! Float), unit: Unit(symbol: "µg/m^3"))
        case .WindSpeed:
            value = Measurement(value: Double(measurement as! Float), unit: UnitSpeed.milesPerHour)
        case .RainRate:
            value = Measurement(value: Double(measurement as! Float) , unit: Unit(symbol: "in/hr"))
        case .Rain:
            value = Measurement(value: Double(measurement as! Float) , unit: UnitLength.inches)
        case .Humidity:
            value = Measurement(value: Double(measurement as! Int), unit: Unit(symbol: "%"))
        case .WindDirection:
            value = Measurement(value: Double(measurement as! Int), unit: UnitAngle.degrees)
        case .Radiation, .Battery, .RainDate, .General: // Unit-less
            break
        }

        super.init(type: type, sensorID: sensorID, name: name, description: description, measurement: value, unit: unit)
    }
}
