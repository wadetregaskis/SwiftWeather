// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftWeather",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftWeather",
            targets: ["SwiftWeather"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/AsyncSwift/AsyncLocationKit.git", from: "1.0.5")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftWeather",
            dependencies: [/* "AsyncLocationKit" */]),
        .testTarget(
            name: "SwiftWeatherTests",
            dependencies: ["SwiftWeather"]),
    ]
)
