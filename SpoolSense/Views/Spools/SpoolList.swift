//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SkeletonUI
import SwiftUI

struct SpoolList: View {
    var loading: Bool
    let spools: [Spool]
    
    @State private var showSheet = false
    @State private var selectedSpool: Spool?
    
    var body: some View {
        VStack {
            SkeletonForEach(with: spools, quantity: 5) { loading, spool in
                Button {
                    selectedSpool = spool
                    withAnimation {
                        showSheet.toggle()
                    }
                } label: {
                    HStack(alignment: .center, spacing: 14) {
                        VStack(alignment: .leading) {
                            Text("\(spool?.filament.brand ?? "") - \(spool?.filament.name ?? "")")
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
                            
                            Text(spool?.name ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .skeleton(
                                    with: loading,
                                    animation: .pulse(),
                                    shape: .rounded(.radius(4.0, style: .continuous)),
                                    lines: 1
                                )
                            
                            Text("\(spool?.lengthRemaining.rounded().formatted() ?? "0")m of \(spool?.lengthTotal.rounded().formatted() ?? "0")m remaining")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .skeleton(
                                    with: loading,
                                    animation: .pulse(),
                                    shape: .rounded(.radius(4.0, style: .continuous)),
                                    lines: 1,
                                    scales: [0: 0.6]
                                )
                        }
                        
                        Spacer()
                        
                        ZStack {
                            if !loading {
                                ArcView(
                                    endAngle: .degrees(360.0), style: spool?.uiColor().opacity(0.2) ?? Color(.systemGroupedBackground)
                                )
                                
                                ArcView(
                                    endAngle: .degrees((360.0 * (spool?.remainingPct() ?? 1))), style: spool?.uiColor() ?? Color(.systemGroupedBackground)
                                )
                                
                                Text((spool?.remainingPct().rounded(.down) ?? 0) == 1 ? "Full" : "\(((spool?.remainingPct() ?? 0) * 100).rounded().formatted())%")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(width: 60, height: 60)
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .foregroundStyle(.primary)
                .sheet(isPresented: $showSheet, onDismiss: {
                }) {
                    SpoolSheet(selectedSpool: $selectedSpool)
                        .presentationDragIndicator(.visible)
                }
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
