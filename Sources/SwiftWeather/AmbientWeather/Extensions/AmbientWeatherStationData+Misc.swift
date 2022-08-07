//
//  StationData+Misc.swift
//  
//
//  Created by Mike Manzo on 5/11/20.
//

import Foundation

extension AmbientWeatherStationData {
    var MiscSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [DateUTC, Timezone]
        return sensors.compactMap{ $0 }
    }
    
    var DateUTC: AmbientWeatherSensor? {
        guard let dateUTC else { return nil }

        return AmbientWeatherSensor(type: .General,
                                    name: "Date",
                                    sensorID: "dateutc",
                                    measurement: Date(timeIntervalSince1970: Double(dateUTC) / 1000),
                                    unit: "None",
                                    desc: "Date & time at which the set of measurements were reported")
    }
    
    var Timezone: AmbientWeatherSensor? {
        guard let timeZone else { return nil }

        return AmbientWeatherSensor(type: .General, name: "Time Zone", sensorID: "tz", measurement: timeZone, unit: "None", desc: "IANA Time Zone")
    }
}
