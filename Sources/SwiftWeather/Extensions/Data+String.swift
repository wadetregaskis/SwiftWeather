//  Created by Wade Tregaskis on 6/8/2022.

internal import Foundation

internal extension Data {
    func asString(encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }

    func asHexString() -> String {
        String(unsafeUninitializedCapacity: self.count * 2) {
            let characters: [UInt8] = [48, 49, 50, 51, 52, 53, 54, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70]
            var i = 0

            for byte in self {
                $0[i] = characters[Int(byte / 16)]
                i += 1
                $0[i] = characters[Int(byte % 16)]
                i += 1
            }

            return i
        }
    }
}
