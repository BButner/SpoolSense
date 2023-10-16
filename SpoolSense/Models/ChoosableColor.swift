//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import SwiftUI

enum ChoosableColor: String, Codable, Hashable {
    case black = "Black"
    case blue = "Blue"
    case brown = "Brown"
    case cyan = "Cyan"
    case green = "Green"
    case indigo = "Indigo"
    case mint = "Mint"
    case orange = "Orange"
    case pink = "Pink"
    case purple = "Purple"
    case red = "Red"
    case teal = "Teal"
    case yellow = "Yellow"
}

extension ChoosableColor {
    func uiColor() -> Color {
        switch self {
        case .black:
            return .primary
        case .blue:
            return Color(.systemBlue)
        case .brown:
            return Color(.systemBrown)
        case .cyan:
            return Color(.systemCyan)
        case .green:
            return Color(.systemGreen)
        case .indigo:
            return Color(.systemIndigo)
        case .mint:
            return Color(.systemMint)
        case .orange:
            return Color(.systemOrange)
        case .pink:
            return Color(.systemPink)
        case .purple:
            return Color(.systemPurple)
        case .red:
            return Color(.systemRed)
        case .teal:
            return Color(.systemTeal)
        case .yellow:
            return Color(.systemYellow)
        }
    }
}
