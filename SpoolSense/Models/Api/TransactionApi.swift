//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation

class TransactionApi: Codable, Identifiable {
    var id: UUID
    var spoolId: UUID
    var type: TransactionType
    var date: Date
    var amount: Double // Default in Meters, can be positive or negative
    
    enum CodingKeys: CodingKey {
        case id, spool_id, type, date, amount
    }
    
    init(id: UUID, spoolId: UUID, type: TransactionType, date: Date, amount: Double) {
        self.id = id
        self.spoolId = spoolId
        self.type = type
        self.date = date
        self.amount = amount
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try UUID(uuidString: container.decode(String.self, forKey: .id))!
        self.spoolId = try UUID(uuidString: container.decode(String.self, forKey: .spool_id))!
        self.type = try container.decode(TransactionType.self, forKey: .type)
        self.date = try container.decode(Date.self, forKey: .date)
        self.amount = try container.decode(Double.self, forKey: .amount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(spoolId, forKey: .spool_id)
        try container.encode(type, forKey: .type)
        try container.encode(date, forKey: .date)
        try container.encode(amount, forKey: .amount)
    }
}
