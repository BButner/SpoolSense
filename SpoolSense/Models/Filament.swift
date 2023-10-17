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
    var material: Material
    var isBuiltIn: Bool = false
    var isUnselectedView: Bool = false
    var temperatureMinimum: Double
    var temperatureMaximum: Double
    
    init(api: FilamentApi) {
        self.id = api.id
        self.name = api.name
        self.diameter = api.diameter
        self.abrasive = api.abrasive
        self.brand = api.brand
        self.color = api.color
        self.material = api.material
        self.temperatureMinimum = api.temperatureMinimum
        self.temperatureMaximum = api.temperatureMaximum
    }
    
    init(id: UUID, name: String, diameter: Double, abrasive: Bool, brand: String, color: ChoosableColor, material: Material, temperatureMinimum: Double, temperatureMaximum: Double, isBuiltIn: Bool = false, isUnselectedView: Bool = false) {
        self.id = id
        self.name = name
        self.diameter = diameter
        self.abrasive = abrasive
        self.brand = brand
        self.color = color
        self.material = material
        self.isBuiltIn = isBuiltIn
        self.isUnselectedView = isUnselectedView
        self.temperatureMinimum = temperatureMinimum
        self.temperatureMaximum = temperatureMaximum
    }
}

struct FilamentConstants {
    static let PrusamentOrange = Filament(id: UUID(), name: "Prusa Orange", diameter: 1.75, abrasive: false, brand: "Prusamant", color: ChoosableColor.orange, material: .petg, temperatureMinimum: 220, temperatureMaximum: 250)
    static let PrusamentGalaxyBlack = Filament(id: UUID(), name: "Prusa Galaxy Black", diameter: 1.75, abrasive: false, brand: "Prusamant", color: ChoosableColor.black, material: .petg, temperatureMinimum: 220, temperatureMaximum: 250)
    
    static let FilamentUnselected = Filament(id: UUID(), name: "N/A", diameter: 0, abrasive: false, brand: "N/A", color: ChoosableColor.black, material: .petg, temperatureMinimum: 0, temperatureMaximum: 0, isUnselectedView: true)
}
