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
    var color: ChoosableColor?
    var material: Material
    var isBuiltIn: Bool = false
    var isUnselectedView: Bool = false
    var nozzleMin: Double
    var nozzleMax: Double
    var bedMin: Double
    var bedMax: Double
    
    init(api: FilamentApi) {
        self.id = api.id
        self.name = api.name
        self.diameter = api.diameter
        self.abrasive = api.abrasive
        self.brand = api.brand
        self.color = api.color
        self.material = api.material
        self.nozzleMin = api.nozzleMin
        self.nozzleMax = api.nozzleMax
        self.bedMin = api.bedMin
        self.bedMax = api.bedMax
    }
    
    init(id: UUID, name: String, diameter: Double, abrasive: Bool, brand: String, color: ChoosableColor, material: Material, nozzleMin: Double, nozzleMax: Double, bedMin: Double, bedMax: Double, isBuiltIn: Bool = false, isUnselectedView: Bool = false) {
        self.id = id
        self.name = name
        self.diameter = diameter
        self.abrasive = abrasive
        self.brand = brand
        self.color = color
        self.material = material
        self.isBuiltIn = isBuiltIn
        self.isUnselectedView = isUnselectedView
        self.nozzleMin = nozzleMin
        self.nozzleMax = nozzleMax
        self.bedMin = bedMin
        self.bedMax = bedMax
    }
    
    func updateFromRefresh(api: FilamentApi) {
        if self.id != api.id { self.id = api.id }
        if self.name != api.name { self.name = api.name }
        if self.diameter != api.diameter { self.diameter = api.diameter }
        if self.abrasive != api.abrasive { self.abrasive = api.abrasive }
        if self.brand != api.brand { self.brand = api.brand }
        if self.color != api.color { self.color = api.color }
        if self.material != api.material { self.material = api.material }
        if self.nozzleMin != api.nozzleMin { self.nozzleMin = api.nozzleMin }
        if self.nozzleMax != api.nozzleMax { self.nozzleMax = api.nozzleMax }
        if self.bedMin != api.bedMin { self.bedMin = api.bedMin }
        if self.bedMax != api.bedMax { self.bedMax = api.bedMax }
    }
}

struct FilamentConstants {
    static let PrusamentOrange = Filament(id: UUID(), name: "Prusa Orange", diameter: 1.75, abrasive: false, brand: "Prusamant", color: ChoosableColor.orange, material: .pla, nozzleMin: 190, nozzleMax: 220, bedMin: 40, bedMax: 60)
    static let PrusamentGalaxyBlack = Filament(id: UUID(), name: "Prusa Galaxy Black", diameter: 1.75, abrasive: false, brand: "Prusamant", color: ChoosableColor.black, material: .petg, nozzleMin: 230, nozzleMax: 250, bedMin: 80, bedMax: 90)
    
    static let FilamentUnselected = Filament(id: UUID(), name: "N/A", diameter: 0, abrasive: false, brand: "N/A", color: ChoosableColor.black, material: .petg, nozzleMin: 0, nozzleMax: 0, bedMin: 0, bedMax: 0, isUnselectedView: true)
}
