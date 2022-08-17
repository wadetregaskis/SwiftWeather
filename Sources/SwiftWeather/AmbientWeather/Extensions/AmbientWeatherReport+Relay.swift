//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherReport {
    var RelaySensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [RelaySensor1, RelaySensor2, RelaySensor3, RelaySensor4, RelaySensor5,
                                                RelaySensor6, RelaySensor7, RelaySensor8, RelaySensor9, RelaySensor10]
        return sensors.compactMap{ $0 }
    }
    
    var RelaySensor1: AmbientWeatherSensor? {
        guard let relay1 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay1", name: "Relay: 1", description: "Relay Sensor #1", measurement: relay1, unit: "None")
    }
    
    var RelaySensor2: AmbientWeatherSensor? {
        guard let relay2 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay2", name: "Relay: 2", description: "Relay Sensor #2", measurement: relay2, unit: "None")
    }
    
    var RelaySensor3: AmbientWeatherSensor? {
        guard let relay3 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay3", name: "Relay: 3", description: "Relay Sensor #3", measurement: relay3, unit: "None")
    }
    
    var RelaySensor4: AmbientWeatherSensor? {
        guard let relay4 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay4", name: "Relay: 4", description: "Relay Sensor #4", measurement: relay4, unit: "None")
    }
    
    var RelaySensor5: AmbientWeatherSensor? {
        guard let relay5 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay5", name: "Relay: 5", description: "Relay Sensor #5", measurement: relay5, unit: "None")
    }
    
    var RelaySensor6: AmbientWeatherSensor? {
        guard let relay6 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay6", name: "Relay: 6", description: "Relay Sensor #6", measurement: relay6, unit: "None")
    }
    
    var RelaySensor7: AmbientWeatherSensor? {
        guard let relay7 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay7", name: "Relay: 7", description: "Relay Sensor #7", measurement: relay7, unit: "None")
    }
    
    var RelaySensor8: AmbientWeatherSensor? {
        guard let relay8 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay8", name: "Relay: 8", description: "Relay Sensor #8", measurement: relay8, unit: "None")
    }
    
    var RelaySensor9: AmbientWeatherSensor? {
        guard let relay9 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay9", name: "Relay: 9", description: "Relay Sensor #9", measurement: relay9, unit: "None")
    }
    
    var RelaySensor10: AmbientWeatherSensor? {
        guard let relay10 else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "relay10", name: "Relay: 10", description: "Relay Sensor #10", measurement: relay10, unit: "None")
    }
}
