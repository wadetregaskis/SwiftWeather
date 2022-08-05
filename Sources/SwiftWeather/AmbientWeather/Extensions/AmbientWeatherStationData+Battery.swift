//
//  StationData+Battery.swift
//  
//
//  Created by Mike Manzo on 5/11/20.
//

import Foundation

extension AmbientWeatherStationData {
    var BatterySensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [BatterySensor, BatterySensor1, BatterySensor2, BatterySensor3,
                                                BatterySensor4, BatterySensor5, BatterySensor6, BatterySensor7,
                                                BatterySensor8, BatterySensor9, BatterySensor10]
        return sensors.compactMap{ $0 }
    }
    
    var BatteryAirQuality: AmbientWeatherSensor? {
        if batteryAQS != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Air Quality Battery Status", sensorID: "batt_25", measurement: batteryAQS!, unit: "None", desc: "PM2.5 Air Quality Sensor Battery Status")
        } else {
            return nil
        }
    }
    
    var BatterySensor: AmbientWeatherSensor? {
        if batteryOut != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Outdoor Battery Status", sensorID: "battout", measurement: batteryOut!, unit: "None", desc: "Outdoor Battery Status")
        } else {
            return nil
        }
    }
    
    var BatterySensor1: AmbientWeatherSensor? {
        if batteryOut1 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 1", sensorID: "batt1", measurement: batteryOut1!, unit: "None", desc: "Outdoor Battery Status - Sensor #1")
        } else {
            return nil
        }
    }
    
    var BatterySensor2: AmbientWeatherSensor? {
        if batteryOut2 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 2", sensorID: "batt2", measurement: batteryOut2!, unit: "None", desc: "Outdoor Battery Status - Sensor #2")
        } else {
            return nil
        }
    }
    
    var BatterySensor3: AmbientWeatherSensor? {
        if batteryOut3 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 3", sensorID: "batt3", measurement: batteryOut3!, unit: "None", desc: "Outdoor Battery Status - Sensor #3")
        } else {
            return nil
        }
    }
    
    var BatterySensor4: AmbientWeatherSensor? {
        if batteryOut4 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 4", sensorID: "batt4", measurement: batteryOut4!, unit: "None", desc: "Outdoor Battery Status - Sensor #4")
        } else {
            return nil
        }
    }
    
    var BatterySensor5: AmbientWeatherSensor? {
        if batteryOut5 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 5", sensorID: "batt5", measurement: batteryOut5!, unit: "None", desc: "Outdoor Battery Status - Sensor #5")
        } else {
            return nil
        }
    }
    
    var BatterySensor6: AmbientWeatherSensor? {
        if batteryOut6 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 6", sensorID: "batt6", measurement: batteryOut6!, unit: "None", desc: "Outdoor Battery Status - Sensor #6")
        } else {
            return nil
        }
    }
    
    var BatterySensor7: AmbientWeatherSensor? {
        if batteryOut7 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 7", sensorID: "batt7", measurement: batteryOut7!, unit: "None", desc: "Outdoor Battery Status - Sensor #7")
        } else {
            return nil
        }
    }
    
    var BatterySensor8: AmbientWeatherSensor? {
        if batteryOut8 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 8", sensorID: "batt8", measurement: batteryOut8!, unit: "None", desc: "Outdoor Battery Status - Sensor #8")
        } else {
            return nil
        }
    }
    
    
    var BatterySensor9: AmbientWeatherSensor? {
        if batteryOut9 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 9", sensorID: "batt9", measurement: batteryOut9!, unit: "None", desc: "Outdoor Battery Status - Sensor #9")
        } else {
            return nil
        }
    }
    
    var BatterySensor10: AmbientWeatherSensor? {
        if batteryOut10 != nil {
            return AmbientWeatherSensor(type: .Battery, name: "Battery Status: 10", sensorID: "batt10", measurement: batteryOut10!, unit: "None", desc: "Outdoor Battery Status - Sensor #10")
        } else {
            return nil
        }
    }
}
