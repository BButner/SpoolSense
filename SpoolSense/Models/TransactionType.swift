//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import SwiftUI

enum TransactionType: Int, Codable {
    case refill = 0
    case manual = 1
    case printManual = 2
    case printApi = 3
    
    var title: String {
        switch self {
        case .refill:
            return "Refill"
        case .manual:
            return "Manual Adjustment"
        case .printManual:
            return "Print"
        case .printApi:
            return "Print"
        }
    }
    
    var uiColor: Color {
        switch self {
        case .refill:
            return .purple
        case .manual:
            return .pink
        case .printManual:
            return .indigo
        case .printApi:
            return .indigo
        }
    }
    
    var icon: Image {
        switch self {
        case .refill:
            return Image(systemName: "arrow.clockwise")
        case .manual:
            return Image(systemName: "pencil")
        case .printManual:
            return Image(systemName: "printer.dotmatrix.fill")
        case .printApi:
            return Image(systemName: "curlybraces")
        }
    }
}
