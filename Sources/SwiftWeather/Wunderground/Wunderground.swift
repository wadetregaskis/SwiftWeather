//  Created by Wade Tregaskis on 23/8/2022.

//import AsyncLocationKit
import CoreLocation
import Foundation


public final class Wunderground: WeatherPlatform {
    private let apiHostname = "api.weather.com"
    private let apiV2 = "v2"
    private let apiV3 = "v3"

    private let apiKey: String

    internal let session: URLSession

    /// The default network connectivity configuration used by ``init``.
    ///
    /// This returns a new ``URLSessionConfiguration`` instance every time it is read, so you may customise the returned value without worrying about the changes affecting future values returned by this property.
    ///
    /// Some configuration options are particularly important for correct function.  Be conservative about what you change, and test thoroughly.
    ///
    /// These default settings are _not_ guaranteed to remain unchanged across versions of this framework.  If you need a specific setting for correct function of your application, make sure to set it explicitly.  e.g. if you have a preference on whether to wait for network connectivity, explicitly set `waitsForConnectivity` irrespective of the default value provided here.
    public static var defaultConfiguration: URLSessionConfiguration {
        let config = URLSessionConfiguration.ephemeral

        config.timeoutIntervalForResource = 120
        config.waitsForConnectivity = true

        config.httpCookieAcceptPolicy = .never
        config.httpShouldSetCookies = false

        config.httpShouldUsePipelining = true

        config.requestCachePolicy = .reloadRevalidatingCacheData

        // Weather data is quite small and compresses very well (with gzip transfer compression) so it's unlikely to be a concern regarding use over cellular or "expensive" connections.  Framework users can always override this if they wish (by providing a custom URLSessionConfiguration), to better match their app's needs.
        config.allowsCellularAccess = true
        config.allowsExpensiveNetworkAccess = true
        config.allowsConstrainedNetworkAccess = true

        // Unfortunately weather.com doesn't support TLS 1.3 at time of writing (2022-08-25).
        config.tlsMinimumSupportedProtocolVersion = .TLSv12

        return config
    }

    /// - Parameter apiKey: The API (user) key.  This is a key assigned to each of your users, that functions essentially as their access credientials.  Typically you do _not_ hard-code this into your application, but rather require your users to input it.  You may wish to direct your users to https://www.wunderground.com/member/api-keys to create / retrieve their API key.
    /// - Parameter sessionConfiguration: An optional configuration to use for network connectivity.  Generally if you wish to customise this you should start with ``defaultConfiguration`` and customise that, in order to inherit any settings which are important to correct function.
    /// - Throws: ``WeatherError.invalidAPIKey`` if the `apiKey` is obviously invalid (e.g. blank).
    public init(apiKey: String, sessionConfiguration: URLSessionConfiguration = defaultConfiguration) throws {
        guard !apiKey.isEmpty else {
            throw WeatherError.invalidAPIKey
        }

        self.apiKey = apiKey
        self.session = URLSession(configuration: sessionConfiguration.copy() as! URLSessionConfiguration)
    }

    private class LocationDelegate: NSObject, CLLocationManagerDelegate {
        let onLocation: (CLLocation) -> ()
        let onError: (Error) -> ()

        init(onLocation: @escaping (CLLocation) -> Void, onError: @escaping (Error) -> Void) {
            self.onLocation = onLocation
            self.onError = onError
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed: \(error)")
            self.onError(error)
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("Locations: \(locations)")

            guard let location = locations.last else {
                self.onError(WundergroundError.locationManagerDidNotProvideALocation)
                return
            }

            self.onLocation(location)
        }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            print("Authorisation status: \(status)")
        }

        func dealloc() {
            print("Oh no, I died!")
        }
    }

