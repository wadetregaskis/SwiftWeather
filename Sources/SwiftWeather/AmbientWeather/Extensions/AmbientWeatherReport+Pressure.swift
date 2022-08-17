//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherReport {
    var PressureSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [PressureRelative, PressureAbsolute]
        return sensors.compactMap{ $0 }
    }
    
    var PressureRelative: AmbientWeatherSensor? {
        guard let barometerRelativeInHg else { return nil }

        return AmbientWeatherSensor(type: .Pressure, sensorID: "baromrelin", name: "Relative Pressure", description: "Relative Pressure", measurement: barometerRelativeInHg, unit: "inHg")
    }
    
    var PressureAbsolute: AmbientWeatherSensor? {
        guard let barometerAbsoluteInHg else { return nil }

        return AmbientWeatherSensor(type: .Pressure, sensorID: "baromabsin", name: "Absolute Pressure", description: "Absolute Pressure", measurement: barometerAbsoluteInHg, unit: "inHg")
    }
}
