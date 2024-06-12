// swift-tools-version: 5.10

import PackageDescription

let enables = ["AccessLevelOnImport",
               "BareSlashRegexLiterals",
               "ConciseMagicFile",
               "DeprecateApplicationMain",
               "DisableOutwardActorInference",
               "DynamicActorIsolation",
               "ExistentialAny",
               "ForwardTrailingClosures",
               //"FullTypedThrows", // Makes the Swift 6 compiler spin forever, consuming hundreds of gigabytes (or more) of RAM.  FB13871643.
               "GlobalConcurrency",
               "ImplicitOpenExistentials",
               "ImportObjcForwardDeclarations",
               "InferSendableFromCaptures",
               "InternalImportsByDefault",
               "IsolatedDefaultValues",
               "StrictConcurrency"]

let settings: [SwiftSetting] = enables.flatMap {
    [.enableUpcomingFeature($0), .enableExperimentalFeature($0)]
}

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
            dependencies: [/* "AsyncLocationKit" */],
            swiftSettings: settings)
    ]
)