#if false // Core Location is incredibly buggy - to the point of not working at all, essentially - so I can't expose this API [yet?].
    /// Some nearby weather devices, based on the user's current location.
    ///
    /// This takes core of working with Core Location for the most part, but requires Location privileges for your application.  See https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services for details on what you must configure as the application author in order to enable Location Services.
    ///
    /// The exact number of devices return is undefined, and may be zero if there are no weather devices sufficiently close by.
    public var nearbyDevices: [WeatherDeviceID : WundergroundDevice] {
        get async throws {
            guard CLLocationManager.locationServicesEnabled() else {
                throw WeatherError.locationServicesDisabled
            }

            // This is baffling.  If you allocate the location manager on the main thread, it doesn't work (location is always nil).  You have to allocate it on a random _other_ thread and then it works - but _only_ from the main thread.  WTF.
//            let locationManager = CLLocationManager()
//
//            let location = try await MainActor.run {
//                let delegate = LocationDelegate { _ in } onError: { _ in }
//                locationManager.delegate = delegate
//
//                guard let loc = locationManager.location else {
//                    throw WeatherError.locationNotAvailable
//                }
//
//                return loc
//            }

            // Randomly hoping that the 'location' property is populated and up to date (as above) is a terrible idea - nothing in the API documentation makes even the slightest promise that it'll work.  Unfortunately doing _any_ of the supposed 'correct' ways to obtain the location does not work - the delegate is never, ever invoked.

            print("On main thread: \(Thread.isMainThread)")

            let locationManager = CLLocationManager()
            print("Location (from random thread): \(String(describing: locationManager.location))")

            // The delegate must be strongly referenced at least until CoreLocation calls back to it, since locationManager doesn't retain a strong reference to it.
            var delegate: LocationDelegate?

            let location = try await withCheckedThrowingContinuation { continuation in
                delegate = LocationDelegate {
                    continuation.resume(returning: $0)
                } onError: {
                    continuation.resume(throwing: $0)
                }

                locationManager.delegate = delegate

                DispatchQueue.main.sync {
                    print("Now on main thread (\(Thread.isMainThread)).")

                    print("Location (from main thread): \(String(describing: locationManager.location))")

                    locationManager.desiredAccuracy = kCLLocationAccuracyReduced

                    switch locationManager.authorizationStatus {
                    case .authorizedAlways:
                        print("Always allowed access to the current location (with accuracy \(locationManager.accuracyAuthorization)).")
                        break
                    case .notDetermined:
                        print("Warning: access to location services may not be authorised.")

                        locationManager.requestWhenInUseAuthorization()
                        //locationManager.requestAlwaysAuthorization()
                    default:
                        print("Unauthorised: \(locationManager.authorizationStatus)")
                        continuation.resume(throwing: WeatherError.locationServicesDisabled)
                    }

                    //locationManager.startUpdatingLocation()
                    //locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Because I wants it.")
                    locationManager.requestLocation()
                    print("Asked for location…")
                }

                print("Waiting for location…")
                continuation.resume(returning: locationManager.location!)
            }

            try await Task.sleep(nanoseconds: 5_000_000_000)
            print("Killing delegate…")
            delegate = nil

            // Even tried using AsyncLocationKit, but it fails in exactly the same way (CLLocationManager simply never ever invokes any delegate methods).
//            let location: CLLocation
//
//            switch try await AsyncLocationManager().requestLocation() {
//            case .didUpdateLocations(locations: let locations):
//                guard let latestLocation = locations.last else {
//                    throw WundergroundError.locationManagerDidNotProvideALocation
//                }
//
//                location = latestLocation
//            case .didFailWith(error: let error):
//                throw error
//            case .didPaused:
//                print("Wot?  Paused?!")
//                throw WundergroundError.locationManagerDidNotProvideALocation
//            case .didResume:
//                print("Wot?  Resumed?!")
//                throw WundergroundError.locationManagerDidNotProvideALocation
//            case .none:
//                print("Wot?  Nil?!")
//                throw WundergroundError.locationManagerDidNotProvideALocation
//            }

            return try await devices(near: location)
        }
    }
