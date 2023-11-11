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
        case .initial:
            return .gray // These aren't meant to be displayed
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
        case .initial:
            return Image(systemName: "ruler")
        }
    }
}
