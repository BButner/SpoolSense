//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import SwiftUI

@Observable
final class Filament: Identifiable, Hashable {
    static func == (lhs: Filament, rhs: Filament) -> Bool {
        lhs.id == rhs.id
    }
    
    var identifier: String {
        return self.id.uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    var id: UUID
    
    var name: String
    var diameter: Double
    var abrasive: Bool
    var brand: String
    var color: ChoosableColor
    
    init(api: FilamentApi) {
        self.id = api.id
        self.name = api.name
        self.diameter = api.diameter
        self.abrasive = api.abrasive
        self.brand = api.brand
        self.color = api.color
    }
    
    init(id: UUID, name: String, diameter: Double, abrasive: Bool, brand: String, color: ChoosableColor) {
        self.id = id
        self.name = name
        self.diameter = diameter
        self.abrasive = abrasive
        self.brand = brand
        self.color = color
    }
}

struct FilamentConstants {
    static let PrusamentOrange = Filament(id: UUID(), name: "Prusa Orange", diameter: 1.75, abrasive: false, brand: "Prusamant", color: ChoosableColor.orange)
    static let PrusamentGalaxyBlack = Filament(id: UUID(), name: "Prusa Galaxy Black", diameter: 1.75, abrasive: false, brand: "Prusamant", color: ChoosableColor.black)
}
