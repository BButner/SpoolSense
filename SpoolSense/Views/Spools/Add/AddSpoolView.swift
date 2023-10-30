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
    
    @State private var spoolWeightGrams: Measurement<UnitMass> = Measurement(value: 0.0, unit: .grams)
    
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
            ScrollView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [color.uiColor()]), startPoint: .bottom, endPoint: .top)
                      .mask(
                        Circle()
                          .frame(width: 100, height: 100)
                          .blur(radius: 100)
                        )
                    
                    VStack(alignment: .leading, spacing: 30) {
                        HStack {
                            Spacer()
                            Text("Add Spool")
                                .font(.largeTitle)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        
                        TextFieldString(header: "Spool Name", title: "What should this Spool be called?", text: $spoolName, isInvalid: spoolName.isEmpty, errorMessage: "cannot be empty")
                        TextFieldNumber(header: "Purchase Price", title: "How much did you pay for this Spool?", value: $purchasePrice, formatter: NumberFormatterConstants.emptyZeroFormatter(style: .currency), isInvalid: purchasePrice.isZero || purchasePrice.isLess(than: 0), errorMessage: "cannot be zero")
                        
                        Picker("Filament", selection: $filament) {
                            ForEach(selectableFilaments) { filament in
                                Text(filament.isUnselectedView ? "Select a Filament" : "\(filament.brand) - \(filament.name)")
                                    .tag(filament)
                            }
                        }
                        .pickerStyle(.navigationLink)

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
                    }
                }
            }
            .padding()
        }
        //        NavigationStack {
        //            ScrollView {
        //                VStack(spacing: 30) {
        //                    VStack {
        //                        Text("Add Spool")
        //                            .font(.largeTitle)
        //                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        //
        //                        Text("Add a new Spool by entering all of its necessary information.")
        //                            .padding(.top, 2)
        //                            .multilineTextAlignment(.center)
        //                    }
        //                    .padding(.vertical)
        //
        //                    VStack(alignment: .leading) {
        //                        Text("Basic Info")
        //                            .font(.subheadline)
        //                            .fontWeight(.semibold)
        //
        //                        VStack(spacing: 30) {
        //                            HStack {
        //                                HStack {
        //                                    Text("Spool Name")
        //                                        .fontWeight(.semibold)
        //                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        //                                }
        //
        //                                Spacer()
        //
        //                                TextField("Required", text: $spoolName)
        //                                    .multilineTextAlignment(.trailing)
        //                            }
        //
        //                            HStack {
        //                                HStack {
        //                                    Text("Purchase Price")
        //                                        .fontWeight(.semibold)
        //                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        //                                }
        //
        //                                Spacer()
        //
        //                                TextField("Required", value: $purchasePrice, formatter: NumberFormatterConstants.emptyZeroFormatter())
        //                                    .multilineTextAlignment(.trailing)
        //                                Text("$")
        //                                    .foregroundStyle(.secondary)
        //                                    .frame(width: 15)
        //
        //                            }
        //
        //                            Picker("Filament", selection: $filament) {
        //                                ForEach(selectableFilaments) { filament in
        //                                    Text(filament.isUnselectedView ? "Select a Filament" : "\(filament.brand) - \(filament.name)")
        //                                        .tag(filament)
        //                                }
        //                            }
        //                            .pickerStyle(.navigationLink)
        //
        //                            Picker(filament.color == nil ? "Color (Required)" : "Color (Optional)", selection: $color) {
        //                                ForEach(ChoosableColor.allCases, id: \.rawValue) { c in
        //                                    HStack(alignment: .center) {
        //                                        if (c != ChoosableColor.unselected) {
        //                                            Rectangle()
        //                                                .fill(c.uiColor())
        //                                                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        //                                                .frame(width: 32, height: 4)
        //                                        }
        //
        //                                        Text(c.rawValue)
        //                                    }
        //                                    .tag(c)
        //                                }
        //                            }
        //                            .pickerStyle(.navigationLink)
        //                        }
        //                        .padding()
        //                        .background(Color(colorScheme == .dark ? .secondarySystemGroupedBackground : .systemGroupedBackground))
        //                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        //                    }
        //
        //                    VStack(alignment: .leading) {
        //                        Text("Spool Physical Properties")
        //                            .font(.subheadline)
        //                            .fontWeight(.semibold)
        //
        //                        VStack(spacing: 30) {
        //                            HStack {
        //                                HStack {
        //                                    Text("Total Length")
        //                                        .fontWeight(.semibold)
        //                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        //                                }
        //
        //                                Spacer()
        //
        //                                TextField("Required", value: $lengthTotal, formatter: NumberFormatterConstants.emptyZeroFormatter())
        //                                    .multilineTextAlignment(.trailing)
        //                                Text("m")
        //                                    .foregroundStyle(.secondary)
        //                                    .frame(width: 15)
        //                            }
        //
        //                            HStack {
        //                                HStack {
        //                                    Text("Remaining Length")
        //                                        .fontWeight(.semibold)
        //                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        //                                }
        //
        //                                Spacer()
        //
        //                                TextField("Required", value: $lengthRemaining, formatter: NumberFormatterConstants.emptyZeroFormatter())
        //                                    .multilineTextAlignment(.trailing)
        //                                Text("m")
        //                                    .foregroundStyle(.secondary)
        //                                    .frame(width: 15)
        //                            }
        //
        //                            HStack {
        //                                HStack {
        //                                    Text("Total Weight")
        //                                        .fontWeight(.semibold)
        //                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        //                                }
        //
        //                                Spacer()
        //
        //                                TextField("Required", value: $totalWeight, formatter: NumberFormatterConstants.emptyZeroFormatter())
        //                                    .multilineTextAlignment(.trailing)
        //                                Text("g")
        //                                    .foregroundStyle(.secondary)
        //                                    .frame(width: 15)
        //                            }
        //
        //                            HStack {
        //                                HStack {
        //                                    Text("Spool Weight")
        //                                        .fontWeight(.semibold)
        //                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        //                                }
        //
        //                                Spacer()
        //
        //                                TextField("Required", value: $spoolWeight, formatter: NumberFormatterConstants.emptyZeroFormatter())
        //                                    .multilineTextAlignment(.trailing)
        //                                Text("g")
        //                                    .foregroundStyle(.secondary)
        //                                    .frame(width: 15)
        //                            }
        //                        }
        //                        .padding()
        //                        .background(Color(colorScheme == .dark ? .secondarySystemGroupedBackground : .systemGroupedBackground))
        //                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        //                    }
        //
        //                    Spacer()
        //
        //                    VStack(alignment: .leading) {
        //                        Text("Please make sure all values are entered, and no values are set to 0.")
        //                            .fontWeight(.semibold)
        //                            .font(.system(size: 12))
        //                            .foregroundStyle(.red)
        //                            .opacity(isInvalid ? 1 : 0)
        //                            .animation(.spring, value: isInvalid)
        //
        //                        Button() {
        //                            let newSpool = Spool(id: UUID(), filament: filament, name: spoolName, lengthTotal: lengthTotal, lengthRemaining: lengthRemaining, purchasePrice: purchasePrice, spoolWeight: spoolWeight, totalWeight: totalWeight, color: color == ChoosableColor.unselected ? nil : color)
        //
        //                            Task {
        //                                if await api.insertSpool(spool: newSpool.toApi()) {
        //                                    mainContext.spools.append(newSpool)
        //                                    showAddView.toggle()
        //                                }
        //                            }
        //                        } label: {
        //                            HStack {
        //                                Spacer()
        //
        //                                Text("Save Spool")
        //                                    .fontWeight(.semibold)
        //
        //                                Spacer()
        //                            }
        //                            .padding(.vertical, 4)
        //                        }
        //                        .buttonStyle(.borderedProminent)
        //                        .tint(.indigo)
        //                        .fontWeight(.semibold)
        //                        .disabled(isInvalid)
        //                        .padding(.top, 4)
        //                        .animation(.spring, value: isInvalid)
        //                    }
        //                }
        //                .padding()
        //            }
        //        }
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
}
