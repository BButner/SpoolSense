//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation

class FilamentApi: Codable, Identifiable {
    var id: UUID
    var name: String
    var diameter: Double = 1.75
    var abrasive: Bool = false
    var brand: String
    var color: ChoosableColor
    var material: Material
}
