//
//  StationData+Pressure.swift
//  
//
//  Created by Mike Manzo on 5/11/20.
//

import Foundation

extension AmbientWeatherStationData {
    var PressureSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [PressureRelative, PressureAbsolute]
        return sensors.compactMap{ $0 }
    }
    
    var PressureRelative: AmbientWeatherSensor? {
        if barometerRelativeInHg != nil {
            return AmbientWeatherSensor(type: .Pressure, name: "Relative Pressure", sensorID: "baromrelin", measurement: barometerRelativeInHg!, unit: "inHg", desc: "Relative Pressure")
        } else {
            return nil
        }
    }
    
    var PressureAbsolute: AmbientWeatherSensor? {
        if barometerAbsoluteInHg != nil {
            return AmbientWeatherSensor(type: .Pressure, name: "Absolute Pressure", sensorID: "baromabsin", measurement: barometerAbsoluteInHg!, unit: "inHg", desc: "Absolute Pressure")
        } else {
            return nil
        }
    }
}
