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
    
    @State private var showSheet = false
    @State private var selectedSpool: Spool?
    
    var body: some View {
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
                                    length: 60, endAngle: .degrees(360.0), style: spool.uiColor().opacity(0.2)
                                )
                                
                                ArcView(
                                    length: 60, endAngle: .degrees((360.0 * (spool.remainingPct()))), style: spool.uiColor()
                                )
                                
                                Text((spool.remainingPct().rounded(.down)) == 1 ? "Full" : "\(((spool.remainingPct()) * 100).rounded().formatted())%")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(width: 60, height: 60)
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .foregroundStyle(.primary)
            .navigationDestination(for: Spool.self) { spool in
                SpoolSheet(selectedSpool: spool)
                    .navigationTitle(spool.name)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        SpoolList(loading: true, spools: SpoolConstants.demoSpoolCollection)
        Spacer()
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
