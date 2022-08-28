//  Created by Wade Tregaskis on 28/8/2022.

import Foundation

public enum WeatherError: Error {
    /// Indicates that the API (user) key is invalid, either outright (e.g. an empty string) or according to the weather platform's server (e.g. a revoked or banned key).
    case invalidAPIKey

    /// The weather platform in use does not support the requested functionality.  e.g. not all platforms support finding nearby devices, or directly listing devices owned by the user.
    case notSupportedByPlatform

    /// Location services are disabled (either specifically for this application, or system-wide), and therefore APIs that rely on the current location (e.g. ``WeatherPlatform.nearbyDevices``) cannot function.
    case locationServicesDisabled

    /// The current location is not available, and therefore APIs that rely on it (e.g. ``WeatherPlatform.nearbyDevices``) cannot function.
    case locationNotAvailable

    /// Thrown whenever two devices appear with the same device ID in the response from a weather platform's API.
    case conflictingDeviceIDs(WeatherDevice, WeatherDevice)

    /// Thrown whenever two sensors appear within the same report with the same ID in the response from a weather platform's API.
    case conflictingSensorIDs(WeatherSensor, WeatherSensor)

    /// A kind of internal inconsistency error - this indicates that a weather platform returned data in an unexpected type, but usually suggests a bug in the the client code (in this framework) regarding type coercion.
    case unsupportedSensorValueType(ID: String, value: Any)

    /// Thrown whenever a sensor, as reported by a weather platform / device, does not have the expected data type.  Note that this is not the only possible way for such type errors to manifest (there's also ``unsupportedSensorValueType(ID:value:)`` and possibly platform-specific error cases.
    case unexpectedSensorValueType(sensorID: WeatherSensorID, value: Any, expectedType: Any.Type)

    /// Thrown when a weather report, from a weather platform's API, does not include the date of the report.
    case missingReportDate(availableSensors: [WeatherSensorID])

    /// Thrown whenever a date, as reported by a weather platform's API, is not in the expected format or otherwise invalid (e.g. 30th of February).
    case invalidDate(string: String, expectedFormat: String)

    /// Thrown whenever there are no reports available from APIs which expect them, such as ``WeatherDevice.latestReport``, .  This is not usually an error in the strictest sense - it is valid for weather devices to exist but not have generated a report.
    case noReportsAvailable // TODO: Maybe remove this, and instead just return nil from such APIs.
}

extension WeatherError: LocalizedError {
    private static let localisedStringsTable = "WeatherErrors"

    public var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return NSLocalizedString(
                "invalidAPIKey",
                tableName: WeatherError.localisedStringsTable,
                value: "Invalid API (user) key.",
                comment: "When the API key is either obviously invalid (e.g. an empty string) or rejected by the AmbientWeather API.")

        case .notSupportedByPlatform:
            return NSLocalizedString(
                "notSupportedByPlatform",
                tableName: WeatherError.localisedStringsTable,
                value: "The weather platform in question does not support this operation.",
                comment: "A fairly generic error case for whenever the framework user tries to do something that the underlying weather platform does not support.")

        case .locationServicesDisabled:
            return NSLocalizedString(
                "locationServicesDisabled",
                tableName: WeatherError.localisedStringsTable,
                value: "Location information is not available (and therefore neither is functionality such as finding nearby weather devices) because location services are disabled for this application.",
                comment: "Indicates that location services are disabled for the application specifically (but enabled system-wide).  This error occurs only when the framework user has invoked some framework functionality that requires the user's location (e.g. searching for nearby weather devices).")

        case .locationNotAvailable:
            return NSLocalizedString(
                "locationNotAvailable",
                tableName: WeatherError.localisedStringsTable,
                value: "The current location is not available (and therefore neither is functionality such as finding nearby weather devices).",
                comment: "Indicates that location services, while enabled, did not return a current location when asked, for an unknown reason.  This error occurs only when the framework user has invoked some framework functionality that requires the user's location (e.g. searching for nearby weather devices).")

        case .conflictingDeviceIDs(let a, let b):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "conflictingDeviceIDs",
                    tableName: WeatherError.localisedStringsTable,
                    value: "The weather platform reported two devices with the same ID (%@):\n\n%@\n\n%@",
                    comment: "Two (or more) devices reported that have the same ID.  The ID in question is provided as the first String parameter, followed by descriptions of the two devices themselves (as Strings)."),
                a.ID,
                a.description,
                b.description)

        case .conflictingSensorIDs(let a, let b):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "conflictingSensorIDs",
                    tableName: WeatherError.localisedStringsTable,
                    value: "The weather platform reported two sensors with the same ID (%@) within a single report:\n\n%@\n\n%@",
                    comment: "Two (or more) sensors reported (within a single weather device) that have the same ID.  The ID in question is provided as the first String parameter, followed by descriptions of the two sensors themselves (as Strings)."),
                a.ID,
                String(describing: a),
                String(describing: b))

        case .unsupportedSensorValueType(ID: let ID, value: let value):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "unsupportedSensorValueType",
                    tableName: WeatherError.localisedStringsTable,
                    value: "Unsupported sensor value type %@ (%@) for sensor \"%@\".",
                    comment: "Essentially an internal inconsistency - the native value of the sensor, as reported in the response from a platform's API, is specified as having a known unit and therefore should be promoted to a formal Measurement yet is not of a type that has a known way to convert to a Double.  The type & value of the sensor are provided as parameters, as Strings, followed by the ID of the sensor itself."),
                String(describing: type(of: value)),
                String(describing: value),
                ID)

        case .unexpectedSensorValueType(sensorID: let sensorID, value: let value, expectedType: let expected):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "unexpectedSensorValueType",
                    tableName: WeatherError.localisedStringsTable,
                    value: "Expected the \"%@\" sensor to have a value of type %@, but it is a %@: %@",
                    comment: "A kind of internal inconsistency, where a helper function (or property) that utilises a specific sensor finds that the sensor's value is not of the expected type.  The types of all the sensors is determined internally, so this situation should in principle be impossible.  Four parameters are provided: sensor ID (String), expected value type (String), the unexpected type (String), and the unexpected value itself (String)."),
                sensorID,
                String(describing: expected),
                String(describing: type(of: value)),
                String(describing: value))

        case .missingReportDate(let sensorIDs):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "missingReportDate",
                    tableName: WeatherError.localisedStringsTable,
                    value: "Weather report does not contain a date specifying when the report was generated.  Included sensors: %@",
                    comment: "When the weather platform's API returns a set of sensors, constituting a weather report, that don't include the date & time at which the report was generated.  The list of sensors that *are* included in the report are included as a parameter - a String from preformatting the list of sensor IDs in localised fashion (as a standard-width \"and\" list)."),
                sensorIDs.sorted().formatted(.list(type: .and, width: .standard)))

        case .invalidDate(string: let dateString, expectedFormat: let format):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "invalidDate",
                    tableName: WeatherError.localisedStringsTable,
                    value: "The weather platform reported a date that is not in the expected format (%@): %@",
                    comment: "When a weather platform's API reports an incorrectly- (or at least unexpectedly-) formatted date.  The expected format is included as the first parameter, followed by the problematic input date (as provided by the API).  Both are strings."),
                format,
                dateString)

        case .noReportsAvailable:
            return NSLocalizedString(
                "noReportsAvailable",
                tableName: WeatherError.localisedStringsTable,
                value: "No weather reports available.",
                comment: "When no reports are available matching the specified criteria (if any, e.g. prior to a given date).")
        }
    }
}
