# SwiftWeather

![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/wadetregaskis/SwiftWeather.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/wadetregaskis/SwiftWeather.svg)
![GitHub license](https://img.shields.io/github/license/wadetregaskis/SwiftWeather.svg)

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

SwiftWeather uses a factory pattern to create instances of specific weather platforms.  All you you need to do is specify a weather service type (and any relevant configuration parameters, such as API keys).  To initialze a platform instance, you call one function:

```swift
guard let platform = SwiftWeather.create(weatherPlatformType: .AmbientWeather(applicationKey: yourApplicationKey,
                                                                              apiKey: yourAPIKey)) else { return }
```

Once you have a platform instance, you can retrieve the list of available weather devices (stations):

```swift
let devices = try await platform.devices
```

Note that in real-world code you'll likely need to handle any exceptions that are thrown (e.g. the provided keys weren't valid).

`devices` is a map of device IDs to device instances.  You can persist weather device IDs (e.g. into user preferences) in order to recall the same device later (but be aware that device IDs are only unique per weather platform type - make sure to also record which platform the ID is associated with).

Once you've identified a device of interest, you can use it to retrieve weather reports in a variety of ways:

## Use Case #1: Retrieve the most recent report

```swift
let report = try await device.latestReport
```

## Use Case #2: Retrieve the N most recent reports

```swift
for try await report in device.latestReports(count: N) {
    …
}
```

Reports are returned in reverse chronological order (i.e. starting with the most recent).  The date interval between them is weather-platform-dependent and/or device-dependent, and also may be irregular if e.g. the weather device in question had internet connectivity issues.

## Use Case #3: Retrieve the report for a past date

```swift
for try await report in device.reports(count: 1, upToAndIncluding: date) {
    …
}
```

## Use Case #4: Retrieve N reports leading up to a given date

```swift
for try await report in device.reports(count: N, upToAndIncluding: date) {
    …
}
```

# Working with reports

Exactly what each report contains depends both on the weather platform and weather device in use.  An example from AmbientWeather:

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
 		Latitude: Some Latitutde
 		Longitude: Some Longitude

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

Each report contains at least a date & time of when it was generated, along with all available measures from that point in time.

```swift
public protocol WeatherReport {
    var date: Date { get }
    var sensors: [WeatherSensorID: WeatherSensor] { get }
}
```

…where WeatherSensor is defined as:

```swift
open class WeatherSensor {
    public let type: WeatherSensorType
    public let ID: WeatherSensorID
    public let name: String
    public let description: String?
    public let measurement: Any
}
```

Measurements vary in their type - Foundation's Measurement class is used wherever applicable, but some are more primitive types (e.g. Date for the last time it rained).

Have a look in the package - and experiment with this library against a real station of interest - for details on sensors available to use in your application.

## To Do

- Add real-time AmbientWeather API support (blocked by said API being broken - https://github.com/ambient-weather/api-docs/issues/42).
- Add support for another weather API - suggestions are welcome.
- Extensive testing for multiple reporting devices per service.
- Complete localization (some parts of the code are localisation-aware and -ready, some are not - in any case, no translations have been performed; English is the only supported language).

## Copyright & License Information

Released under the [MIT License](https://github.com/wadetregaskis/SwiftWeather/blob/master/LICENSE).

Originally created by [Mike Manzo](https://github.com/MikeManzo).  Other contributors include [Steven Bedrick](https://github.com/stevenbedrick) and [Wade Tregaskis](https://github.com/wadetregaskis).
