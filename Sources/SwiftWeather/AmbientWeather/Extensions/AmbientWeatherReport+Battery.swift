//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherReport {
    var BatterySensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [BatterySensor, BatterySensor1, BatterySensor2, BatterySensor3,
                                                BatterySensor4, BatterySensor5, BatterySensor6, BatterySensor7,
                                                BatterySensor8, BatterySensor9, BatterySensor10]
        return sensors.compactMap{ $0 }
    }
    
    var BatteryAirQuality: AmbientWeatherSensor? {
        guard let batteryAQS else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt_25", name: "Air Quality Battery Status", description: "PM2.5 Air Quality Sensor Battery Status", measurement: batteryAQS, unit: "None")
    }
    
    var BatterySensor: AmbientWeatherSensor? {
        guard let batteryOut else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "battout", name: "Outdoor Battery Status", description: "Outdoor Battery Status", measurement: batteryOut, unit: "None")
    }
    
    var BatterySensor1: AmbientWeatherSensor? {
        guard let batteryOut1 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt1", name: "Battery Status: 1", description: "Outdoor Battery Status - Sensor #1", measurement: batteryOut1, unit: "None")
    }
    
    var BatterySensor2: AmbientWeatherSensor? {
        guard let batteryOut2 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt2", name: "Battery Status: 2", description: "Outdoor Battery Status - Sensor #2", measurement: batteryOut2, unit: "None")
    }
    
    var BatterySensor3: AmbientWeatherSensor? {
        guard let batteryOut3 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt3", name: "Battery Status: 3", description: "Outdoor Battery Status - Sensor #3", measurement: batteryOut3, unit: "None")
    }
    
    var BatterySensor4: AmbientWeatherSensor? {
        guard let batteryOut4 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt4", name: "Battery Status: 4", description: "Outdoor Battery Status - Sensor #4", measurement: batteryOut4, unit: "None")
    }
    
    var BatterySensor5: AmbientWeatherSensor? {
        guard let batteryOut5 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt5", name: "Battery Status: 5", description: "Outdoor Battery Status - Sensor #5", measurement: batteryOut5, unit: "None")
    }
    
    var BatterySensor6: AmbientWeatherSensor? {
        guard let batteryOut6 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt6", name: "Battery Status: 6", description: "Outdoor Battery Status - Sensor #6", measurement: batteryOut6, unit: "None")
    }
    
    var BatterySensor7: AmbientWeatherSensor? {
        guard let batteryOut7 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt7", name: "Battery Status: 7", description: "Outdoor Battery Status - Sensor #7", measurement: batteryOut7, unit: "None")
    }
    
    var BatterySensor8: AmbientWeatherSensor? {
        guard let batteryOut8 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt8", name: "Battery Status: 8", description: "Outdoor Battery Status - Sensor #8", measurement: batteryOut8, unit: "None")
    }
    
    
    var BatterySensor9: AmbientWeatherSensor? {
        guard let batteryOut9 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt9", name: "Battery Status: 9", description: "Outdoor Battery Status - Sensor #9", measurement: batteryOut9, unit: "None")
    }
    
    var BatterySensor10: AmbientWeatherSensor? {
        guard let batteryOut10 else { return nil }

        return AmbientWeatherSensor(type: .Battery, sensorID: "batt10", name: "Battery Status: 10", description: "Outdoor Battery Status - Sensor #10", measurement: batteryOut10, unit: "None")
    }
}
