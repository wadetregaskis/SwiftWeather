//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherReport {
    var MiscSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [DateUTC, Timezone]
        return sensors.compactMap{ $0 }
    }
    
    var DateUTC: AmbientWeatherSensor? {
        guard let dateUTC else { return nil }

        return AmbientWeatherSensor(type: .General,
                                    sensorID: "dateutc",
                                    name: "Date",
                                    description: "Date & time at which the set of measurements were reported",
                                    measurement: Date(timeIntervalSince1970: Double(dateUTC) / 1000),
                                    unit: "None")
    }
    
    var Timezone: AmbientWeatherSensor? {
        guard let timeZone else { return nil }

        return AmbientWeatherSensor(type: .General, sensorID: "tz", name: "Time Zone", description: "IANA Time Zone", measurement: timeZone, unit: "None")
    }
}
