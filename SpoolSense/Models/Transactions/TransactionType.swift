//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import SwiftUI

enum TransactionType: String, Codable {
    case refill = "Refill"
    case manual = "Manual Adjustment"
    case printManual = "Manual Print"
    case printApi = "API Print"
    case initial = "Initial Adjustment"
    case sync = "Re-Sync"
    
    var icon: Image {
        switch self {
        case .refill:
            return Image(systemName: "gauge.high")
        case .manual:
            return Image(systemName: "wrench.adjustable.fill")
        case .printManual:
            return Image(systemName: "printer.dotmatrix.fill")
        case .printApi:
            return Image(systemName: "curlybraces")
        case .initial:
            return Image(systemName: "ruler")
        case .sync:
            return Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
        }
    }
}
