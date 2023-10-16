//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import SwiftUI

@Observable
final class Spool: Identifiable {
    var id: UUID
    var filament: Filament
    var name: String
    var lengthTotal: Double // Default in Meters
    var lengthRemaining: Double // Default in Meters
    var purchasePrice: Double
    var spoolWeight: Double // Default in Grams
    var totalWeight: Double // Default in Grams
    
    init(id: UUID, filament: Filament, name: String, lengthTotal: Double, lengthRemaining: Double, purchasePrice: Double, spoolWeight: Double, totalWeight: Double) {
        self.id = id
        self.filament = filament
        self.name = name
        self.lengthTotal = lengthTotal
        self.lengthRemaining = lengthRemaining
        self.purchasePrice = purchasePrice
        self.spoolWeight = spoolWeight
        self.totalWeight = totalWeight
    }
    
    init(api: SpoolApi, filament: Filament) {
        self.id = api.id
        self.filament = filament
        self.name = api.name
        self.lengthTotal = api.lengthTotal
        self.lengthRemaining = api.lengthRemaining
        self.purchasePrice = api.purchasePrice
        self.spoolWeight = api.spoolWeight
        self.totalWeight = api.totalWeight
    }
    
    func remainingPct() -> Double {
        self.lengthRemaining / self.lengthTotal
    }
    
    func remainingValue() -> Double {
        self.purchasePrice * self.remainingPct()
    }
}

enum SpoolSortOptions: Int, CaseIterable {
    case name = 0
    case brand = 1
    case lengthRemaining = 2
    case lengthTotal = 3
    case price = 4
    
    var title: String {
        switch self {
        case .name:
            return "Name"
        case .brand:
            return "Brand"
        case .lengthRemaining:
            return "Remaining Length"
        case .lengthTotal:
            return "Total Length"
        case .price:
            return "Price"
        }
    }
}

extension SpoolSortOptions {
    func sortBy(first: Spool, second: Spool, ascending: Bool) -> Bool {
        switch self {
        case .name:
            return ascending ? first.name < second.name : first.name > second.name
        case .brand:
            return ascending ? first.filament.brand < second.filament.brand : first.filament.brand > second.filament.brand
        case .lengthRemaining:
            return ascending ? first.lengthRemaining < second.lengthRemaining : first.lengthRemaining > second.lengthRemaining
        case .lengthTotal:
            return ascending ? first.lengthTotal < second.lengthTotal : first.lengthTotal > second.lengthTotal
        case .price:
            return ascending ? first.purchasePrice < second.purchasePrice : first.purchasePrice > second.purchasePrice
        }
    }
}

struct SpoolConstants {
    static let demoSpoolPrusaOrange = Spool(id: UUID(), filament: FilamentConstants.PrusamentOrange, name: "My Favorite Orange", lengthTotal: 342, lengthRemaining: 300, purchasePrice: 29.99, spoolWeight: 1024, totalWeight: 800)
    
    static let demoSpoolPrusaGalaxyBlack = Spool(id: UUID(), filament: FilamentConstants.PrusamentOrange, name: "My Favorite Black", lengthTotal: 342, lengthRemaining: 275, purchasePrice: 29.99, spoolWeight: 1024, totalWeight: 600)
    
    static let demoSpoolCollection = [SpoolConstants.demoSpoolPrusaOrange, SpoolConstants.demoSpoolPrusaGalaxyBlack]
}
