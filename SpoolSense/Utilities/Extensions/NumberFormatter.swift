//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation

struct NumberFormatterConstants {
    static func emptyZeroFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .none
        formatter.zeroSymbol = ""
        
        return formatter
    }
}
