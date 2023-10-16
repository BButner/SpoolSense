//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct AddSpoolDetails: View {
    var filament: Filament
    @Binding var name: String
    @Binding var lengthTotal: Double
    @Binding var lengthRemaining: Double
    @Binding var purchasePrice: Double
    @Binding var spoolWeight: Double
    @Binding var totalWeight: Double
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Basic Spool Info")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Text("Get started adding a new spool with some basic information.")
                .padding(.top, 2)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 30) {
                HStack {
                    HStack {
                        Text("Total Length")
                            .fontWeight(.semibold)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                    
                    TextField("Required", value: $lengthTotal, format: .number)
                        .multilineTextAlignment(.trailing)
                    Text("m")
                        .foregroundStyle(.secondary)
                        .frame(width: 15)
                }
                
                HStack {
                    HStack {
                        Text("Remaining Length")
                            .fontWeight(.semibold)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                    
                    TextField("Required", value: $lengthRemaining, format: .number)
                        .multilineTextAlignment(.trailing)
                    Text("m")
                        .foregroundStyle(.secondary)
                        .frame(width: 15)
                }
                
                HStack {
                    HStack {
                        Text("Total Weight")
                            .fontWeight(.semibold)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                    
                    TextField("Required", value: $totalWeight, format: .number)
                        .multilineTextAlignment(.trailing)
                    Text("g")
                        .foregroundStyle(.secondary)
                        .frame(width: 15)
                }
                
                HStack {
                    HStack {
                        Text("Spool Weight")
                            .fontWeight(.semibold)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                    
                    TextField("Required", value: $spoolWeight, format: .number)
                        .multilineTextAlignment(.trailing)
                    Text("g")
                        .foregroundStyle(.secondary)
                        .frame(width: 15)
                }
                
                HStack {
                    HStack {
                        Text("Purchase Price")
                            .fontWeight(.semibold)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                    
                    TextField("Required", value: $purchasePrice, format: .number)
                        .multilineTextAlignment(.trailing)
                    Text("$")
                        .foregroundStyle(.secondary)
                    
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            Spacer()
            
            SpoolContainer(spool: Spool(id: UUID(), filament: filament, name: name, lengthTotal: lengthTotal, lengthRemaining: lengthRemaining, purchasePrice: purchasePrice, spoolWeight: spoolWeight, totalWeight: totalWeight))
        }
        .padding()
    }
}

#Preview {
    @State var name: String = "Example Name"
    @State var lengthTotal: Double = 0
    @State var lengthRemaining: Double = 0
    @State var purchasePrice: Double = 0
    @State var spoolWeight: Double = 0
    @State var totalWeight: Double = 0
    
    return AddSpoolDetails(
        filament: FilamentConstants.PrusamentOrange,
        name: $name,
        lengthTotal: $lengthTotal, lengthRemaining: $lengthRemaining, purchasePrice: $purchasePrice, spoolWeight: $spoolWeight, totalWeight: $totalWeight
    )
}
