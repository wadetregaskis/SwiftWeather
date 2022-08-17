//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherReport {
    var RainSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [RainRatePerHour, RainDaily, Rain24Hrs, RainWeekly,
                                                RainMonthly, RainYearly, RainEvent, RainTotal,
                                                RainDateLast]
        return sensors.compactMap{ $0 }
    }
    
    var RainRatePerHour: AmbientWeatherSensor? {
        guard let rainHourIn else { return nil }

        return AmbientWeatherSensor(type: .RainRate, sensorID: "hourlyrainin", name: "Hourly Rain", description: "Hourly Rain Rate", measurement: rainHourIn, unit: "in/hr")
    }
    
    var RainDaily: AmbientWeatherSensor? {
        guard let rainDailyIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, sensorID: "dailyrainin", name: "Rain Today", description: "Daily Rain", measurement: rainDailyIn, unit: "in")
    }
    
    var Rain24Hrs: AmbientWeatherSensor? {
        guard let rain24HourIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, sensorID: "24hourrainin", name: "24 Hour Rain", description: "Rain over last 24 Hours", measurement: rain24HourIn, unit: "in")
    }
    
    var RainWeekly: AmbientWeatherSensor? {
        guard let rainWeeklyIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, sensorID: "weeklyrainin", name: "Weekly Rain", description: "Rain this week", measurement: rainWeeklyIn, unit: "in")
    }
    
    var RainMonthly: AmbientWeatherSensor? {
        guard let rainMonthlyIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, sensorID: "monthlyrainin", name: "Monthly Rain", description: "Rain this month", measurement: rainMonthlyIn, unit: "in")
    }
    
    var RainYearly: AmbientWeatherSensor? {
        guard let rainYearlyIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, sensorID: "yearlyrainin", name: "Yearly Rain", description: "Rain this year", measurement: rainYearlyIn, unit: "in")
    }
    
    var RainEvent: AmbientWeatherSensor? {
        guard let rainEventIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, sensorID: "eventrainin", name: "Event Rain", description: "Event Rain", measurement: rainEventIn, unit: "in")
    }
    
    var RainTotal: AmbientWeatherSensor? {
        guard let rainTotalIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, sensorID: "totalrainin", name: "Total Rain", description: "Total rain since last factory reset", measurement: rainTotalIn, unit: "in")
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

        guard let date = AmbientWeatherReport.rainDateFormatter.date(from: rainLastDate) else {
            // TODO: logging or some other way of reporting the error.
            return nil
        }

        return AmbientWeatherSensor(type: .RainDate,
                                    sensorID: "lastRain",
                                    name: "Last Time it Rained",
                                    description: "Last time hourly rain > 0 inches",
                                    measurement: date,
                                    unit: "None")
    }
}
