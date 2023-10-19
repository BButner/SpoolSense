//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation

@Observable
final class Transaction: Identifiable {
    var id: UUID
    var spoolId: UUID
    var type: TransactionType
    var date: Date
    var amount: Double
    
    init(spoolId: UUID, type: TransactionType, date: Date, amount: Double) {
        self.id = UUID()
        self.spoolId = spoolId
        self.type = type
        self.date = date
        self.amount = amount
    }
    
    init(api: TransactionApi) {
        self.id = api.id
        self.spoolId = api.spoolId
        self.type = api.type
        self.date = api.date
        self.amount = api.amount
    }
    
    func toApi() -> TransactionApi {
        TransactionApi(
            id: self.id,
            spoolId: self.spoolId,
            type: self.type,
            date: self.date,
            amount: self.amount
        )
    }
}
