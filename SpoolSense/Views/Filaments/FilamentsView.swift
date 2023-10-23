//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SkeletonUI
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
                SkeletonForEach(with: mainContext.filaments, quantity: 4) { loading, filament in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(filament?.brand ?? "")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .skeleton(
                                    with: loading,
                                    animation: .pulse(),
                                    shape: .rounded(.radius(4.0, style: .continuous)),
                                    lines: 1,
                                    scales: [0: 0.4]
                                )
                            
                            Text(filament?.name ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .skeleton(
                                    with: loading,
                                    animation: .pulse(),
                                    shape: .rounded(.radius(4.0, style: .continuous)),
                                    lines: 1
                                )
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(filament?.nozzleMin.formatted() ?? "0") °C - \(filament?.nozzleMax.formatted() ?? "0") °C")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .skeleton(
                                    with: loading,
                                    size: CGSize(width: 75, height: 10),
                                    animation: .pulse(),
                                    shape: .rounded(.radius(4.0, style: .continuous)),
                                    lines: 1
                                )
                            
                            HStack(alignment: .center) {
                                Text("⌀")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                
                                Text((filament?.diameter.formatted() ?? "0") + " mm")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                            }
                            .skeleton(
                                with: loading,
                                size: CGSize(width: 75, height: 10),
                                animation: .pulse(),
                                shape: .rounded(.radius(4.0, style: .continuous)),
                                lines: 1
                            )
                            
                            HStack(alignment: .center) {
                                Rectangle()
                                    .fill(filament?.color?.uiColor() ?? .gray)
                                    .frame(width: 32, height: 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                                
                                Text(filament?.material.rawValue ?? "")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                            }
                            .skeleton(
                                with: loading,
                                size: CGSize(width: 75, height: 10),
                                animation: .pulse(),
                                shape: .rounded(.radius(4.0, style: .continuous)),
                                lines: 1
                            )
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .overlay {
                if mainContext.filaments.count == 0 && mainContext.refreshingFilaments == false && mainContext.initialDataLoaded == true {
                    GeometryReader() { _ in
                        ContentUnavailableView {
                            Label("No Filaments", systemImage: "sink.fill")
                        } description: {
                            Text("New Filaments you add will appear here.")
                                .padding(.top)
                        }
                        .opacity(0.7)
                    }
                    .background(Color(.systemGroupedBackground))
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
