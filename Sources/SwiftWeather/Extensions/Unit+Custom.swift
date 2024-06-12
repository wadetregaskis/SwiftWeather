//  Created by Wade Tregaskis on 26/8/2022.

internal import Foundation

extension Unit {
    internal nonisolated(unsafe) static let none = Unit(symbol: "")

    internal nonisolated(unsafe) static let wattsPerSquareMetre = Unit(symbol: "W/㎡")
    internal nonisolated(unsafe) static let percentage = Unit(symbol: "%")
    internal nonisolated(unsafe) static let uv = Unit(symbol: "UV Index")
}

extension UnitConcentrationMass {
    internal static let microgramsPerCubicMetre = UnitConcentrationMass(
        symbol: "µg/㎥",
        converter: UnitConverterLinear(coefficient: 1e-9))
}

extension UnitSpeed {
    internal static let millimetresPerHour = UnitSpeed(
        symbol: "mm/h",
        converter: UnitConverterLinear(coefficient: (UnitLength.millimeters.converter.baseUnitValue(fromValue: 1)
                                                     / UnitDuration.hours.converter.baseUnitValue(fromValue: 1))))

    internal static let inchesPerHour = UnitSpeed(
        symbol: "in/h",
        converter: UnitConverterLinear(coefficient: (UnitLength.inches.converter.baseUnitValue(fromValue: 1)
                                                     / UnitDuration.hours.converter.baseUnitValue(fromValue: 1))))
}
