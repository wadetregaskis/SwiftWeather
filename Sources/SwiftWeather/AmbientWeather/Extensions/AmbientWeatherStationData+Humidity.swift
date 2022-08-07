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
        guard let humidityOut else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity", sensorID: "humidity", measurement: humidityOut, unit: "%", desc: "Outdoor Humidity, 0-l00%")
    }
    
    var HumidityIndoor: AmbientWeatherSensor? {
        guard let humidityIn else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Indoor Humidity", sensorID: "humidityin", measurement: humidityIn, unit: "%", desc: "Indoor Humidity, 0-100%")
    }
    
    var HumidityOutdoorSensor1: AmbientWeatherSensor? {
        guard let humidityOut1 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 1", sensorID: "humidity1", measurement: humidityOut1, unit: "%", desc: "Outdoor Humidity Sensor #1, 0-l00%")
    }
    
    var HumidityOutdoorSensor2: AmbientWeatherSensor? {
        guard let humidityOut2 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 2", sensorID: "humidity2", measurement: humidityOut2, unit: "%", desc: "Outdoor Humidity Sensor #2, 0-l00%")
    }
    
    var HumidityOutdoorSensor3: AmbientWeatherSensor? {
        guard let humidityOut3 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 3", sensorID: "humidity3", measurement: humidityOut3, unit: "%", desc: "Outdoor Humidity Sensor #3, 0-l00%")
    }
    
    var HumidityOutdoorSensor4: AmbientWeatherSensor? {
        guard let humidityOut4 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 4", sensorID: "humidity4", measurement: humidityOut4, unit: "%", desc: "Outdoor Humidity Sensor #4, 0-l00%")
    }
    
    var HumidityOutdoorSensor5: AmbientWeatherSensor? {
        guard let humidityOut5 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 5", sensorID: "humidity5", measurement: humidityOut5, unit: "%", desc: "Outdoor Humidity Sensor #5, 0-l00%")
    }
    
    var HumidityOutdoorSensor6: AmbientWeatherSensor? {
        guard let humidityOut6 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 6", sensorID: "humidity6", measurement: humidityOut6, unit: "%", desc: "Outdoor Humidity Sensor #6, 0-l00%")
    }
    
    var HumidityOutdoorSensor7: AmbientWeatherSensor? {
        guard let humidityOut7 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 7", sensorID: "humidity7", measurement: humidityOut7, unit: "%", desc: "Outdoor Humidity Sensor #7, 0-l00%")
    }
    
    var HumidityOutdoorSensor8: AmbientWeatherSensor? {
        guard let humidityOut8 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 8", sensorID: "humidity8", measurement: humidityOut8, unit: "%", desc: "Outdoor Humidity Sensor #8, 0-l00%")
    }
    
    var HumidityOutdoorSensor9: AmbientWeatherSensor? {
        guard let humidityOut9 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 9", sensorID: "humidity9", measurement: humidityOut9, unit: "%", desc: "Outdoor Humidity Sensor #9, 0-l00%")
    }
    
    var HumidityOutdoorSensor10: AmbientWeatherSensor? {
        guard let humidityOut10 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Outdoor Humidity: 10", sensorID: "humidity10", measurement: humidityOut10, unit: "%", desc: "Outdoor Humidity Sensor #10, 0-l00%")
    }
    
    var HumiditySoilSensor1: AmbientWeatherSensor? {
        guard let soilHumOut1F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 1", sensorID: "soilhum1", measurement: soilHumOut1F, unit: "%", desc: "Soil Humidity Sensor #1, 0-l00%")
    }
    
    var HumiditySoilSensor2: AmbientWeatherSensor? {
        guard let soilHumOut2F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 2", sensorID: "soilhum2", measurement: soilHumOut2F, unit: "%", desc: "Soil Humidity Sensor #2, 0-l00%")
    }
    
    var HumiditySoilSensor3: AmbientWeatherSensor? {
        guard let soilHumOut3F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 3", sensorID: "soilhum3", measurement: soilHumOut3F, unit: "%", desc: "Soil Humidity Sensor #3, 0-l00%")
    }
    
    var HumiditySoilSensor4: AmbientWeatherSensor? {
        guard let soilHumOut4F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 4", sensorID: "soilhum4", measurement: soilHumOut4F, unit: "%", desc: "Soil Humidity Sensor #4, 0-l00%")
    }
    
    var HumiditySoilSensor5: AmbientWeatherSensor? {
        guard let soilHumOut5F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 5", sensorID: "soilhum5", measurement: soilHumOut5F, unit: "%", desc: "Soil Humidity Sensor #5, 0-l00%")
    }
    
    var HumiditySoilSensor6: AmbientWeatherSensor? {
        guard let soilHumOut6F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 6", sensorID: "soilhum6", measurement: soilHumOut6F, unit: "%", desc: "Soil Humidity Sensor #6, 0-l00%")
    }
    
    var HumiditySoilSensor7: AmbientWeatherSensor? {
        guard let soilHumOut7F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 7", sensorID: "soilhum7", measurement: soilHumOut7F, unit: "%", desc: "Soil Humidity Sensor #7, 0-l00%")
    }
    
    var HumiditySoilSensor8: AmbientWeatherSensor? {
        guard let soilHumOut8F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 8", sensorID: "soilhum8", measurement: soilHumOut8F, unit: "%", desc: "Soil Humidity Sensor #8, 0-l00%")
    }
    
    var HumiditySoilSensor9: AmbientWeatherSensor? {
        guard let soilHumOut9F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 9", sensorID: "soilhum9", measurement: soilHumOut9F, unit: "%", desc: "Soil Humidity Sensor #9, 0-l00%")
    }
    
    var HumiditySoilSensor10: AmbientWeatherSensor? {
        guard let soilHumOut10F else { return nil }

        return AmbientWeatherSensor(type: .Humidity, name: "Soil Humidity: 10", sensorID: "soilhum10", measurement: soilHumOut10F, unit: "%", desc: "Soil Humidity Sensor #10, 0-l00%")
    }
}
