//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherStationData {
    var PressureSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [PressureRelative, PressureAbsolute]
        return sensors.compactMap{ $0 }
    }
    
    var PressureRelative: AmbientWeatherSensor? {
        guard let barometerRelativeInHg else { return nil }

        return AmbientWeatherSensor(type: .Pressure, name: "Relative Pressure", sensorID: "baromrelin", measurement: barometerRelativeInHg, unit: "inHg", desc: "Relative Pressure")
    }
    
    var PressureAbsolute: AmbientWeatherSensor? {
        guard let barometerAbsoluteInHg else { return nil }

        return AmbientWeatherSensor(type: .Pressure, name: "Absolute Pressure", sensorID: "baromabsin", measurement: barometerAbsoluteInHg, unit: "inHg", desc: "Absolute Pressure")
    }
}
