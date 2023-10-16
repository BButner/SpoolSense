//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct AddSpoolView: View {
    @Environment(MainViewModel.self) private var mainContext
    
    @State private var selectedTab = 0
    @State private var spoolName: String = ""
    @State private var filament: Filament?
    @State private var lengthTotal: Double = 0
    @State private var lengthRemaining: Double = 0
    @State private var purchasePrice: Double = 0
    @State private var spoolWeight: Double = 0
    @State private var totalWeight: Double = 0
    
    var body: some View {
        VStack {
            HStack {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation {
                        selectedTab -= 1
                    }
                }
                .disabled(selectedTab == 0)
                Spacer()
                Button("Next") {
                    withAnimation {
                        selectedTab += 1
                    }
                }
                .fontWeight(.semibold)
            }
            .padding()
            
            TabView(selection: $selectedTab) {
                AddSpoolBasicInfo(spoolName: $spoolName, filament: $filament)
                    .tag(0)
                
                AddSpoolDetails(filament: filament ?? FilamentConstants.PrusamentGalaxyBlack, name: $spoolName, lengthTotal: $lengthTotal, lengthRemaining: $lengthRemaining, purchasePrice: $purchasePrice, spoolWeight: $spoolWeight, totalWeight: $totalWeight)
                    .tag(1)
                
                Text("Step 3")
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return AddSpoolView()
        .environment(api)
        .environment(mainContext)
        .task {
            await mainContext.loadInitialData()
        }
}
