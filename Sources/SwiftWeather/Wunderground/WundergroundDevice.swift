//  Created by Wade Tregaskis on 26/8/2022.

import CoreLocation
import Foundation


open class WundergroundDevice: WeatherDevice {
    public let platform: Wunderground

    public let ID: WeatherDeviceID

    public let _name: String

    public var name: String? {
        _name
    }

    public var locationSummary: String? {
        nil
    }

    public let location: CLLocation?

    public var address: String? {
        nil
    }

    public enum QualityControlStatus: Int, CustomStringConvertible, Codable {
        case notChecked = -1
        case bad = 0
        case good = 1

        public var description: String {
            switch self {
            case .notChecked:
                return "Not checked"
            case .bad:
                return "Bad"
            case .good:
                return "Good"
            }
        }
    }

    public let qualityControlStatus: QualityControlStatus?

    internal init(platform: Wunderground, ID: String, name: String, latitude: Double?, longitude: Double?, qualityControlStatus: Int?) throws {
        self.platform = platform

        self.ID = ID
        self._name = name

        if let latitude, let longitude {
            self.location = CLLocation(latitude: latitude, longitude: longitude)
        } else {
            self.location = nil
        }

        if let qualityControlStatus {
            self.qualityControlStatus = QualityControlStatus(rawValue: qualityControlStatus)
        } else {
            self.qualityControlStatus = nil
        }
    }

    public var latestReport: WeatherReport {
        get async throws {
            // API docs: https://docs.google.com/document/d/1KGb8bTVYRsNgljnNH67AMhckY8AQT2FVwZ9urj8SWBs

            let endpoint = try platform.currentConditionsEndpoint(station: ID)
            let (data, response) = try await platform.session.data(from: endpoint)

            if let httpResponse = response as? HTTPURLResponse {
                guard 200 == httpResponse.statusCode || 204 == httpResponse.statusCode else {
                    print("Wunderground API \(endpoint) responded with HTTP status \(httpResponse.statusCode).\nHeaders:\n\(httpResponse)\nBody:\n\(data.asString(encoding: .utf8) ?? data.asHexString())")
                    throw WundergroundError.from(response: httpResponse, endpoint: endpoint, body: data)
                }

                guard 204 == httpResponse.statusCode || !data.isEmpty else {
                    throw WundergroundError.missingAPIResponse(endpoint: endpoint, response: httpResponse)
                }
            }

            print(data.asString(encoding: .utf8) ?? data.asHexString())

            guard !data.isEmpty else {
                throw WeatherError.noReportsAvailable
            }

            let decoder = JSONDecoder()

            struct WundergroundCurrentObservations: Decodable {
                let observations: [WundergroundCurrentReport]
            }

            let observations: WundergroundCurrentObservations

            do {
                observations = try decoder.decode(type(of: observations), from: data)
            } catch {
                throw WundergroundError.invalidAPIResponse(rawResponse: data, decodingError: error)
            }

            guard let report = observations.observations.first else {
                throw WeatherError.noReportsAvailable
            }

            return report
        }
    }

    public func latestReports(count: Int) -> AsyncThrowingStream<WeatherReport, Error> {
        AsyncThrowingStream {
            throw WeatherError.notSupportedByPlatform
        }
    }

    public func reports(count: Int, upToAndIncluding: Date) -> AsyncThrowingStream<WeatherReport, Error> {
        AsyncThrowingStream {
            throw WeatherError.notSupportedByPlatform
        }
    }
}

extension WundergroundDevice: CustomStringConvertible {
    public var description: String {
        let locationDescription: String?

        if let location {
            locationDescription = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
        } else {
            locationDescription = nil
        }

        return """
               ID: \(ID)
               Name: \(name ?? "Unspecified")
               Location: \(locationDescription ?? "Unspecified")
               Quality control status: \(qualityControlStatus?.description ?? "Unknown")
               """
    }
}
