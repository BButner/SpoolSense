//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct TransactionsList: View {
    var transactions: [Transaction]
    
    var body: some View {
        ForEach(transactions) { transaction in
            HStack {
                transaction.type.icon
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            TransactionsList(transactions: TransactionConstants.generateTransactionsForSpoolId(spoolId: SpoolConstants.demoSpoolOrange.id))
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
