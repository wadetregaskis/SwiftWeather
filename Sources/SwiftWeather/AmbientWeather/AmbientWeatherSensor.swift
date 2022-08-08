//  Created by Mike Manzo on 5/30/20.

import Foundation

open class AmbientWeatherSensor: WeatherSensor {
    ///
    /// A compact way to progamatically represent an AmbientWeather Sensor as defined in the API docs
    /// - Parameters:
    ///     - _value: We are taking advantage of the fact that some of the AW sensors can have units that are convertible.  Those that are fixed - are fixed.
    ///
    required public init (type: WeatherSensorType, name: String, sensorID: String, measurement: Any, unit: String, desc: String) {
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

        super.init(type: type, name: name, sensorID: sensorID, measurement: value, unit: unit, desc: desc)
    }
}
