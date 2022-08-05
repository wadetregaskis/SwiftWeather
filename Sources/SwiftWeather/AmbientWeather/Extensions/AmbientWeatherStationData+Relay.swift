//
//  StationData+Relay.swift
//  
//
//  Created by Mike Manzo on 5/11/20.
//

import Foundation

extension AmbientWeatherStationData {
    var RelaySensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [RelaySensor1, RelaySensor2, RelaySensor3, RelaySensor4, RelaySensor5,
                                                RelaySensor6, RelaySensor7, RelaySensor8, RelaySensor9, RelaySensor10]
        return sensors.compactMap{ $0 }
    }
    
    var RelaySensor1: AmbientWeatherSensor? {
        if relay1 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 1", sensorID: "relay1", measurement: relay1!, unit: "None", desc: "Relay Sensor #1")
        } else {
            return nil
        }
    }
    
    var RelaySensor2: AmbientWeatherSensor? {
        if relay2 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 2", sensorID: "relay2", measurement: relay2!, unit: "None", desc: "Relay Sensor #2")
        } else {
            return nil
        }
    }
    
    var RelaySensor3: AmbientWeatherSensor? {
        if relay3 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 3", sensorID: "relay3", measurement: relay3!, unit: "None", desc: "Relay Sensor #3")
        } else {
            return nil
        }
    }
    
    var RelaySensor4: AmbientWeatherSensor? {
        if relay4 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 4", sensorID: "relay4", measurement: relay4!, unit: "None", desc: "Relay Sensor #4")
        } else {
            return nil
        }
    }
    
    var RelaySensor5: AmbientWeatherSensor? {
        if relay5 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 5", sensorID: "relay5", measurement: relay5!, unit: "None", desc: "Relay Sensor #5")
        } else {
            return nil
        }
    }
    
    var RelaySensor6: AmbientWeatherSensor? {
        if relay6 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 6", sensorID: "relay6", measurement: relay6!, unit: "None", desc: "Relay Sensor #6")
        } else {
            return nil
        }
    }
    
    var RelaySensor7: AmbientWeatherSensor? {
        if relay7 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 7", sensorID: "relay7", measurement: relay7!, unit: "None", desc: "Relay Sensor #7")
        } else {
            return nil
        }
    }
    
    var RelaySensor8: AmbientWeatherSensor? {
        if relay8 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 8", sensorID: "relay8", measurement: relay8!, unit: "None", desc: "Relay Sensor #8")
        } else {
            return nil
        }
    }
    
    var RelaySensor9: AmbientWeatherSensor? {
        if relay9 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 9", sensorID: "relay9", measurement: relay9!, unit: "None", desc: "Relay Sensor #9")
        } else {
            return nil
        }
    }
    
    var RelaySensor10: AmbientWeatherSensor? {
        if relay10 != nil {
            return AmbientWeatherSensor(type: .General, name: "Relay: 10", sensorID: "relay10", measurement: relay10!, unit: "None", desc: "Relay Sensor #10")
        } else {
            return nil
        }
    }
}