#endif

    private var baseURLComponents: URLComponents {
        var components = URLComponents()

        components.scheme = "https"
        components.host = apiHostname
        components.queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]

        return components
    }

    private func searchNearbyURL(location: CLLocation) throws -> URL {
        // e.g. https://api.weather.com/v3/location/near?geocode=33.74,-84.39&product=pws&format=json&apiKey=yourApiKey

        var components = baseURLComponents

        components.path.append("/\(apiV3)/location/near")

        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: "geocode", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"))
        queryItems.append(URLQueryItem(name: "product", value: "pws"))
        queryItems.append(URLQueryItem(name: "format", value: "json"))

        components.queryItems = queryItems

        guard let url = components.url else {
            throw WundergroundError.invalidURL
        }

        return url
    }

    private struct NearAPIResponse: Decodable {
        let location: NearAPIResponseLocation
    }

    private struct NearAPIResponseLocation: Decodable {
        let stationName: [String]
        let stationId: [String?]
        let latitude: [Double]
        let longitude: [Double]
        let qcStatus: [Int?]

        // These are also valid fields in the response, but we're not using them currently so there's no point decoding them.
        //let distanceKm: [Double?]
        //let distanceMi: [Double?]
        //let partnerId: [String?]
        //let updateTimeUtc: [Int?]
    }

    /// Finds weather devices near the given location.
    ///
    /// Precisely which devices are returned may vary between requests for the same location.
    ///
    /// If you just want nearby devices, use ``nearbyDevices``.
    ///
    /// - Parameter location: The location to search near.  If the given location represents an area (rather than a precise point) it is _not_ guaranteed that all stations within that area are returned.
    /// - Returns: Some devices near `location`.  The exact number of devices return is undefined, and might be zero if there are no devices sufficiently close to `location`.
    public func devices(near location: CLLocation) async throws -> [WeatherDeviceID : WundergroundDevice] {
        // API docs:  https://docs.google.com/document/d/14BKNJwPiU8T6UNFBzPn5NuNcAJjFcSWmMIc2TSqg51Q

        let endpoint = try searchNearbyURL(location: location)
        let (data, response) = try await session.data(from: endpoint)

        if let httpResponse = response as? HTTPURLResponse {
            guard 200 == httpResponse.statusCode || 204 == httpResponse.statusCode else {
                print("Wunderground API \(endpoint) responded with HTTP status \(httpResponse.statusCode).\nHeaders:\n\(httpResponse)\nBody:\n\(data.asString(encoding: .utf8) ?? data.asHexString())")
                throw WundergroundError.from(response: httpResponse, endpoint: endpoint, body: data)
            }

            guard 204 == httpResponse.statusCode || !data.isEmpty else {
                throw WundergroundError.missingAPIResponse(endpoint: endpoint, response: httpResponse)
            }
        }

        let decoder = JSONDecoder()
        let responseWrapper: NearAPIResponse

        do {
            responseWrapper = try decoder.decode(NearAPIResponse.self, from: data)
        } catch {
            throw WundergroundError.invalidAPIResponse(rawResponse: data, decodingError: error)
        }

        return try Dictionary(
            zip(responseWrapper.location.stationId,
                responseWrapper.location.stationName,
                responseWrapper.location.latitude,
                responseWrapper.location.longitude,
                responseWrapper.location.qcStatus)
            .compactMap {
                guard let ID = $0.0 else { return nil }
                return (ID, try WundergroundDevice(platform: self, ID: ID, name: $0.1, latitude: $0.2, longitude: $0.3, qualityControlStatus: $0.4))
            },
            uniquingKeysWith: { a, b in
                throw WeatherError.conflictingDeviceIDs(a, b)
            })
    }

    internal func currentConditionsEndpoint(station: WeatherDeviceID) throws -> URL {
        // https://api.weather.com/v2/pws/observations/current?stationId=KMAHANOV10&format=json&units=e&apiKey=yourApiKey

        var components = baseURLComponents

        components.path.append("/\(apiV2)/pws/observations/current")

        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: "stationId", value: station))
        queryItems.append(URLQueryItem(name: "format", value: "json"))
        queryItems.append(URLQueryItem(name: "units", value: "m"))
        queryItems.append(URLQueryItem(name: "numericPrecision", value: "decimal"))

        components.queryItems = queryItems

        guard let url = components.url else {
            throw WundergroundError.invalidURL
        }

        return url
    }
}
