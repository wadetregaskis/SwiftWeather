//  Created by Mike Manzo on 5/17/20.

import CoreLocation
import Foundation
import SocketIO

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
        return macAddress
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

                        let reports: [AmbientWeatherStationData]

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

//    class Delegate: NSObject, URLSessionWebSocketDelegate {
//        func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol proto: String?) {
//            print("WebSocket connected (session: \(session), task: \(webSocketTask), protocol: \(proto ?? "nil").")
//        }
//
//        func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//            print("WebSocket disconnected (session: \(session), task: \(webSocketTask), closeCode: \(closeCode), reason: \(reason?.asString(encoding: .utf8) ?? "nil")).")
//        }
//
//        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//            print("Task completed (session: \(session), task: \(task), error: \(error)).")
//        }
//
//        func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
//            print("Session became invalid (session: \(session), error: \(error)).")
//        }
//    }

    public var liveReports: AsyncThrowingStream<WeatherReport, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let manager = SocketManager(socketURL: try _platform.liveDataEndPoint(),
                                                config: [.compress,
                                                         .forceNew(true),
                                                         .forceWebsockets(true),
                                                         .log(true),
                                                         .secure(true),
                                                         .version(.three)])

                    print("Socket.IO version: \(manager.version)")

                    let socket = manager.defaultSocket

                    socket.onAny { event in
                        print("Event: \(event)")
                    }

                    socket.on(clientEvent: .connect) { _, _ in
                        print("Connected.")

                        // Nope:
//                        socket.emit("connect")

                        // Nope:
//                        socket.emit("subscribe", "['ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044']".data(using: .utf8)!)

                        // Nope:
//                        socket.emit("subscribe", "['ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044']")

                        // Nope:
//                        socket.emit("subscribe", ["ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044"])

                        // Nope:
//                        socket.emit("subscribe", """
//                                { 'apiKeys': ['ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044'] }
//                                """)

                        // Nope:
//                        socket.emit("subscribe", """
//                                { apiKeys: ['ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044'] }
//                                """)

                        // Nope:
//                        socket.emit("subscribe", """
//                                { apiKeys: [ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044] }
//                                """)

                        // Nope:
//                        socket.emit("subscribe", """
//                                { apiKeys: ["ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044"] }
//                                """)

                        // Nope:
//                        socket.emit("subscribe", """
//                                { "apiKeys": ["ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044"] }
//                                """.data(using: .utf8)!)

                        // Nope:
//                        socket.emit("subscribe", """
//                                { "apiKeys": ["ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044"] }
//                                """)

                        // Nope:
                        socket.emit("subscribe", ["apiKeys": ["ea219d5359fa4a16894eb7f186b610429ef38445ff5f407c842649d233168044"]])
                    }

                    socket.on(clientEvent: .disconnect) { _, _ in
                        print("Disconnected.")
                    }

                    socket.on(clientEvent: .error) { error, _ in
                        print("Error: \(error)")
                    }

                    socket.on("subscribed") { data, _ in
                        print("Subscribed to: \(data)")
                    }

                    socket.on("data") { data, _ in
                        print("Data: \(data)")
                    }

                    socket.connect()

                    RunLoop.current.run()

                    try await Task.sleep(nanoseconds: 1_000_000_000_000)

                    print("Done.")

//                    let webSocket = URLSession.shared.webSocketTask(with: try _platform.liveDataEndPoint())
//                    webSocket.delegate = Delegate()
//
//                    webSocket.resume()
//
//                    try await webSocket.send(.string("connect"))
//
//                    let message = try await webSocket.receive()
//
//                    print(message)
//
//                    webSocket.cancel()

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
        //let latestData = try container.decode(AmbientWeatherStationData.self, forKey: .lastData)
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
