//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherStationData {
    var TemperatureSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [TemperatureInside, TemperatureOutdoor, TemperatureOutdoorSensor1, TemperatureOutdoorSensor2, TemperatureOutdoorSensor3,
                                                TemperatureOutdoorSensor4, TemperatureOutdoorSensor5, TemperatureOutdoorSensor6, TemperatureOutdoorSensor7, TemperatureOutdoorSensor8,
                                                TemperatureOutdoorSensor9, TemperatureOutdoorSensor10, TemperatureSoilSensor1, TemperatureSoilSensor2, TemperatureSoilSensor3,
                                                TemperatureSoilSensor4, TemperatureSoilSensor5, TemperatureSoilSensor6, TemperatureSoilSensor7, TemperatureSoilSensor8, TemperatureSoilSensor9,
                                                TemperatureSoilSensor10, DewPointOutdoor, DewPointIndoor, TempFeelsLikeOutdoor, TempFeelsLikeIndoor, TempFeelsLikeOutdoorSensor1,
                                                TempFeelsLikeOutdoorSensor2, TempFeelsLikeOutdoorSensor3, TempFeelsLikeOutdoorSensor4, TempFeelsLikeOutdoorSensor5, TempFeelsLikeOutdoorSensor6,
                                                TempFeelsLikeOutdoorSensor7, TempFeelsLikeOutdoorSensor8, TempFeelsLikeOutdoorSensor9, TempFeelsLikeOutdoorSensor10, DewPointOutdoorSensor1,
                                                DewPointOutdoorSensor2, DewPointOutdoorSensor3, DewPointOutdoorSensor4, DewPointOutdoorSensor5, DewPointOutdoorSensor6, DewPointOutdoorSensor7,
                                                DewPointOutdoorSensor8, DewPointOutdoorSensor9, DewPointOutdoorSensor10]
        return sensors.compactMap{ $0 }
    }
    
    var TemperatureInside: AmbientWeatherSensor? {
        guard let tempInF else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "tempinf", name: "Indoor Temperature", description: "Indoor Temperature", measurement: tempInF, unit: "ºF")
    }
    
    var TemperatureOutdoor: AmbientWeatherSensor? {
        guard let tempOutF else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "tempOutF", name: "Outdoor Temperature", description: "Outdoor Temperature", measurement: tempOutF, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor1: AmbientWeatherSensor? {
        guard let tempOut1F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp1f", name: "Outdoor Temperature: 1", description: "Outdoor Temperature Sensor #1", measurement: tempOut1F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor2: AmbientWeatherSensor? {
        guard let tempOut2F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp2f", name: "Outdoor Temperature: 2", description: "Outdoor Temperature Sensor #2", measurement: tempOut2F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor3: AmbientWeatherSensor? {
        guard let tempOut3F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp3f", name: "Outdoor Temperature: 3", description: "Outdoor Temperature Sensor #3", measurement: tempOut3F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor4: AmbientWeatherSensor? {
        guard let tempOut4F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "tem41f", name: "Outdoor Temperature: 4", description: "Outdoor Temperature Sensor #4", measurement: tempOut4F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor5: AmbientWeatherSensor? {
        guard let tempOut5F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp5f", name: "Outdoor Temperature: 5", description: "Outdoor Temperature Sensor #5", measurement: tempOut5F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor6: AmbientWeatherSensor? {
        guard let tempOut6F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp6f", name: "Outdoor Temperature: 6", description: "Outdoor Temperature Sensor #6", measurement: tempOut6F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor7: AmbientWeatherSensor? {
        guard let tempOut7F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp7f", name: "Outdoor Temperature: 7", description: "Outdoor Temperature Sensor #7", measurement: tempOut7F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor8: AmbientWeatherSensor? {
        guard let tempOut8F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp8f", name: "Outdoor Temperature: 8", description: "Outdoor Temperature Sensor #8", measurement: tempOut8F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor9: AmbientWeatherSensor? {
        guard let tempOut9F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp9f", name: "Outdoor Temperature: 9", description: "Outdoor Temperature Sensor #9", measurement: tempOut9F, unit: "ºF")
    }
    
    var TemperatureOutdoorSensor10: AmbientWeatherSensor? {
        guard let tempOut10F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "temp10f", name: "Outdoor Temperature: 10", description: "Outdoor Temperature Sensor #10", measurement: tempOut10F, unit: "ºF")
    }
    
    var TemperatureSoilSensor1: AmbientWeatherSensor? {
        guard let soilTempOut1F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp1f", name: "Soil Temperature: 1", description: "Soil Temperature Sensor #1", measurement: soilTempOut1F, unit: "ºF")
    }
    
    var TemperatureSoilSensor2: AmbientWeatherSensor? {
        guard let soilTempOut2F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp2f", name: "Soil Temperature: 2", description: "Soil Temperature Sensor #2", measurement: soilTempOut2F, unit: "ºF")
    }
    
    var TemperatureSoilSensor3: AmbientWeatherSensor? {
        guard let soilTempOut3F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp3f", name: "Soil Temperature: 3", description: "Soil Temperature Sensor #3", measurement: soilTempOut3F, unit: "ºF")
    }
    
    var TemperatureSoilSensor4: AmbientWeatherSensor? {
        guard let soilTempOut4F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp4f", name: "Soil Temperature: 4", description: "Soil Temperature Sensor #4", measurement: soilTempOut4F, unit: "ºF")
    }
    
    var TemperatureSoilSensor5: AmbientWeatherSensor? {
        guard let soilTempOut5F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp5f", name: "Soil Temperature: 5", description: "Soil Temperature Sensor #5", measurement: soilTempOut5F, unit: "ºF")
    }
    
    var TemperatureSoilSensor6: AmbientWeatherSensor? {
        guard let soilTempOut6F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp6f", name: "Soil Temperature: 6", description: "Soil Temperature Sensor #6", measurement: soilTempOut6F, unit: "ºF")
    }
    
    var TemperatureSoilSensor7: AmbientWeatherSensor? {
        guard let soilTempOut7F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp7f", name: "Soil Temperature: 7", description: "Soil Temperature Sensor #7", measurement: soilTempOut7F, unit: "ºF")
    }
    
    var TemperatureSoilSensor8: AmbientWeatherSensor? {
        guard let soilTempOut8F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp8f", name: "Soil Temperature: 8", description: "Soil Temperature Sensor #8", measurement: soilTempOut8F, unit: "ºF")
    }
    
    var TemperatureSoilSensor9: AmbientWeatherSensor? {
        guard let soilTempOut9F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp9f", name: "Soil Temperature: 9", description: "Soil Temperature Sensor #9", measurement: soilTempOut9F, unit: "ºF")
    }
    
    var TemperatureSoilSensor10: AmbientWeatherSensor? {
        guard let soilTempOut10F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "soiltemp10f", name: "Soil Temperature: 10", description: "Soil Temperature Sensor #10", measurement: soilTempOut10F, unit: "ºF")
    }
    
    var DewPointOutdoor: AmbientWeatherSensor? {
        guard let dewPointOut else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint", name: "Outdoor Dew Point", description: "Outdoor Dew Point", measurement: dewPointOut, unit: "ºF")
    }
    
    var DewPointIndoor: AmbientWeatherSensor? {
        get {
            guard let dewPointIn else { return nil }

            return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPointin", name: "Indoor Dew Point", description: "Indoor Dew Point", measurement: dewPointIn, unit: "ºF")
        }
    }
    
    var TempFeelsLikeOutdoor: AmbientWeatherSensor? {
        guard let tempFeelsLikeOutF else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "feelsLike", name: "Outdoor Temperature Feels Like", description: "If < 50ºF => Wind Chill, if > 68ºF => Heat Index", measurement: tempFeelsLikeOutF, unit: "ºF")
    }
    
    var TempFeelsLikeIndoor: AmbientWeatherSensor? {
        guard let tempFeelsLikeInF else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "feelsLikein", name: "Indoor Temperature Feels Like", description: "Indoor Feels Like", measurement: tempFeelsLikeInF, unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor1: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut1 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike1",
                                    name: "Outdoor Temperature Feels Like: 1",
                                    description: "Sensor 1: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut1,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor2: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut2 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike2",
                                    name: "Outdoor Temperature Feels Like: 2",
                                    description: "Sensor 2: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut2,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor3: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut3 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike3",
                                    name: "Outdoor Temperature Feels Like: 3",
                                    description: "Sensor 3: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut3,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor4: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut4 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike4",
                                    name: "Outdoor Temperature Feels Like: 4",
                                    description: "Sensor 4: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut4,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor5: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut5 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike5",
                                    name: "Outdoor Temperature Feels Like: 5",
                                    description: "Sensor 5: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut5,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor6: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut6 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike6",
                                    name: "Outdoor Temperature Feels Like: 6",
                                    description: "Sensor 6: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut6,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor7: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut7 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike7",
                                    name: "Outdoor Temperature Feels Like: 7",
                                    description: "Sensor 7: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut7,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor8: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut8 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike8",
                                    name: "Outdoor Temperature Feels Like: 8",
                                    description: "Sensor 8: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut8,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor9: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut9 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike9",
                                    name: "Outdoor Temperature Feels Like: 9",
                                    description: "Sensor 9: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut9,
                                    unit: "ºF")
    }
    
    var TempFeelsLikeOutdoorSensor10: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut10 else { return nil }

        return AmbientWeatherSensor(type: .Temperature,
                                    sensorID: "feelsLike10",
                                    name: "Outdoor Temperature Feels Like: 10",
                                    description: "Sensor 10: If < 50ºF => Wind Chill, if > 68ºF => Heat Index",
                                    measurement: tempFeelsLikeOut10,
                                    unit: "ºF")
    }
    
    var DewPointOutdoorSensor1: AmbientWeatherSensor? {
        guard let dewPoint1 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint1", name: "Dew Point: 1", description: "Sensor 1: Dew Point", measurement: dewPoint1, unit: "ºF")
    }
    
    var DewPointOutdoorSensor2: AmbientWeatherSensor? {
        guard let dewPoint2 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint2", name: "Dew Point: 2", description: "Sensor 2: Dew Point", measurement: dewPoint2, unit: "ºF")
    }
    
    var DewPointOutdoorSensor3: AmbientWeatherSensor? {
        guard let dewPoint3 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint3", name: "Dew Point: 3", description: "Sensor 3: Dew Point", measurement: dewPoint3, unit: "ºF")
    }
    
    
    var DewPointOutdoorSensor4: AmbientWeatherSensor? {
        guard let dewPoint4 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint4", name: "Dew Point: 4", description: "Sensor 4: Dew Point", measurement: dewPoint4, unit: "ºF")
    }
    
    var DewPointOutdoorSensor5: AmbientWeatherSensor? {
        guard let dewPoint5 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint5", name: "Dew Point: 5", description: "Sensor 5: Dew Point", measurement: dewPoint5, unit: "ºF")
    }
    
    var DewPointOutdoorSensor6: AmbientWeatherSensor? {
        guard let dewPoint6 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint6", name: "Dew Point: 6", description: "Sensor 6: Dew Point", measurement: dewPoint6, unit: "ºF")
    }
    
    var DewPointOutdoorSensor7: AmbientWeatherSensor? {
        guard let dewPoint7 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint7", name: "Dew Point: 7", description: "Sensor 7: Dew Point", measurement: dewPoint7, unit: "ºF")
    }
    
    var DewPointOutdoorSensor8: AmbientWeatherSensor? {
        guard let dewPoint8 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint8", name: "Dew Point: 8", description: "Sensor 8: Dew Point", measurement: dewPoint8, unit: "ºF")
    }
    
    var DewPointOutdoorSensor9: AmbientWeatherSensor? {
        guard let dewPoint9 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint9", name: "Dew Point: 9", description: "Sensor 9: Dew Point", measurement: dewPoint9, unit: "ºF")
    }
    
    var DewPointOutdoorSensor10: AmbientWeatherSensor? {
        guard let dewPoint10 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, sensorID: "dewPoint10", name: "Dew Point: 10", description: "Sensor 10: Dew Point", measurement: dewPoint10, unit: "ºF")
    }
}
