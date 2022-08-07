//  Created by Mike Manzo on 5/11/20.

import Foundation

extension AmbientWeatherStationData {
    var RainSensors: [AmbientWeatherSensor] {
        let sensors: [AmbientWeatherSensor?] = [RainRatePerHour, RainDaily, Rain24Hrs, RainWeekly,
                                                RainMonthly, RainYearly, RainEvent, RainTotal,
                                                RainDateLast]
        return sensors.compactMap{ $0 }
    }
    
    var RainRatePerHour: AmbientWeatherSensor? {
        guard let rainHourIn else { return nil }

        return AmbientWeatherSensor(type: .RainRate, name: "Hourly Rain", sensorID: "hourlyrainin", measurement: rainHourIn, unit: "in/hr", desc: "Hourly Rain Rate")
    }
    
    var RainDaily: AmbientWeatherSensor? {
        guard let rainDailyIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, name: "Rain Today", sensorID: "dailyrainin", measurement: rainDailyIn, unit: "in", desc: "Daily Rain")
    }
    
    var Rain24Hrs: AmbientWeatherSensor? {
        guard let rain24HourIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, name: "24 Hour Rain", sensorID: "24hourrainin", measurement: rain24HourIn, unit: "in", desc: "Rain over last 24 Hours")
    }
    
    var RainWeekly: AmbientWeatherSensor? {
        guard let rainWeeklyIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, name: "Weekly Rain", sensorID: "weeklyrainin", measurement: rainWeeklyIn, unit: "in", desc: "Rain this week")
    }
    
    var RainMonthly: AmbientWeatherSensor? {
        guard let rainMonthlyIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, name: "Monthly Rain", sensorID: "monthlyrainin", measurement: rainMonthlyIn, unit: "in", desc: "Rain this month")
    }
    
    var RainYearly: AmbientWeatherSensor? {
        guard let rainYearlyIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, name: "Yearly Rain", sensorID: "yearlyrainin", measurement: rainYearlyIn, unit: "in", desc: "Rain this year")
    }
    
    var RainEvent: AmbientWeatherSensor? {
        guard let rainEventIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, name: "Event Rain", sensorID: "eventrainin", measurement: rainEventIn, unit: "in", desc: "Event Rain")
    }
    
    var RainTotal: AmbientWeatherSensor? {
        guard let rainTotalIn else { return nil }

        return AmbientWeatherSensor(type: .Rain, name: "Total Rain", sensorID: "totalrainin", measurement: rainTotalIn, unit: "in", desc: "Total rain since last factory reset")
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
