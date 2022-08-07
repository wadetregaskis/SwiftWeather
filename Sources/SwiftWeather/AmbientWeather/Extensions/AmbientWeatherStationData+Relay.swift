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
        guard let relay1 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 1", sensorID: "relay1", measurement: relay1, unit: "None", desc: "Relay Sensor #1")
    }
    
    var RelaySensor2: AmbientWeatherSensor? {
        guard let relay2 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 2", sensorID: "relay2", measurement: relay2, unit: "None", desc: "Relay Sensor #2")
    }
    
    var RelaySensor3: AmbientWeatherSensor? {
        guard let relay3 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 3", sensorID: "relay3", measurement: relay3, unit: "None", desc: "Relay Sensor #3")
    }
    
    var RelaySensor4: AmbientWeatherSensor? {
        guard let relay4 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 4", sensorID: "relay4", measurement: relay4, unit: "None", desc: "Relay Sensor #4")
    }
    
    var RelaySensor5: AmbientWeatherSensor? {
        guard let relay5 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 5", sensorID: "relay5", measurement: relay5, unit: "None", desc: "Relay Sensor #5")
    }
    
    var RelaySensor6: AmbientWeatherSensor? {
        guard let relay6 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 6", sensorID: "relay6", measurement: relay6, unit: "None", desc: "Relay Sensor #6")
    }
    
    var RelaySensor7: AmbientWeatherSensor? {
        guard let relay7 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 7", sensorID: "relay7", measurement: relay7, unit: "None", desc: "Relay Sensor #7")
    }
    
    var RelaySensor8: AmbientWeatherSensor? {
        guard let relay8 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 8", sensorID: "relay8", measurement: relay8, unit: "None", desc: "Relay Sensor #8")
    }
    
    var RelaySensor9: AmbientWeatherSensor? {
        guard let relay9 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 9", sensorID: "relay9", measurement: relay9, unit: "None", desc: "Relay Sensor #9")
    }
    
    var RelaySensor10: AmbientWeatherSensor? {
        guard let relay10 else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Relay: 10", sensorID: "relay10", measurement: relay10, unit: "None", desc: "Relay Sensor #10")
    }
}
