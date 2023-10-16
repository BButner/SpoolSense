//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct SpoolContainer: View {
    @Bindable var spool: Spool
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Gauge(value: spool.lengthRemaining, in: 0...spool.lengthTotal) {
                Text("")
            } currentValueLabel: {
                Text("\(Int(spool.lengthRemaining))m")
                    .foregroundStyle(spool.filament.color.uiColor())
            }
            .gaugeStyle(AccessoryCircularCapacityGaugeStyle())
            .tint(spool.filament.color.uiColor())
            
            VStack(alignment: .leading) {
                Text(spool.filament.brand)
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
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    SpoolContainer(spool: SpoolConstants.demoSpoolPrusaOrange)
}
