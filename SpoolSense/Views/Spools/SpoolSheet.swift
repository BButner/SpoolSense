//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct SpoolSheet: View {
    @Binding var selectedSpool: Spool?
    
    var body: some View {
        if selectedSpool == nil {
            ScrollView {}
        } else {
            ScrollView {
                VStack(alignment: .center) {
                    HStack {
                        VStack {
                            HStack {
                                Text(selectedSpool!.filament.brand)
                                    .font(.title)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(selectedSpool!.name)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                        }
                    }
                }
                
                Gauge(value: selectedSpool!.lengthRemaining, in: 0...selectedSpool!.lengthTotal) {
                    Text("")
                } currentValueLabel: {
                    Text("\(Int(selectedSpool!.lengthRemaining))m")
                        .foregroundStyle(selectedSpool!.uiColor())
                        .fontWeight(.semibold)
                } minimumValueLabel: {
                    Text("0m")
                        .foregroundStyle(.secondary)
                } maximumValueLabel: {
                    Text("\(Int(selectedSpool!.lengthTotal))m")
                        .foregroundStyle(.secondary)
                }
                .gaugeStyle(.linearCapacity)
                .tint(selectedSpool!.uiColor())
                .padding(.vertical)
            }
            .padding(20)
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    SpoolSheet(selectedSpool: .constant(SpoolConstants.demoSpoolPrusaOrange))
}
