//  Created by Wade Tregaskis on 26/8/2022.

public import Foundation

public final class UnitIncidentPower: Unit, @unchecked Sendable {
    internal static let wattsPerSquareMetre = UnitIncidentPower(symbol: "W/㎡")
}

public final class UnitPercentage: Unit, @unchecked Sendable {
    internal static let percentage = UnitPercentage(symbol: "%")
}

public final class UnitUVIndex: Unit, @unchecked Sendable {
    internal static let uv = UnitUVIndex(symbol: "UV Index")
}

public final class NoUnit: Unit, @unchecked Sendable {
    internal static let none = NoUnit(symbol: "")
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
