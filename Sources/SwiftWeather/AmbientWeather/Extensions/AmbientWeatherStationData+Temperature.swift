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

        return AmbientWeatherSensor(type: .Temperature, name: "Indoor Temperature", sensorID: "tempinf", measurement: tempInF, unit: "ºF", desc: "Indoor Temperature")
    }
    
    var TemperatureOutdoor: AmbientWeatherSensor? {
        guard let tempOutF else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature", sensorID: "tempOutF", measurement: tempOutF, unit: "ºF", desc: "Outdoor Temperature")
    }
    
    var TemperatureOutdoorSensor1: AmbientWeatherSensor? {
        guard let tempOut1F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 1", sensorID: "temp1f", measurement: tempOut1F, unit: "ºF", desc: "Outdoor Temperature Sensor #1")
    }
    
    var TemperatureOutdoorSensor2: AmbientWeatherSensor? {
        guard let tempOut2F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 2", sensorID: "temp2f", measurement: tempOut2F, unit: "ºF", desc: "Outdoor Temperature Sensor #2")
    }
    
    var TemperatureOutdoorSensor3: AmbientWeatherSensor? {
        guard let tempOut3F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 3", sensorID: "temp3f", measurement: tempOut3F, unit: "ºF", desc: "Outdoor Temperature Sensor #3")
    }
    
    var TemperatureOutdoorSensor4: AmbientWeatherSensor? {
        guard let tempOut4F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 4", sensorID: "tem41f", measurement: tempOut4F, unit: "ºF", desc: "Outdoor Temperature Sensor #4")
    }
    
    var TemperatureOutdoorSensor5: AmbientWeatherSensor? {
        guard let tempOut5F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 5", sensorID: "temp5f", measurement: tempOut5F, unit: "ºF", desc: "Outdoor Temperature Sensor #5")
    }
    
    var TemperatureOutdoorSensor6: AmbientWeatherSensor? {
        guard let tempOut6F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 6", sensorID: "temp6f", measurement: tempOut6F, unit: "ºF", desc: "Outdoor Temperature Sensor #6")
    }
    
    var TemperatureOutdoorSensor7: AmbientWeatherSensor? {
        guard let tempOut7F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 7", sensorID: "temp7f", measurement: tempOut7F, unit: "ºF", desc: "Outdoor Temperature Sensor #7")
    }
    
    var TemperatureOutdoorSensor8: AmbientWeatherSensor? {
        guard let tempOut8F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 8", sensorID: "temp8f", measurement: tempOut8F, unit: "ºF", desc: "Outdoor Temperature Sensor #8")
    }
    
    var TemperatureOutdoorSensor9: AmbientWeatherSensor? {
        guard let tempOut9F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 9", sensorID: "temp9f", measurement: tempOut9F, unit: "ºF", desc: "Outdoor Temperature Sensor #9")
    }
    
    var TemperatureOutdoorSensor10: AmbientWeatherSensor? {
        guard let tempOut10F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature: 10", sensorID: "temp10f", measurement: tempOut10F, unit: "ºF", desc: "Outdoor Temperature Sensor #10")
    }
    
    var TemperatureSoilSensor1: AmbientWeatherSensor? {
        guard let soilTempOut1F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 1", sensorID: "soiltemp1f", measurement: soilTempOut1F, unit: "ºF", desc: "Soil Temperature Sensor #1")
    }
    
    var TemperatureSoilSensor2: AmbientWeatherSensor? {
        guard let soilTempOut2F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 2", sensorID: "soiltemp2f", measurement: soilTempOut2F, unit: "ºF", desc: "Soil Temperature Sensor #2")
    }
    
    var TemperatureSoilSensor3: AmbientWeatherSensor? {
        guard let soilTempOut3F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 3", sensorID: "soiltemp3f", measurement: soilTempOut3F, unit: "ºF", desc: "Soil Temperature Sensor #3")
    }
    
    var TemperatureSoilSensor4: AmbientWeatherSensor? {
        guard let soilTempOut4F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 4", sensorID: "soiltemp4f", measurement: soilTempOut4F, unit: "ºF", desc: "Soil Temperature Sensor #4")
    }
    
    var TemperatureSoilSensor5: AmbientWeatherSensor? {
        guard let soilTempOut5F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 5", sensorID: "soiltemp5f", measurement: soilTempOut5F, unit: "ºF", desc: "Soil Temperature Sensor #5")
    }
    
    var TemperatureSoilSensor6: AmbientWeatherSensor? {
        guard let soilTempOut6F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 6", sensorID: "soiltemp6f", measurement: soilTempOut6F, unit: "ºF", desc: "Soil Temperature Sensor #6")
    }
    
    var TemperatureSoilSensor7: AmbientWeatherSensor? {
        guard let soilTempOut7F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 7", sensorID: "soiltemp7f", measurement: soilTempOut7F, unit: "ºF", desc: "Soil Temperature Sensor #7")
    }
    
    var TemperatureSoilSensor8: AmbientWeatherSensor? {
        guard let soilTempOut8F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 8", sensorID: "soiltemp8f", measurement: soilTempOut8F, unit: "ºF", desc: "Soil Temperature Sensor #8")
    }
    
    var TemperatureSoilSensor9: AmbientWeatherSensor? {
        guard let soilTempOut9F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 9", sensorID: "soiltemp9f", measurement: soilTempOut9F, unit: "ºF", desc: "Soil Temperature Sensor #9")
    }
    
    var TemperatureSoilSensor10: AmbientWeatherSensor? {
        guard let soilTempOut10F else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Soil Temperature: 10", sensorID: "soiltemp10f", measurement: soilTempOut10F, unit: "ºF", desc: "Soil Temperature Sensor #10")
    }
    
    var DewPointOutdoor: AmbientWeatherSensor? {
        guard let dewPointOut else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Dew Point", sensorID: "dewPoint", measurement: dewPointOut, unit: "ºF", desc: "Outdoor Dew Point")
    }
    
    var DewPointIndoor: AmbientWeatherSensor? {
        get {
            guard let dewPointIn else { return nil }

            return AmbientWeatherSensor(type: .Temperature, name: "Indoor Dew Point", sensorID: "dewPointin", measurement: dewPointIn, unit: "ºF", desc: "Indoor Dew Point")
        }
    }
    
    var TempFeelsLikeOutdoor: AmbientWeatherSensor? {
        guard let tempFeelsLikeOutF else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like", sensorID: "feelsLike", measurement: tempFeelsLikeOutF, unit: "ºF", desc: "If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeIndoor: AmbientWeatherSensor? {
        guard let tempFeelsLikeInF else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Indoor Temperature Feels Like", sensorID: "feelsLikein", measurement: tempFeelsLikeInF, unit: "ºF", desc: "Indoor Feels Like")
    }
    
    var TempFeelsLikeOutdoorSensor1: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut1 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 1", sensorID: "feelsLike1", measurement: tempFeelsLikeOut1,
                                    unit: "ºF", desc: "Sensor 1: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor2: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut2 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 2", sensorID: "feelsLike2", measurement: tempFeelsLikeOut2,
                                    unit: "ºF", desc: "Sensor 2: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor3: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut3 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 3", sensorID: "feelsLike3", measurement: tempFeelsLikeOut3,
                                    unit: "ºF", desc: "Sensor 3: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor4: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut4 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 4", sensorID: "feelsLike4", measurement: tempFeelsLikeOut4,
                                    unit: "ºF", desc: "Sensor 4: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor5: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut5 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 5", sensorID: "feelsLike5", measurement: tempFeelsLikeOut5,
                                    unit: "ºF", desc: "Sensor 5: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor6: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut6 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 6", sensorID: "feelsLike6", measurement: tempFeelsLikeOut6,
                                    unit: "ºF", desc: "Sensor 6: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor7: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut7 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 7", sensorID: "feelsLike7", measurement: tempFeelsLikeOut7,
                                    unit: "ºF", desc: "Sensor 7: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor8: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut8 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 8", sensorID: "feelsLike8", measurement: tempFeelsLikeOut8,
                                    unit: "ºF", desc: "Sensor 8: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor9: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut9 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 9", sensorID: "feelsLike9", measurement: tempFeelsLikeOut9,
                                    unit: "ºF", desc: "Sensor 9: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var TempFeelsLikeOutdoorSensor10: AmbientWeatherSensor? {
        guard let tempFeelsLikeOut10 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Outdoor Temperature Feels Like: 10", sensorID: "feelsLike10", measurement: tempFeelsLikeOut10,
                                    unit: "ºF", desc: "Sensor 10: If < 50ºF => Wind Chill, if > 68ºF => Heat Index")
    }
    
    var DewPointOutdoorSensor1: AmbientWeatherSensor? {
        guard let dewPoint1 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 1", sensorID: "dewPoint1", measurement: dewPoint1, unit: "ºF", desc: "Sensor 1: Dew Point")
    }
    
    var DewPointOutdoorSensor2: AmbientWeatherSensor? {
        guard let dewPoint2 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 2", sensorID: "dewPoint2", measurement: dewPoint2, unit: "ºF", desc: "Sensor 2: Dew Point")
    }
    
    var DewPointOutdoorSensor3: AmbientWeatherSensor? {
        guard let dewPoint3 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 3", sensorID: "dewPoint3", measurement: dewPoint3, unit: "ºF", desc: "Sensor 3: Dew Point")
    }
    
    
    var DewPointOutdoorSensor4: AmbientWeatherSensor? {
        guard let dewPoint4 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 4", sensorID: "dewPoint4", measurement: dewPoint4, unit: "ºF", desc: "Sensor 4: Dew Point")
    }
    
    var DewPointOutdoorSensor5: AmbientWeatherSensor? {
        guard let dewPoint5 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 5", sensorID: "dewPoint5", measurement: dewPoint5, unit: "ºF", desc: "Sensor 5: Dew Point")
    }
    
    var DewPointOutdoorSensor6: AmbientWeatherSensor? {
        guard let dewPoint6 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 6", sensorID: "dewPoint6", measurement: dewPoint6, unit: "ºF", desc: "Sensor 6: Dew Point")
    }
    
    var DewPointOutdoorSensor7: AmbientWeatherSensor? {
        guard let dewPoint7 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 7", sensorID: "dewPoint7", measurement: dewPoint7, unit: "ºF", desc: "Sensor 7: Dew Point")
    }
    
    var DewPointOutdoorSensor8: AmbientWeatherSensor? {
        guard let dewPoint8 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 8", sensorID: "dewPoint8", measurement: dewPoint8, unit: "ºF", desc: "Sensor 8: Dew Point")
    }
    
    var DewPointOutdoorSensor9: AmbientWeatherSensor? {
        guard let dewPoint9 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 9", sensorID: "dewPoint9", measurement: dewPoint9, unit: "ºF", desc: "Sensor 9: Dew Point")
    }
    
    var DewPointOutdoorSensor10: AmbientWeatherSensor? {
        guard let dewPoint10 else { return nil }

        return AmbientWeatherSensor(type: .Temperature, name: "Dew Point: 10", sensorID: "dewPoint10", measurement: dewPoint10, unit: "ºF", desc: "Sensor 10: Dew Point")
    }
}
