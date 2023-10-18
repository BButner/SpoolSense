//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct AddSpoolView: View {
    @Environment(MainViewModel.self) private var mainContext
    @Environment(SpoolSenseApi.self) private var api
    
    @Binding var showAddView: Bool
    
    @State private var selectedTab = 0
    @State private var spoolName: String = ""
    @State private var filament: Filament = FilamentConstants.FilamentUnselected
    @State private var lengthTotal: Double = 0
    @State private var lengthRemaining: Double = 0
    @State private var purchasePrice: Double = 0
    @State private var spoolWeight: Double = 0
    @State private var totalWeight: Double = 0
    @State private var color: ChoosableColor?
    
    var isInvalid: Bool {
        spoolName == ""
        || purchasePrice == 0
        || lengthTotal == 0
        || lengthRemaining == 0
        || totalWeight == 0
        || spoolWeight == 0
        || filament.isUnselectedView
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    VStack {
                        Text("Add Spool")
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        
                        Text("Add a new Spool by entering all of its necessary information.")
                            .padding(.top, 2)
                            .multilineTextAlignment(.center)
                    }
                    
                    SpoolContainer(spool: Spool(id: UUID(), filament: filament, name: spoolName, lengthTotal: lengthTotal, lengthRemaining: lengthRemaining, purchasePrice: purchasePrice, spoolWeight: spoolWeight, totalWeight: totalWeight, color: color))
                    
                    VStack(alignment: .leading) {
                        Text("Basic Info")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 30) {
                            HStack {
                                HStack {
                                    Text("Spool Name")
                                        .fontWeight(.semibold)
                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                }
                                
                                Spacer()
                                
                                TextField("Required", text: $spoolName)
                                    .multilineTextAlignment(.trailing)
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
                                    .frame(width: 15)
                                
                            }
                            
                            Picker("", selection: $filament) {
                                ForEach(mainContext.filaments) { filament in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(filament.brand)
                                                .font(.subheadline)
                                                .foregroundStyle(Color.accentColor)
                                            
                                            Text(filament.name)
                                                .fontWeight(.bold)
                                                .font(.body)
                                                .multilineTextAlignment(.leading)
                                                .foregroundStyle(Color.accentColor)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            HStack(alignment: .center) {
                                                Rectangle()
                                                    .fill(color?.uiColor() ?? filament.color?.uiColor() ?? .gray)
                                                    .frame(width: 40, height: 4)
                                                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                                                
                                                Text(filament.material.rawValue)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                    }
                                    .tag(filament)
                                }
                            }
                            .pickerStyle(.navigationLink)
                        }
                        .padding()
                        .background(Color(.systemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Spool Physical Properties")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
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
                        }
                        .padding()
                        .background(Color(.systemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Please make sure all values are entered, and no values are set to 0.")
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .foregroundStyle(.red)
                            .opacity(isInvalid ? 1 : 0)
                            .animation(.spring, value: isInvalid)
                        
                        Button() {
                            let newSpool = Spool(id: UUID(), filament: filament, name: spoolName, lengthTotal: lengthTotal, lengthRemaining: lengthRemaining, purchasePrice: purchasePrice, spoolWeight: spoolWeight, totalWeight: totalWeight, color: color)
                            
                            Task {
                                if await api.insertSpool(spool: newSpool.toApi()) {
                                    showAddView.toggle()
                                }
                            }
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text("Save Spool")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primary)
                        .fontWeight(.semibold)
                        .disabled(isInvalid)
                        .padding(.top, 4)
                        .animation(.spring, value: isInvalid)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return AddSpoolView(showAddView: .constant(true))
        .environment(api)
        .environment(mainContext)
        .task {
            await mainContext.loadInitialData()
        }
}
