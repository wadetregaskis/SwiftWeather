//
//  AmbientWeatherSensor.swift
//  
//
//  Created by Mike Manzo on 5/30/20.
//

import Foundation

open class AmbientWeatherSensor: WeatherSensor {
    
    ///
    /// Provides a simple way to "see" what ths device is reporting
    ///
    open var formattedValue: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        
        switch type {
        case .Pressure:
            return String("\(formatter.string(from: _value as! Measurement<UnitPressure>))")
        case .Temperature:
            return String("\(formatter.string(from: _value as! Measurement<UnitTemperature>))")
        case .AirQuality:
            return String("\(_value)")
        case .WindSpeed:
            return String("\(formatter.string(from: _value as! Measurement<UnitSpeed>))")
        case .RainRate:
            return String("\(_value)")
        case .Rain:
            return String("\(formatter.string(from: _value as! Measurement<UnitLength>))")
        case .Humidity:
            return String("\(_value)")
        case .WindDirection:
            return String("\(formatter.string(from: _value as! Measurement<UnitAngle>))")
        case .Battery:
            return String("\(_value as! Int == 1 ? "Good" : "Low")")
        case .RainDate:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .init(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let rainDate = dateFormatter.date(from: _value as! String)
            let rainDateFormatter = DateFormatter()
            rainDateFormatter.dateFormat = "MMM dd,yyyy hh:mm a"
            return String("\(rainDateFormatter.string(from: rainDate!))")
        case .Radiation, .General: // Unit-less
            return String("\(_value)")
        }
    }
    
    ///
    /// Provides a simple way to "see" what ths device is reporting
    ///
    open override var prettyString: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        
        switch type {
        case .Pressure:
            return String("\(_name): \(formatter.string(from: _value as! Measurement<UnitPressure>))")
        case .Temperature:
            return String("\(_name): \(formatter.string(from: _value as! Measurement<UnitTemperature>))")
        case .AirQuality:
            return String("\(_name): \(_value)")
        case .WindSpeed:
            return String("\(_name): \(formatter.string(from: _value as! Measurement<UnitSpeed>))")
        case .RainRate:
            return String("\(_name): \(_value)")
        case .Rain:
            return String("\(_name): \(formatter.string(from: _value as! Measurement<UnitLength>))")
        case .Humidity:
            return String("\(_name): \(_value)")
        case .WindDirection:
            return String("\(_name): \(formatter.string(from: _value as! Measurement<UnitAngle>))")
        case .Battery:
            return String("\(_name): \(_value as! Int == 1 ? "Good" : "Low")")
        case .RainDate:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .init(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let rainDate = dateFormatter.date(from: _value as! String)
            let rainDateFormatter = DateFormatter()
            rainDateFormatter.dateFormat = "MMM dd,yyyy hh:mm a"
            return String("\(_name): \(rainDateFormatter.string(from: rainDate!))")
        case .Radiation, .General: // Unit-less
            return String("\(_name): \(_value)")
        }
    }
    
    ///
    /// A compact way to progamatically represent an AmbientWeather Sensor as defined in the API docs
    /// - Parameters:
    ///     - _value: We are taking advantage of the fact that some of the AW sensors can have units that are convertible.  Those that are fixed - are fixed.
    ///
    required public init (type: WeatherSensorType, name: String, sensorID: String, measurement: Any, unit: String, desc: String) {
        super.init(type: type, name: name, sensorID: sensorID, measurement: measurement, unit: unit, desc: desc)
        
        switch type {
        case .Pressure:
            _value = Measurement(value: Double(measurement as! Float), unit: UnitPressure.inchesOfMercury)
        case .Temperature:
            _value = Measurement(value: Double(measurement as! Float), unit: UnitTemperature.fahrenheit)
        case .AirQuality:
            _value = Measurement(value: Double(measurement as! Float), unit: Unit(symbol: "µg/m^3"))
        case .WindSpeed:
            _value = Measurement(value: Double(measurement as! Float), unit: UnitSpeed.milesPerHour)
        case .RainRate:
            _value = Measurement(value: Double(measurement as! Float) , unit: Unit(symbol: "in/hr"))
        case .Rain:
            _value = Measurement(value: Double(measurement as! Float) , unit: UnitLength.inches)
        case .Humidity:
            _value = Measurement(value: Double(measurement as! Int), unit: Unit(symbol: "%"))
        case .WindDirection:
            _value = Measurement(value: Double(measurement as! Int), unit: UnitAngle.degrees)
        case .Radiation, .Battery, .RainDate, .General: // Unit-less
            break
        }
    }
}
