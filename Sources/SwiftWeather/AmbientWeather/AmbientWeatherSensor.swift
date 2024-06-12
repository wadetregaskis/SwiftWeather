//  Created by Mike Manzo on 5/30/20.

public class AmbientWeatherSensor: WeatherSensor, @unchecked Sendable {
    internal let rawValue: any Codable

    required internal init(type: WeatherSensorType,
                           sensorID: String,
                           name: String,
                           description: String?,
                           measurement: Any,
                           rawValue: any Codable) {
        self.rawValue = rawValue
        
        super.init(type: type,
                   sensorID: sensorID,
                   name: name,
                   description: description,
                   measurement: measurement)
    }

    required public convenience override init(type: WeatherSensorType,
                                              sensorID: String,
                                              name: String,
                                              description: String?,
                                              measurement: Any) {
        self.init(type: type,
                  sensorID: sensorID,
                  name: name,
                  description: description,
                  measurement: measurement,
                  rawValue: measurement as! any Codable) // TODO: Get rid of this forced cast.
    }
}
