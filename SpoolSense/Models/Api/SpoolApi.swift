//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation

class SpoolApi: Codable, Identifiable {
    var id: UUID
    var filamentId: UUID
    
    var name: String
    var lengthTotal: Double // Default in Meters
    var lengthRemaining: Double // Default in Meters
    var purchasePrice: Double
    var spoolWeight: Double // Default in Grams
    var totalWeight: Double // Default in Grams
    
    enum CodingKeys: CodingKey {
        case id, filament_id, name, length_total, length_remaining, purchase_price, spool_weight, total_weight
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try UUID(uuidString: container.decode(String.self, forKey: .id))!
        self.filamentId = try UUID(uuidString: container.decode(String.self, forKey: .filament_id))!
        
        self.name = try container.decode(String.self, forKey: .name)
        self.lengthTotal = try container.decode(Double.self, forKey: .length_total)
        self.lengthRemaining = try container.decode(Double.self, forKey: .length_remaining)
        self.purchasePrice = try container.decode(Double.self, forKey: .purchase_price)
        self.spoolWeight = try container.decode(Double.self, forKey: .spool_weight)
        self.totalWeight = try container.decode(Double.self, forKey: .total_weight)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(filamentId, forKey: .filament_id)
        
        try container.encode(name, forKey: .name)
        try container.encode(lengthTotal, forKey: .length_total)
        try container.encode(lengthRemaining, forKey: .length_remaining)
        try container.encode(purchasePrice, forKey: .purchase_price)
        try container.encode(spoolWeight, forKey: .spool_weight)
        try container.encode(totalWeight, forKey: .total_weight)
    }
}
