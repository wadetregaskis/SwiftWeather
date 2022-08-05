//
//  StationData+Rain.swift
//  
//
//  Created by Mike Manzo on 5/11/20.
//

import Foundation

extension AmbientWeatherStationData {
    var RainSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [RainRatePerHour, RainDaily, Rain24Hrs, RainWeekly,
                                                RainMonthly, RainYearly, RainEvent, RainTotal,
                                                RainDateLast]
        return sensors.compactMap{ $0 }
    }
    
    var RainRatePerHour: AmbientWeatherSensor? {
        if rainHourIn != nil {
            return AmbientWeatherSensor(type: .RainRate, name: "Hourly Rain", sensorID: "hourlyrainin", measurement: rainHourIn!, unit: "in/hr", desc: "Hourly Rain Rate")
        } else {
            return nil
        }
    }
    
    var RainDaily: AmbientWeatherSensor? {
        if rainDailyIn != nil {
            return AmbientWeatherSensor(type: .Rain, name: "Rain Today", sensorID: "dailyrainin", measurement: rainDailyIn!, unit: "in", desc: "Daily Rain")
        } else {
            return nil
        }
    }
    
    var Rain24Hrs: AmbientWeatherSensor? {
        if rain24HourIn != nil {
            return AmbientWeatherSensor(type: .RainDate, name: "24 Hour Rain", sensorID: "24hourrainin", measurement: rain24HourIn!, unit: "in", desc: "Rain over last 24 Hours")
        } else {
            return nil
        }
    }
    
    var RainWeekly: AmbientWeatherSensor? {
        if rainWeeklyIn != nil {
            return AmbientWeatherSensor(type: .Rain, name: "Weekly Rain", sensorID: "weeklyrainin", measurement: rainWeeklyIn!, unit: "in", desc: "Rain this week")
        } else {
            return nil
        }
    }
    
    var RainMonthly: AmbientWeatherSensor? {
        if rainMonthlyIn != nil {
            return AmbientWeatherSensor(type: .Rain, name: "Monthly Rain", sensorID: "monthlyrainin", measurement: rainMonthlyIn!, unit: "in", desc: "Rain this month")
        } else {
            return nil
        }
    }
    
    var RainYearly: AmbientWeatherSensor? {
        if rainYearlyIn != nil {
            return AmbientWeatherSensor(type: .Rain, name: "Yearly Rain", sensorID: "yearlyrainin", measurement: rainYearlyIn!, unit: "in", desc: "Rain this year")
        } else {
            return nil
        }
    }
    
    var RainEvent: AmbientWeatherSensor? {
        if rainEventIn != nil {
            return AmbientWeatherSensor(type: .Rain, name: "Event Rain", sensorID: "eventrainin", measurement: rainEventIn!, unit: "in", desc: "Event Rain")
        } else {
            return nil
        }
    }
    
    var RainTotal: AmbientWeatherSensor? {
        if rainTotalIn != nil {
            return AmbientWeatherSensor(type: .Rain, name: "Total Rain", sensorID: "totalrainin", measurement: rainTotalIn!, unit: "in", desc: "Total rain since last factory reset")
        } else {
            return nil
        }
    }

    internal static let rainDateFormatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    var RainDateLast: AmbientWeatherSensor? {
        guard let rainLastDate else {
            return nil
        }

        guard let date = AmbientWeatherStationData.rainDateFormatter.date(from: rainLastDate) else {
            // TODO: logging or some other way of reporting the error.
            return nil
        }

        return AmbientWeatherSensor(type: .RainDate,
                                    name: "Last Time it Rained",
                                    sensorID: "lastRain",
                                    measurement: date,
                                    unit: "None",
                                    desc: "Last time hourly rain > 0 inches")
    }
}
