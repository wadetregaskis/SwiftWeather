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

Add the following package to your Package.swift file:

``` Swift
.package(url: "https://github.com/wadetregaskis/SwiftWeather", .branch("master")),
```

# Getting Started

SwiftWeather uses a factory pattern to create individual weather services.  To initialize the service, all you you need to do is specify a weather service type and pass it the required API key(s).  Some APIs require a single key; some require multiple keys.  For now, the only supported service is AmbientWeather.net.  AmbientWeather requires two keys.  To initialze the service, you need call only one function.  For example:

```swift
guard let platform = SwiftWeather.create(weatherServiceType: .AmbientWeather,
                                         apiKeys: ["*** YOUR API Key ***",
                                                   "*** YOUR Application Key***"]) else { return }
```

Once you have successfully initialized the service, it needs to be setup for one of two possible use cases.

## Use Case #1: Retrieve the most recent report

Retrieve the last good data reported by the weather station.  For example:

```swift
service.setupService { stationStatus in
    switch stationStatus {
    case .NotReporting:
        print("According to the weather service, you do not have any devices reporting data")
        break
    case .Reporting(let devices):
        for (ID, device) in devices {
            print(device)

            service.getLastMeasurement(device: ID) { report in
                guard let report else { return }
                print(report)
            }

            sleep(1) // <-- DO NOT DO THIS IN REAL CODE!!  This is for this example ONLY: It just prevents the API from throwing us out w/ back-to-back calls within 1 second (e.g, rate exceeded).
        }
    case .Error:
        print("There was an error retrieving weather information from the weather service")
        break
    }
}
```

For this use case we focus on *getLastMeasurement*:

```swift
service.getLastMeasurement(device: ID) { report in
    guard let report else { return }
    print(report)
}
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

## Use Case #2: Retrieve historical reports

The second use case is to retrieve historical data.  By using `getHistoricalMeasurements` instead, you can retrieve multiple recent measurements for the desired station.  For example:

```swift
service.getHistoricalMeasurements(device: ID, count: 288) { reports in
    guard let reports else { return }
    print("Successfully returned \(reports.count) reports from AmbientWeather.")
```

Currently this always returns the most recent `count` reports.

## Weather report contents

Each report contains at least a date & time of when it was generated, along with all available measures from that time.

```swift
public protocol WeatherReport {
    var date: Date { get }
    var sensors: [WeatherSensor] { get }
}
```

…where WeatherSensor is defined as:

```swift
open class WeatherSensor {
    public let type: WeatherSensorType
    public let sensorID: String
    public let name: String
    public let description: String
    public let measurement: Any
    public let unit: String
}
```

Measurements vary in their type - Foundation's Measurement class is used wherever applicable, but some are more primitive types (e.g. Date for the last time it rained).

Have a look in the package - and experiment with this library against a real station of interest - for details on sensors available to use in your application.

## To Do

- Support retrieval of weather reports for arbitrary times in the past.
- Add realtime Ambient Weather API support.
- Add support for another weather API - suggestions are welcome.
- Extensive testing for multiple reporting devices per service.
- Localization.

## Copyright & License Information

Released under the [MIT License](https://github.com/wadetregaskis/SwiftWeather/blob/master/LICENSE).

Originally created by [Mike Manzo](https://github.com/MikeManzo).  Other contributors include [Steven Bedrick](https://github.com/stevenbedrick) and [Wade Tregaskis](https://github.com/wadetregaskis).
