// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "SwiftWeather",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftWeather",
            targets: ["SwiftWeather"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/AsyncSwift/AsyncLocationKit.git", from: "1.0.5")
    ],
    targets: [
        .target(
            name: "SwiftWeather",
            dependencies: [/* "AsyncLocationKit" */]),
        .testTarget(
            name: "SwiftWeatherTests",
            dependencies: ["SwiftWeather"]),
    ]
)
