//  Created by Mike Manzo on 5/17/20.

import CoreLocation
import Foundation

///
/// [Ambient Weather Device Specification](https://github.com/ambient-weather/api-docs/wiki/Device-Data-Specs)
///
open class AmbientWeatherDevice: WeatherDevice {
    private let _platform: AmbientWeather
    private let info: AmbientWeatherStationInfo?
    private let macAddress: WeatherDeviceID

    enum CodingKeys: String, CodingKey {
        case macAddress = "macAddress"
        case info = "info"
    }

    public var platform: WeatherPlatform {
        _platform
    }

    public var ID: WeatherDeviceID {
        macAddress
    }

    public var name: String? {
        information?.name
    }

    public var locationSummary: String? {
        information?.location
    }

    public var location: CLLocation? {
        information?.geolocation?.position
    }

    public var address: String? {
        information?.geolocation?.address
    }

    public var latestReport: WeatherReport {
        get async throws {
            for try await report in reports(count: 1) {
                return report
            }

            throw AmbientWeatherError.unknown
        }
    }

    public func latestReports(count: Int) -> AsyncThrowingStream<WeatherReport, Error> {
        reports(count: count)
    }

    public func reports(count: Int, upToAndIncluding: Date = .distantFuture) -> AsyncThrowingStream<WeatherReport, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    guard 0 < count else {
                        throw AmbientWeatherError.invalidReportCount(count)
                    }
                    
                    var countRemaining = count
                    var date = upToAndIncluding

                    while 0 < countRemaining && !Task.isCancelled {
                        let endpoint = try _platform.dataEndPoint(macAddress: ID,
                                                                  limit: min(countRemaining, 288),
                                                                  date: (date == .distantFuture) ? nil : date)
                        let (data, response) = try await URLSession.shared.data(from: endpoint)
                        let timeLastAPICallEnded = Date.now

                        if let httpResponse = response as? HTTPURLResponse {
                            guard 200 == httpResponse.statusCode else {
                                print("AmbientWeather API \(endpoint) responded with HTTP status \(httpResponse.statusCode).\nHeaders:\n\(httpResponse)\nBody:\n\(data.asString(encoding: .utf8) ?? data.debugDescription)")
                                throw AmbientWeatherError.from(apiResponse: data)
                            }
                        }

                        let reports: [AmbientWeatherReport]

                        do {
                            reports = try JSONDecoder().decode(type(of: reports), from: data)
                        } catch {
                            throw AmbientWeatherError.from(apiResponse: data, else: error)
                        }

                        for report in reports {
                            continuation.yield(report)

                            if Task.isCancelled {
                                return
                            }

                            date = report.date.advanced(by: -1)
                        }

                        countRemaining -= reports.count

                        if 0 < countRemaining {
                            while !Task.isCancelled {
                                let secondsOfCooldownLeft = timeLastAPICallEnded.advanced(by: 1).timeIntervalSinceNow

                                if 0 < secondsOfCooldownLeft {
                                    try? await Task.sleep(nanoseconds: UInt64(secondsOfCooldownLeft * 1e9))
                                } else {
                                    break
                                }
                            }
                        }
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    /// Return the station info.  Note, this returns all info the *user* has entered for the device
    public var information: AmbientWeatherStationInfo? {
        return info
    }

    required public init(from decoder: Decoder) throws {
        guard let platform = decoder.userInfo[AmbientWeather.platformCodingUserInfoKey] as? AmbientWeather else {
            throw AmbientWeatherError.platformMissingFromDecoderUserInfo
        }

        self._platform = platform

        let container = try decoder.container(keyedBy: CodingKeys.self)

        macAddress = try container.decodeIfPresent(String.self, forKey: .macAddress) ?? "XXX"
        //let latestData = try container.decode(AmbientWeatherReport.self, forKey: .lastData)
        info = try container.decode(AmbientWeatherStationInfo.self, forKey: .info)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(macAddress, forKey: .macAddress)
        try container.encode(info, forKey: .info)
    }
}

extension AmbientWeatherDevice: CustomStringConvertible {
    public var description: String {
        """
        ID (MAC Address): \(ID)
        \(info?.description ?? "INFO: Error")
        """
    }
}
