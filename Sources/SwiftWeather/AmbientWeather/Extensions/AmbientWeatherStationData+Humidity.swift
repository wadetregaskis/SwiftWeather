//
//  File.swift
//  
//
//  Created by Mike Manzo on 5/11/20.
//

import Foundation

extension AmbientWeatherStationData {
    var HumiditySensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [HumidityOutdoor, HumidityIndoor, HumidityOutdoorSensor1, HumidityOutdoorSensor2,
                                                HumidityOutdoorSensor3, HumidityOutdoorSensor4, HumidityOutdoorSensor5, HumidityOutdoorSensor6,
                                                HumidityOutdoorSensor7, HumidityOutdoorSensor8, HumidityOutdoorSensor9, HumidityOutdoorSensor10,
                                                HumiditySoilSensor1, HumiditySoilSensor2, HumiditySoilSensor3, HumiditySoilSensor4,
                                                HumiditySoilSensor5, HumiditySoilSensor6, HumiditySoilSensor7, HumiditySoilSensor8,
                                                HumiditySoilSensor9, HumiditySoilSensor10]
        return sensors.compactMap{ $0 }
    }
    
    var HumidityOutdoor: AmbientWeatherSensor? {
        if humidityOut != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity", sensorID: "humidity", measurement: humidityOut!, unit: "%", desc: "Outdoor Humidity, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityIndoor: AmbientWeatherSensor? {
        if humidityIn != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Indoor Humidity", sensorID: "humidityin", measurement: humidityIn!, unit: "%", desc: "Indoor Humidity, 0-100%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor1: AmbientWeatherSensor? {
        if humidityOut1 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 1", sensorID: "humidity1", measurement: humidityOut1!, unit: "%", desc: "Outdoor Humidity Sensor #1, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor2: AmbientWeatherSensor? {
        if humidityOut2 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 2", sensorID: "humidity2", measurement: humidityOut2!, unit: "%", desc: "Outdoor Humidity Sensor #2, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor3: AmbientWeatherSensor? {
        if humidityOut3 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 3", sensorID: "humidity3", measurement: humidityOut3!, unit: "%", desc: "Outdoor Humidity Sensor #3, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor4: AmbientWeatherSensor? {
        if humidityOut4 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 4", sensorID: "humidity4", measurement: humidityOut4!, unit: "%", desc: "Outdoor Humidity Sensor #4, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor5: AmbientWeatherSensor? {
        if humidityOut5 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 5", sensorID: "humidity5", measurement: humidityOut5!, unit: "%", desc: "Outdoor Humidity Sensor #5, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor6: AmbientWeatherSensor? {
        if humidityOut6 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 6", sensorID: "humidity6", measurement: humidityOut6!, unit: "%", desc: "Outdoor Humidity Sensor #6, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor7: AmbientWeatherSensor? {
        if humidityOut7 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 7", sensorID: "humidity7", measurement: humidityOut7!, unit: "%", desc: "Outdoor Humidity Sensor #7, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor8: AmbientWeatherSensor? {
        if humidityOut8 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 8", sensorID: "humidity8", measurement: humidityOut8!, unit: "%", desc: "Outdoor Humidity Sensor #8, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor9: AmbientWeatherSensor? {
        if humidityOut9 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 9", sensorID: "humidity9", measurement: humidityOut9!, unit: "%", desc: "Outdoor Humidity Sensor #9, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumidityOutdoorSensor10: AmbientWeatherSensor? {
        if humidityOut10 != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 10", sensorID: "humidity10", measurement: humidityOut10!, unit: "%", desc: "Outdoor Humidity Sensor #10, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor1: AmbientWeatherSensor? {
        if soilHumOut1F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 1", sensorID: "soilhum1", measurement: soilHumOut1F!, unit: "%", desc: "Soil Humidity Sensor #1, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor2: AmbientWeatherSensor? {
        if soilHumOut2F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 2", sensorID: "soilhum2", measurement: soilHumOut2F!, unit: "%", desc: "Soil Humidity Sensor #2, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor3: AmbientWeatherSensor? {
        if soilHumOut3F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 3", sensorID: "soilhum3", measurement: soilHumOut3F!, unit: "%", desc: "Soil Humidity Sensor #3, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor4: AmbientWeatherSensor? {
        if soilHumOut4F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 4", sensorID: "soilhum4", measurement: soilHumOut4F!, unit: "%", desc: "Soil Humidity Sensor #4, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor5: AmbientWeatherSensor? {
        if soilHumOut5F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 5", sensorID: "soilhum5", measurement: soilHumOut5F!, unit: "%", desc: "Soil Humidity Sensor #5, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor6: AmbientWeatherSensor? {
        if soilHumOut6F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 6", sensorID: "soilhum6", measurement: soilHumOut6F!, unit: "%", desc: "Soil Humidity Sensor #6, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor7: AmbientWeatherSensor? {
        if soilHumOut7F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 7", sensorID: "soilhum7", measurement: soilHumOut7F!, unit: "%", desc: "Soil Humidity Sensor #7, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor8: AmbientWeatherSensor? {
        if soilHumOut8F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 8", sensorID: "soilhum8", measurement: soilHumOut8F!, unit: "%", desc: "Soil Humidity Sensor #8, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor9: AmbientWeatherSensor? {
        if soilHumOut9F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 9", sensorID: "soilhum9", measurement: soilHumOut9F!, unit: "%", desc: "Soil Humidity Sensor #9, 0-l00%")
        } else {
            return nil
        }
    }
    
    var HumiditySoilSensor10: AmbientWeatherSensor? {
        if soilHumOut10F != nil {
            return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 10", sensorID: "soilhum10", measurement: soilHumOut10F!, unit: "%", desc: "Soil Humidity Sensor #10, 0-l00%")
        } else {
            return nil
        }
    }
}
