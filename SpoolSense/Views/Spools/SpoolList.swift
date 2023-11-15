//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct SpoolList: View {
    var loading: Bool
    let spools: [Spool]
    let arcSize: Double = 60
    
    @State private var showSheet = false
    @State private var selectedSpool: Spool?
    
    var body: some View {
        ZStack {
            if loading {
                VStack {
                    ForEach(SpoolConstants.demoSpoolCollection) { spool in
                        HStack(alignment: .center, spacing: 14) {
                            VStack(alignment: .leading) {
                                Text("\(spool.filament.brand) - \(spool.filament.name)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                    .background(.clear)
                                    .skeleton(loading: true)
                                
                                Text(spool.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                    .background(.clear)
                                    .skeleton(loading: true)
                                
                                Text("\(spool.lengthRemaining.rounded().formatted())m of \(spool.lengthTotal.rounded().formatted())m remaining")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .background(.clear)
                                    .skeleton(loading: true)
                            }
                            
                            Spacer()
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
            } else if !loading && spools.count > 0 {
                VStack {
                    ForEach(spools) { spool in
                        NavigationLink(value: spool) {
                            HStack(alignment: .center, spacing: 14) {
                                VStack(alignment: .leading) {
                                    Text("\(spool.filament.brand) - \(spool.filament.name)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                    
                                    Text(spool.name)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                    
                                    Text("\(spool.lengthRemaining.rounded().formatted())m of \(spool.lengthTotal.rounded().formatted())m remaining")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    if !loading {
                                        ArcView(
                                            length: arcSize, endAngle: .degrees(360.0), style: spool.uiColor().opacity(0.2)
                                        )
                                        
                                        ArcView(
                                            length: arcSize, endAngle: .degrees((360.0 * (spool.remainingPct()))), style: spool.uiColor()
                                        )
                                        
                                        Text((spool.remainingPct().rounded(.down)) == 1 ? "Full" : "\(((spool.remainingPct()) * 100).rounded().formatted())%")
                                            .fontWeight(.bold)
                                    }
                                }
                                .frame(width: arcSize, height: arcSize)
                            }
                            .padding(14)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                    .foregroundStyle(.primary)
                    .navigationDestination(for: Spool.self) { spool in
                        SpoolSheet(selectedSpool: spool)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
            else {
                ContentUnavailableView {
                    Label("No Spools", systemImage: "printer.fill")
                } description: {
                    Text("New Spools you add will appear here.")
                        .padding(.top)
                }
                .opacity(0.7)
                .padding(.vertical, 64)
            }
        }
        .animation(.easeInOut, value: loading)
        .transition(.opacity)
    }
}

#Preview {
    //    NavigationStack {
    VStack {
        SpoolList(loading: false, spools: SpoolConstants.demoSpoolCollection)
        Spacer()
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .navigationTitle("My Spools")
    //    }
}
