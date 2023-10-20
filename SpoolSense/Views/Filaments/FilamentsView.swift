//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct FilamentsView: View {
    @Environment(MainViewModel.self) private var mainContext
    
    @State private var showAddView = false
    
    var body: some View {
        ScrollView {
            HStack {
                Text("My Filaments")
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
                    //                    AddSpoolView()
                }
            }
            
            VStack {
                ForEach(mainContext.filaments) { filament in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(filament.brand)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            
                            Text(filament.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(filament.nozzleMin.formatted()) °C - \(filament.nozzleMax.formatted()) °C")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
                            HStack(alignment: .center) {
                                Text("⌀")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                
                                Text(filament.diameter.formatted() + " mm")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                            }
                            
                            HStack(alignment: .center) {
                                Rectangle()
                                    .fill(filament.color?.uiColor() ?? .gray)
                                    .frame(width: 32, height: 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                                
                                Text(filament.material.rawValue)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .refreshable {
            await mainContext.refreshFilaments()
        }
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return FilamentsView()
        .environment(api)
        .environment(mainContext)
        .task {
            await mainContext.loadInitialData()
        }
}
