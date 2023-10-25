//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct SpoolContainer: View {
    @Bindable var spool: Spool
    @State private var animatedEndAngle: Angle = .degrees(-90.0)
    private let arcSize: Double = 60
    
    var body: some View {        
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
                ArcView(
                    length: arcSize, endAngle: .degrees(360.0), style: spool.uiColor().opacity(0.2)
                )
                
                ArcView(
                    length: arcSize, endAngle: .degrees((360.0 * spool.remainingPct())), style: spool.uiColor()
                )
                
                Text(spool.remainingPct().rounded(.down) == 1 ? "Full" : "\((spool.remainingPct() * 100).rounded().formatted())%")
                    .fontWeight(.bold)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    VStack {
        Spacer()
        ForEach(SpoolConstants.demoSpoolCollection) { spool in
            SpoolContainer(spool: spool)
        }
        Spacer()
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
