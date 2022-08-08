# SwiftWeather

![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/wadetregaskis/SwiftWeather.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/wadetregaskis/SwiftWeather.svg)
![GitHub All Releases](https://img.shields.io/github/downloads/wadetregaskis/SwiftWeather/total.svg)
![Swift](https://img.shields.io/badge/%20in-swift%205.1-orange.svg)

A Swift weather package to support multiple weather APIs.

# Supported APIs

| Weather API |  Documentation | Supported Format | API Support | Notes
| :----:  | :----- | :---- | :----: | :---- |
| [Ambient Weather](https://github.com/ambient-weather/api-docs) | * [API Docs](https://ambientweather.docs.apiary.io/)<br>* [API Wiki](https://github.com/ambient-weather/api-docs/wiki)<br>* [Device Specifications](https://github.com/ambient-weather/api-docs/wiki/Device-Data-Specs) | - [x] JSON<br> - [ ] Real Time | - [x] All Paramaters | Supports error conditions and<br>rate limits as defined in the API

# Installation

## Swift Package Manager

Add the following package to your Package.swift file. Swift 4 & 5 are supported for macOS 10.12, iOS 12 and tvOS 12.

``` Swift
.package(url: "https://github.com/wadetregaskis/SwiftWeather", .branch("master")),
```

# Getting Started

SwiftWeather uses a factory pattern to create individual weather services.  To initialize the service, all you you need to do is specify a weather service type and pass it the required API key(s).  Some APIs require a single key; some require multiple keys.  For now, the only supported service is AmbientWeather.net.  AmbientWeather requires two keys.  To initialze the service, you need call only one function.  For example:

```swift
guard let service = SwiftWeather.shared().getService(weatherServiceType: .Ambient,
                                                     apiKeys: ["*** YOUR API Key ***",
                                                               "*** YOUR Application Key***"]) else { return }
```

Once you have successfully initialized the service, it needs to be setup for one of two possible use cases.

## Use Case #1: Latest Data Reported

Retrieve the last good data reported by the weather station.  For example:

```swift
service.setupService(completionHandler: { stationStatus in
    switch stationStatus {
    case .NotReporting:
        print("According to the weather service, you do not have any devices reporting data")
        break
    case .Reporting:
        sleep(1) // <-- DO NOT DO THIS!!  This is for the test stub ONLY: It just prevents the API from throwing us out w/ back-to-back calls within 1 second (e.g, rate exceeded)
        for (_, device) in service.reportingDevices {
            switch device {
            case is AmbientWeatherDevice:
                print(device)

                service.getLastMeasurement(uniqueID: device.deviceID, completionHandler: { stationData in
                    guard let data = stationData else { return }
                    print(data)
                })
            default:
                print("Unknown device type detected")
                break
            }
        }
    case .Error:
        print("There was an error retrieving weather information from the weather service")
        break
    }
})
```

For this use case we focus on *getLastMeasurement*:

```swift
service.getLastMeasurement(uniqueID: device.deviceID, completionHandler: { stationData in
    guard let data = stationData else { return }
    print(data)
})
```

The code snippet above produces the following output for a weather station connected to AmbientWeather.net.  Each sensor can be interrogated for its intrinsic JSON value.

```
MAC Address: A1:B2:C3:D4:E5:F6
  Info:
      Name: My Station
      Location: My Roof
      GeoLocation:
		Location: Somewhere
		Address: Some Address
		Elevation: Some Elevation
	  Coordiates:
 		Type: Point
 		Latitude: YOUR LATITUDE
 		Longitude: YOUR LONGITUDE

Outdoor Battery Status: 0
Date: 1590605700000 ms
Relative Pressure: 29.62 inHg
Absolute Pressure: 29.58 inHg
Hourly Rain: 0.0 in/hr
Rain Today: 0.0 in
Monthly Rain: 1.54 in
Yearly Rain: 13.85 in
Last Time it Rained: 2020-05-23T08:32:00.000Z
Indoor Temperature: 90.7 ºF
Outdoor Temperature: 77.2 ºF
Outdoor Dew Point: 63.61 ºF
Outdoor Temperature Feels Like: 77.58 ºF
Wind Direction: 116 º
Wind Speed: 6.5 MPH
Wind Gust: 15.0 MPH
Max Wind Gust Today: 17.4 MPH
Wind Gust Direction: 190 º
2 Minute Wind Speed Avg: 5.2 MPH
10 Minute Wind Speed Avg: 5.2 MPH
10 Minute Wind Direction Avg: 133 º
UV Index: 5
Solar Radiation: 358.0 W/m^2
Outdoor Humidity: 63 %
Indoor Humidity: 30 %
```

## Use Case #2: Retrieve "n" Historical Measurements

The second use case is to retrieve  historical data.  By changing *count* in the function below, you can retrieve mulitple historical measurements for the desired station.  For example:

```swift
service.setupService(completionHandler: { stationStatus in
    switch stationStatus {
    case .NotReporting:
        print("According to the selected service, you do not have any devices reporting weather data")
        break
    case .Reporting:
        sleep(1) // <-- Test Sub: Just to prevent the API from throwing us out w/ back-to-back calls
        for (_, device) in service.reportingDevices {
            switch device {
            case is AmbientWeatherDevice:
                print(device)
                service.getHistoricalMeasurements(uniqueID: device.deviceID, count: 288, completionHandler: { stationData in
                    guard let historcalData = stationData else { return }
                     print("Successfully returned:\(historcalData.count) Measurements from AmbientWeather")
               })
            default:
                print("Unknown device type detected")
                break
            }
        }
    case .Error:
        print("There was an error retrieving weather information from the selected service")
        break
    }
})
```

For this use case we focus on *getHistoricalMeasurements*:

```swift
service.getHistoricalMeasurements(uniqueID: device.deviceID, count: 288, completionHandler: { stationData in
    guard let historcalData = stationData else { return }
    print("Successfully returned\(historcalData.count) Measurements")
})
```

The code snippet above produces the following output for a weather station connected to AmbientWeather.net.  As above, each sensor can be interrogated for its intrinsic JSON value.

```
MAC Address: A1:B2:C3:D4:E5:F6
  Info:
      Name: My Station
      Location: My Roof
      GeoLocation:
		Location: Somewhere
		Address: Some Address
		Elevation: Some Elevation
	  Coordiates:
 		Type: Point
 		Latitude: YOUR LATITUDE
 		Longitude: YOUR LONGITUDE

Successfully returned 288 Measurements
```

## Access to Device (station) Data

Each weather service consists of a Device:

```swift
public protocol WeatherDevice {
    var deviceID: String? { get }
}
```

…that contains data:

```swift
public protocol WeatherDeviceData {
    var sensors: [WeatherSensor] { get }
}
```

…where WeatherSensor is defined as:

```swift
/// Supported Service Types
public enum WeatherSensorType {
    case WindDirection
    case Temperature
    case AirQuality
    case WindSpeed
    case Radiation
    case RainRate
    case Humidity
    case RainDate
    case Pressure
    case Battery
    case General
    case Rain
}

/// 
/// Base sensor descriptor for SwiftWeather
/// Generic descriptors:
/// - _description: What the sensor does
/// - _sensorID: Uniqe Identifier of of the sensor
/// - _unit: What the measurements are in (e.g., in, W, F, etc.)
/// - _name: What do you want to call the sensor
/// - _value: Current measurement for the sensor
///
open class WeatherSensor {
    internal var _type: WeatherSensorType
    internal var _description: String
    internal var _sensorID: String
    internal var _unit: String
    internal var _name: String
    internal var _value: Any

    .
    .
    .
}
```

Once you have successfully called either *getLastMeasurement* or *getHistoricalMeasurements* you will have access to every piece of data that the station is reporting back to the API service.  Have a look in the package for details on exposed Properties to use in your application.

## To Do

- [ ] Add realtime Ambient Weather API support
- [ ] Add support for another weather API - suggestions are welcome
- [ ] Extensive testing for multiple reporting devices per service
- [ ] Localization

## Copyright & License Information

Released under the [MIT License](https://github.com/wadetregaskis/SwiftWeather/blob/master/LICENSE).

Originally created by [Mike Manzo](https://github.com/MikeManzo).  Other contributors include [Steven Bedrick](https://github.com/stevenbedrick) and [Wade Tregaskis](https://github.com/wadetregaskis).
