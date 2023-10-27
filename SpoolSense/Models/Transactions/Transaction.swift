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
    var userId: UUID
    var spoolId: UUID
    var sourceId: UUID
    var type: TransactionType
    var date: Date
    var amount: Double
    var description: String
    
    init(
        userId: UUID,
        spoolId: UUID,
        type: TransactionType,
        date: Date,
        amount: Double,
        description: String
    ) {
        self.id = UUID()
        self.userId = userId
        self.spoolId = spoolId
        self.sourceId = userId // Use User ID as the Source ID, as that's the only Source available when creating a transaction in the app
        self.type = type
        self.date = date
        self.amount = amount
        self.description = description
    }
    
    init(api: TransactionApi) {
        self.id = api.id
        self.userId = api.userId
        self.spoolId = api.spoolId
        self.sourceId = api.sourceId
        self.type = api.type
        self.date = api.date
        self.amount = api.amount
        self.description = api.description
    }
    
    func toApi() -> TransactionApi {
        TransactionApi(
            id: self.id,
            userId: self.userId,
            spoolId: self.spoolId,
            sourceId: self.sourceId,
            type: self.type,
            date: self.date,
            amount: self.amount,
            description: self.description
        )
    }
}
