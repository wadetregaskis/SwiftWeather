//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherStationData {
    var BatterySensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [BatterySensor, BatterySensor1, BatterySensor2, BatterySensor3,
                                                BatterySensor4, BatterySensor5, BatterySensor6, BatterySensor7,
                                                BatterySensor8, BatterySensor9, BatterySensor10]
        return sensors.compactMap{ $0 }
    }
    
    var BatteryAirQuality: AmbientWeatherSensor? {
        guard let batteryAQS else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Air Quality Battery Status", sensorID: "batt_25", measurement: batteryAQS, unit: "None", desc: "PM2.5 Air Quality Sensor Battery Status")
    }
    
    var BatterySensor: AmbientWeatherSensor? {
        guard let batteryOut else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Outdoor Battery Status", sensorID: "battout", measurement: batteryOut, unit: "None", desc: "Outdoor Battery Status")
    }
    
    var BatterySensor1: AmbientWeatherSensor? {
        guard let batteryOut1 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 1", sensorID: "batt1", measurement: batteryOut1, unit: "None", desc: "Outdoor Battery Status - Sensor #1")
    }
    
    var BatterySensor2: AmbientWeatherSensor? {
        guard let batteryOut2 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 2", sensorID: "batt2", measurement: batteryOut2, unit: "None", desc: "Outdoor Battery Status - Sensor #2")
    }
    
    var BatterySensor3: AmbientWeatherSensor? {
        guard let batteryOut3 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 3", sensorID: "batt3", measurement: batteryOut3, unit: "None", desc: "Outdoor Battery Status - Sensor #3")
    }
    
    var BatterySensor4: AmbientWeatherSensor? {
        guard let batteryOut4 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 4", sensorID: "batt4", measurement: batteryOut4, unit: "None", desc: "Outdoor Battery Status - Sensor #4")
    }
    
    var BatterySensor5: AmbientWeatherSensor? {
        guard let batteryOut5 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 5", sensorID: "batt5", measurement: batteryOut5, unit: "None", desc: "Outdoor Battery Status - Sensor #5")
    }
    
    var BatterySensor6: AmbientWeatherSensor? {
        guard let batteryOut6 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 6", sensorID: "batt6", measurement: batteryOut6, unit: "None", desc: "Outdoor Battery Status - Sensor #6")
    }
    
    var BatterySensor7: AmbientWeatherSensor? {
        guard let batteryOut7 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 7", sensorID: "batt7", measurement: batteryOut7, unit: "None", desc: "Outdoor Battery Status - Sensor #7")
    }
    
    var BatterySensor8: AmbientWeatherSensor? {
        guard let batteryOut8 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 8", sensorID: "batt8", measurement: batteryOut8, unit: "None", desc: "Outdoor Battery Status - Sensor #8")
    }
    
    
    var BatterySensor9: AmbientWeatherSensor? {
        guard let batteryOut9 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 9", sensorID: "batt9", measurement: batteryOut9, unit: "None", desc: "Outdoor Battery Status - Sensor #9")
    }
    
    var BatterySensor10: AmbientWeatherSensor? {
        guard let batteryOut10 else { return nil }

        return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 10", sensorID: "batt10", measurement: batteryOut10, unit: "None", desc: "Outdoor Battery Status - Sensor #10")
    }
}
