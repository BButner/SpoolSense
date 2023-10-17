//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct SpoolsView: View {
    @Environment(MainViewModel.self) private var mainContext

    @State private var showAddView = false
    @State private var isAscending = true
    
    @AppStorage("spoolsSortBy") var sortBy: SpoolSortOptions = .name
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("My Spools")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            showAddView.toggle()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .tint(.primary)
                    }
                    .sheet(isPresented: $showAddView)  {
                        AddSpoolView(showAddView: $showAddView)
                    }
                }
                
                VStack {
                    HStack {
                        Stat(title: "Spools", value: mainContext.spools.count.formatted(), icon: Image(systemName: "printer"))
                        Stat(title: "Weight", value: "3.1 kg", icon: Image(systemName: "scalemass"))
                    }
                    
                    HStack {
                        Stat(
                            title: "Distance",
                            value: "\(((mainContext.spools.reduce(0) { $0 + $1.lengthRemaining }) / 1000).rounded(toPlaces: 1)) km",
                            icon: Image(systemName: "ruler")
                        )
                        Stat(
                            title: "Value",
                            value: "$\((mainContext.spools.reduce(0) { $0 + $1.remainingValue() }).rounded(toPlaces: 2))",
                            icon: Image(systemName: "dollarsign")
                        )
                    }
                }
            }
            
            HStack {
                Spacer()
                
                Menu {
                    Picker("Sort", selection: $sortBy.onChange(onSortByChanged).animation(.interactiveSpring)) {
                        ForEach(SpoolSortOptions.allCases, id: \.rawValue) { option in
                            HStack {
                                Text(option.title)
                                
                                Spacer()
                                
                                if sortBy.rawValue == option.rawValue {
                                    Image(systemName: isAscending ? "chevron.up" : "chevron.down")
                                }
                            }
                            .tag(option)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .tint(.primary)
                }
            }
            .padding()
            
            SpoolList(spools: mainContext.spools.sorted(by: { sortBy.sortBy(first: $0, second: $1, ascending: self.isAscending) }))
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

extension SpoolsView {
    func onSortByChanged(to oldValue: SpoolSortOptions, to newValue: SpoolSortOptions) {
        if oldValue.rawValue == newValue.rawValue {
            self.isAscending.toggle()
        }
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return SpoolsView()
        .environment(api)
        .environment(mainContext)
        .task {
            await mainContext.loadInitialData()
        }
}
