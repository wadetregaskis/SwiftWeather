//  Created by Mike Manzo on 5/11/20.

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

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity", name: "Outdoor Humidity", description: "Outdoor Humidity, 0-l00%", measurement: humidityOut, unit: "%")
    }
    
    var HumidityIndoor: AmbientWeatherSensor? {
        guard let humidityIn else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidityin", name: "Indoor Humidity", description: "Indoor Humidity, 0-100%", measurement: humidityIn, unit: "%")
    }
    
    var HumidityOutdoorSensor1: AmbientWeatherSensor? {
        guard let humidityOut1 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity1", name: "Outdoor Humidity: 1", description: "Outdoor Humidity Sensor #1, 0-l00%", measurement: humidityOut1, unit: "%")
    }
    
    var HumidityOutdoorSensor2: AmbientWeatherSensor? {
        guard let humidityOut2 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity2", name: "Outdoor Humidity: 2", description: "Outdoor Humidity Sensor #2, 0-l00%", measurement: humidityOut2, unit: "%")
    }
    
    var HumidityOutdoorSensor3: AmbientWeatherSensor? {
        guard let humidityOut3 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity3", name: "Outdoor Humidity: 3", description: "Outdoor Humidity Sensor #3, 0-l00%", measurement: humidityOut3, unit: "%")
    }
    
    var HumidityOutdoorSensor4: AmbientWeatherSensor? {
        guard let humidityOut4 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity4", name: "Outdoor Humidity: 4", description: "Outdoor Humidity Sensor #4, 0-l00%", measurement: humidityOut4, unit: "%")
    }
    
    var HumidityOutdoorSensor5: AmbientWeatherSensor? {
        guard let humidityOut5 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity5", name: "Outdoor Humidity: 5", description: "Outdoor Humidity Sensor #5, 0-l00%", measurement: humidityOut5, unit: "%")
    }
    
    var HumidityOutdoorSensor6: AmbientWeatherSensor? {
        guard let humidityOut6 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity6", name: "Outdoor Humidity: 6", description: "Outdoor Humidity Sensor #6, 0-l00%", measurement: humidityOut6, unit: "%")
    }
    
    var HumidityOutdoorSensor7: AmbientWeatherSensor? {
        guard let humidityOut7 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity7", name: "Outdoor Humidity: 7", description: "Outdoor Humidity Sensor #7, 0-l00%", measurement: humidityOut7, unit: "%")
    }
    
    var HumidityOutdoorSensor8: AmbientWeatherSensor? {
        guard let humidityOut8 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity8", name: "Outdoor Humidity: 8", description: "Outdoor Humidity Sensor #8, 0-l00%", measurement: humidityOut8, unit: "%")
    }
    
    var HumidityOutdoorSensor9: AmbientWeatherSensor? {
        guard let humidityOut9 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity9", name: "Outdoor Humidity: 9", description: "Outdoor Humidity Sensor #9, 0-l00%", measurement: humidityOut9, unit: "%")
    }
    
    var HumidityOutdoorSensor10: AmbientWeatherSensor? {
        guard let humidityOut10 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "humidity10", name: "Outdoor Humidity: 10", description: "Outdoor Humidity Sensor #10, 0-l00%", measurement: humidityOut10, unit: "%")
    }
    
    var HumiditySoilSensor1: AmbientWeatherSensor? {
        guard let soilHumOut1 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum1", name: "Soil Humidity: 1", description: "Soil Humidity Sensor #1, 0-l00%", measurement: soilHumOut1, unit: "%")
    }
    
    var HumiditySoilSensor2: AmbientWeatherSensor? {
        guard let soilHumOut2 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum2", name: "Soil Humidity: 2", description: "Soil Humidity Sensor #2, 0-l00%", measurement: soilHumOut2, unit: "%")
    }
    
    var HumiditySoilSensor3: AmbientWeatherSensor? {
        guard let soilHumOut3 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum3", name: "Soil Humidity: 3", description: "Soil Humidity Sensor #3, 0-l00%", measurement: soilHumOut3, unit: "%")
    }
    
    var HumiditySoilSensor4: AmbientWeatherSensor? {
        guard let soilHumOut4 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum4", name: "Soil Humidity: 4", description: "Soil Humidity Sensor #4, 0-l00%", measurement: soilHumOut4, unit: "%")
    }
    
    var HumiditySoilSensor5: AmbientWeatherSensor? {
        guard let soilHumOut5 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum5", name: "Soil Humidity: 5", description: "Soil Humidity Sensor #5, 0-l00%", measurement: soilHumOut5, unit: "%")
    }
    
    var HumiditySoilSensor6: AmbientWeatherSensor? {
        guard let soilHumOut6 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum6", name: "Soil Humidity: 6", description: "Soil Humidity Sensor #6, 0-l00%", measurement: soilHumOut6, unit: "%")
    }
    
    var HumiditySoilSensor7: AmbientWeatherSensor? {
        guard let soilHumOut7 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum7", name: "Soil Humidity: 7", description: "Soil Humidity Sensor #7, 0-l00%", measurement: soilHumOut7, unit: "%")
    }
    
    var HumiditySoilSensor8: AmbientWeatherSensor? {
        guard let soilHumOut8 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum8", name: "Soil Humidity: 8", description: "Soil Humidity Sensor #8, 0-l00%", measurement: soilHumOut8, unit: "%")
    }
    
    var HumiditySoilSensor9: AmbientWeatherSensor? {
        guard let soilHumOut9 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum9", name: "Soil Humidity: 9", description: "Soil Humidity Sensor #9, 0-l00%", measurement: soilHumOut9, unit: "%")
    }
    
    var HumiditySoilSensor10: AmbientWeatherSensor? {
        guard let soilHumOut10 else { return nil }

        return AmbientWeatherSensor(type: .Humidity, sensorID: "soilhum10", name: "Soil Humidity: 10", description: "Soil Humidity Sensor #10, 0-l00%", measurement: soilHumOut10, unit: "%")
    }
}
