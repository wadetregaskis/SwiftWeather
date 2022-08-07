//  Created by Wade Tregaskis on 6/8/2022.

import Foundation


internal extension Data {
    func asString(encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }
}
