//  Created by Wade Tregaskis on 26/8/2022.

internal import Foundation


enum WundergroundError: Error {
    case locationManagerDidNotProvideALocation

    case invalidURL
    case invalidAPIResponse(rawResponse: Data, decodingError: any Error)
    case missingAPIResponse(endpoint: URL, response: HTTPURLResponse)
    case serverRejectedRequest(endpoint: URL, response: HTTPURLResponse, body: Data)
    case serverBroken(endpoint: URL, response: HTTPURLResponse, body: Data)

    static func from(response: HTTPURLResponse, endpoint: URL, body: Data) -> WundergroundError {
        switch response.statusCode {
        case 500..<600:
            return .serverBroken(endpoint: endpoint, response: response, body: body)
        default:
            return .serverRejectedRequest(endpoint: endpoint, response: response, body: body)
        }
    }
}

extension WundergroundError: LocalizedError {
    private static let localisedStringsTable = "WundergroundErrors"

    var errorDescription: String? {
        switch self {
        case .locationManagerDidNotProvideALocation:
            return NSLocalizedString(
                "locationManagerDidNotProvideALocation",
                tableName: WundergroundError.localisedStringsTable,
                value: "Unable to determine the user's current location, for an unknown reason.",
                comment: "A \"this should never happen\" kind of situation where CLLocationManager calls the 'success' callback but doesn't actually provide a location.")

        case .invalidURL:
            return NSLocalizedString(
                "invalidURL",
                tableName: WundergroundError.localisedStringsTable,
                value: "Invalid Wunderground endpoint URL.",
                comment: "In principle should never happen - indicates that the hard-coded URL(s) for working with the Wunderground API are invalid in some way, at least according to the URL or URLComponents classes.")

        case .invalidAPIResponse(rawResponse: let data, decodingError: let error):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "invalidAPIResponse",
                    tableName: WundergroundError.localisedStringsTable,
                    value: "Invalid (or at least unsupported) response from the Wunderground API: %@\n\nResponse body: %@",
                    comment: "When the response cannot be interpreted correctly because it explicitly does not match the expected structure & format.  An underlying Error is inclued as the first parameter (in localised String form), followed by the raw HTTP body of the response (in String form, though the exact format may vary - e.g. raw, a hex representation of the response bytes, etc)."),
                error.localizedDescription,
                data.asString(encoding: .utf8) ?? data.asHexString())

        case .missingAPIResponse(endpoint: let endpoint, response: let response):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "missingAPIResponse",
                    tableName: WundergroundError.localisedStringsTable,
                    value: "API response was empty even though no error was indicated.\n\nEndpoint: %@\n\nHTTP response:\n%@",
                    comment: "The Wunderground API returned a HTTP response that didn't explicitly indicate an error (e.g. it had a 200 status code) yet the response body was empty, in violation of their API spec.  It nominally should never happen, but web APIs aren't generally trustworthy and it's possible that a future API change is backwards-incompatible (e.g. they start using a different 2xx code that is not recognised by this framework).  Two arguments are provided, both strings: the endpoint (URL) of the API in question, and the HTTP response information (not including the body, since it's empty)."),
                endpoint.description,
                response.description)

        case .serverRejectedRequest(endpoint: let endpoint, response: let response, body: let data):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "serverRejectedRequest",
                    tableName: WundergroundError.localisedStringsTable,
                    value: "The Wunderground API rejected the request.\n\nEndpoint: %@\n\nHTTP response:\n%@\n\n%@",
                    comment: "When a non-200 and non-5xx response is returned by the Wunderground API (4xx errors are handled by \"weatherPlatformBroken\").  Three parameters are provided, all strings - the endpoint (URL) that was used, the HTTP response information, and the raw HTTP body of the response (the exact format may vary - e.g. raw, a hex representation of the response bytes, etc)."),
                endpoint.description,
                response.description,
                data.asString(encoding: .utf8) ?? data.asHexString())

        case .serverBroken(endpoint: let endpoint, response: let response, body: let data):
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "serverBroken",
                    tableName: WundergroundError.localisedStringsTable,
                    value: "The Wunderground API appears to be broken (probably only temporarily).\n\nEndpoint: %@\n\nHTTP response:\n%@\n\n%@",
                    comment: "When a 5xx response is returned by the Wunderground API (all other non-200 errors are handled by \"weatherPlatformRejectedRequest\").  Three parameters are provided, all strings - the endpoint (URL) that was used, the HTTP response information, and the raw HTTP body of the response (the exact format may vary - e.g. raw, a hex representation of the response bytes, etc)."),
                endpoint.description,
                response.description,
                data.asString(encoding: .utf8) ?? data.asHexString())
        }
    }
}
