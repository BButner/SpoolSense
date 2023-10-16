//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct SpoolList: View {
    let spools: [Spool]
    
    @State private var showSheet = false
    @State private var selectedSpool: Spool?
    
    var body: some View {
        VStack {
            ForEach(spools) { spool in
                Button {
                    selectedSpool = spool
                    withAnimation {
                        showSheet.toggle()
                    }
                } label: {
                    SpoolContainer(spool: spool)
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
    SpoolList(spools: SpoolConstants.demoSpoolCollection)
}
