//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import SwiftUI

@Observable
final class Spool: Identifiable, Hashable {
    var id: UUID
    var filament: Filament
    var name: String
    var lengthTotal: Double // Default in Meters
    var lengthRemaining: Double // Default in Meters
    var purchasePrice: Double
    var spoolWeight: Double // Default in Grams
    var totalWeight: Double // Default in Grams
    var color: ChoosableColor?
    
    init(id: UUID, filament: Filament, name: String, lengthTotal: Double, lengthRemaining: Double, purchasePrice: Double, spoolWeight: Double, totalWeight: Double, color: ChoosableColor?) {
        self.id = id
        self.filament = filament
        self.name = name
        self.lengthTotal = lengthTotal
        self.lengthRemaining = lengthRemaining
        self.purchasePrice = purchasePrice
        self.spoolWeight = spoolWeight
        self.totalWeight = totalWeight
        self.color = color
    }
    
    init(api: SpoolApi, filament: Filament, lengthRemaining: Double) {
        self.id = api.id
        self.filament = filament
        self.name = api.name
        self.lengthTotal = api.lengthTotal
        self.lengthRemaining = lengthRemaining
        self.purchasePrice = api.purchasePrice
        self.spoolWeight = api.spoolWeight
        self.totalWeight = api.totalWeight
        self.color = api.color
    }
    
    func remainingPct() -> Double {
        self.lengthRemaining / self.lengthTotal
    }
    
    func remainingValue() -> Double {
        self.purchasePrice * self.remainingPct()
    }
    
    func currentWeightEstimate() -> Double {
        let weightWithoutSpool = self.totalWeight - self.spoolWeight
        
        let gramsPerMeter = weightWithoutSpool / lengthTotal
        
        return gramsPerMeter * lengthRemaining
    }
    
    func toApi() -> SpoolApi {
        SpoolApi(
            id: self.id,
            filamentId: self.filament.id,
            name: self.name,
            lengthTotal: self.lengthTotal,
            purchasePrice: self.purchasePrice,
            spoolWeight: self.spoolWeight,
            totalWeight: self.totalWeight,
            color: self.color
        )
    }
    
    func updateFromRefresh(api: SpoolApi, filament: Filament, newLengthRemaining: Double) {
        if self.id != api.id { self.id = api.id }
        if self.filament != filament { self.filament = filament }
        if self.name != api.name { self.name = api.name }
        if self.lengthTotal != api.lengthTotal { self.lengthTotal = api.lengthTotal }
        if self.lengthRemaining != newLengthRemaining { self.lengthRemaining = newLengthRemaining }
        if self.purchasePrice != api.purchasePrice { self.purchasePrice = api.purchasePrice }
        if self.spoolWeight != api.spoolWeight { self.spoolWeight = api.spoolWeight }
        if self.totalWeight != api.totalWeight { self.totalWeight = api.totalWeight }
        if self.color != api.color { self.color = api.color }
    }
    
    func uiColor() -> Color {
        return self.color?.uiColor() ?? self.filament.color?.uiColor() ?? .gray
    }
    
    static func == (lhs: Spool, rhs: Spool) -> Bool {
        lhs.id == rhs.id
    }
    
    var identifier: String {
        return self.id.uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
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
    static let demoSpoolOrange = Spool(id: UUID(), filament: FilamentConstants.PrusamentOrange, name: "My Favorite Orange", lengthTotal: 342, lengthRemaining: 300, purchasePrice: 29.99, spoolWeight: 1024, totalWeight: 800, color: .orange)
    
    static let demoSpoolBlack = Spool(id: UUID(), filament: FilamentConstants.PrusamentGalaxyBlack, name: "My Favorite Black", lengthTotal: 342, lengthRemaining: 178, purchasePrice: 29.99, spoolWeight: 1024, totalWeight: 600, color: .black)
    
    static let demoSpoolBlue = Spool(id: UUID(), filament: FilamentConstants.PrusamentGalaxyBlack, name: "My Favorite Blue", lengthTotal: 342, lengthRemaining: 342, purchasePrice: 29.99, spoolWeight: 1024, totalWeight: 600, color: .blue)
    
    static let demoSpoolPurple = Spool(id: UUID(), filament: FilamentConstants.PrusamentGalaxyBlack, name: "My Favorite Blue", lengthTotal: 342, lengthRemaining: 264, purchasePrice: 29.99, spoolWeight: 1024, totalWeight: 600, color: .purple)
    
    static let demoSpoolCollection = [
        SpoolConstants.demoSpoolOrange,
        SpoolConstants.demoSpoolBlack,
        SpoolConstants.demoSpoolPurple,
        SpoolConstants.demoSpoolBlue
    ]
}
