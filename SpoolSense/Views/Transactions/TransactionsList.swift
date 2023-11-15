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
        ForEach(transactions.filter { $0.type != .initial }) { transaction in
            HStack {
                transaction.type.icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.indigo)
                    .padding(8)
                    .background(.indigo.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                VStack {
                    HStack {
                        Text(transaction.description)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("\(transaction.amount < 0 ? "-" : "+")\(abs(transaction.amount).formatted())m")
                            .fontWeight(.semibold)
                            .foregroundStyle(transaction.uiColor)
                    }
                    
                    HStack {
                        Text(transaction.type.rawValue)
                            .font(.caption)
                            .italic()
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(transaction.date.formatted())
                            .font(.caption)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.vertical, 8)
//            .background(Color(.secondarySystemGroupedBackground))
//            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            HStack {
                Text("Transactions List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Spacer()
            
            TransactionsList(transactions: TransactionConstants.generateTransactionsForSpoolId(spoolId: SpoolConstants.demoSpoolOrange.id))
            
            Spacer()
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
