//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct SpoolSheet: View {
    var selectedSpool: Spool
    @State private var showAddTransaction: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        HStack {
                            Text("\(selectedSpool.filament.brand) - \(selectedSpool.filament.material.rawValue)")
                                .font(.title)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text(selectedSpool.name)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    GeometryReader() { geometry in
                        Rectangle()
                            .fill(.fill)
                            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                            .frame(height: 10)
                            .overlay {
                                HStack {
                                    Rectangle()
                                        .fill(
                                            LinearGradient(gradient: Gradient(colors: [
                                                selectedSpool.uiColor().opacity(0.7),
                                                selectedSpool.uiColor()
                                            ]), startPoint: .leading, endPoint: .trailing)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                                        .frame(width: geometry.size.width * selectedSpool.remainingPct(), height: 10)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                                    
                                    Spacer()
                                }
                            }
                    }
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                    Text("You have \(selectedSpool.lengthRemaining.rounded(.down).formatted())m of filament remaining out of \(selectedSpool.lengthTotal.rounded(.down).formatted())m")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Transactions")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    NavigationLink(destination: AddTransaction(spool: selectedSpool, isPresented: $showAddTransaction)) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .tint(.primary)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    SpoolSheet(selectedSpool: SpoolConstants.demoSpoolOrange)
}
