//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct AddSpoolView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(MainViewModel.self) private var mainContext
    @Environment(SpoolSenseApi.self) private var api
    
    @Binding var showAddView: Bool
    var selectableFilaments: [Filament]
    @State private var selectedTab = 0
    @State private var spoolName: String = ""
    @State private var filament: Filament = FilamentConstants.FilamentUnselected
    @State private var lengthTotal: Double = 0
    @State private var lengthRemaining: Double = 0
    @State private var purchasePrice: Double = 0
    @State private var spoolWeight: Double = 0
    @State private var totalWeight: Double = 0
    @State private var color: ChoosableColor = ChoosableColor.unselected
    
    @State private var isLoading: Bool = false
    @State private var isFinishedAdding: Bool = false
    
    var isInvalid: Bool {
        spoolName == ""
        || purchasePrice == 0
        || lengthTotal == 0
        || lengthRemaining == 0
        || totalWeight == 0
        || spoolWeight == 0
        || filament.isUnselectedView
        || (filament.color == nil && color == ChoosableColor.unselected)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(color.uiColor().opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .animation(.easeIn(duration: 0.5), value: color)
                ScrollView {
                    ZStack(alignment: .topTrailing) {
                        VStack(spacing: 20) {
                            HStack {
                                Spacer()
                                
                                Button {
                                    showAddView = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                .tint(.secondary)
                            }
                            
                            HStack {
                                Spacer()
                                Text("Add Spool")
                                    .font(.largeTitle)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .padding()
                            
                            TextFieldString(header: "Spool Name", title: "What should we call this spool?", text: $spoolName, isInvalid: spoolName.isEmpty, errorMessage: "cannot be empty")
                            TextFieldNumber(header: "Purchase Price", title: "What did you originally pay?", value: $purchasePrice, isInvalid: purchasePrice.isZero || purchasePrice.isLess(than: .zero), errorMessage: "must be above 0")
                            
                            Picker("Filament", selection: $filament) {
                                ForEach(selectableFilaments) { filament in
                                    Text(filament.isUnselectedView ? "Select a Filament" : "\(filament.brand) - \(filament.name)")
                                        .tag(filament)
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .padding()
                            
                            Picker(filament.color == nil ? "Color (Required)" : "Color (Optional)", selection: $color) {
                                ForEach(ChoosableColor.allCases, id: \.rawValue) { c in
                                    HStack(alignment: .center) {
                                        if (c != ChoosableColor.unselected) {
                                            Rectangle()
                                                .fill(c.uiColor())
                                                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                                                .frame(width: 32, height: 4)
                                        }
                                        
                                        Text(c.rawValue)
                                    }
                                    .tag(c)
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .padding()
                            
                            TextFieldNumber(header: "Spool Length", title: "What's the total original length in meters?", value: $lengthTotal, isInvalid: lengthTotal.isZero || lengthTotal.isLess(than: .zero), errorMessage: "must be above 0")
                            TextFieldNumber(header: "Spool Length Remaining", title: "How many meters of Filament are left?", value: $lengthRemaining, isInvalid: lengthRemaining.isZero || lengthRemaining.isLess(than: .zero), errorMessage: "must be above 0")
                            TextFieldNumber(header: "Spool Weight", title: "How much does just the spool (minus filament) weigh?", value: $spoolWeight, isInvalid: spoolWeight.isZero || spoolWeight.isLess(than: .zero), errorMessage: "must be above 0")
                            TextFieldNumber(header: "Total Weight", title: "How much does the spool currently weigh?", value: $spoolWeight, isInvalid: spoolWeight.isZero || spoolWeight.isLess(than: .zero), errorMessage: "must be above 0")
                            
                            DragConfirm(text: "Swipe to Submit", isLoading: $isLoading, isComplete: $isFinishedAdding)
                                .onChange(of: isLoading) {
                                    Task {
                                        let newSpool = Spool(id: UUID(), filament: filament, name: spoolName, lengthTotal: lengthTotal, lengthRemaining: lengthRemaining, purchasePrice: purchasePrice, spoolWeight: spoolWeight, totalWeight: totalWeight, color: color == ChoosableColor.unselected ? nil : color)
            
                                        Task {
                                            if await api.insertSpool(spool: newSpool.toApi()) {
                                                mainContext.spools.append(newSpool)
                                                showAddView.toggle()
                                            }
                                        }
                                    }
                                }
                                .disabled(isInvalid)
                        }
                        .padding()
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return AddSpoolView(showAddView: .constant(true), selectableFilaments: [FilamentConstants.FilamentUnselected] + mainContext.filaments)
        .environment(api)
        .environment(mainContext)
        .task {
            await mainContext.loadInitialData()
        }
        .background(Color(.systemGroupedBackground))
}
