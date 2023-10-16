//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct AddSpoolView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            HStack {
                Button("Back", systemImage: "chevron.left") {
                    withAnimation {
                        selectedTab -= 1
                    }
                }
                .disabled(selectedTab == 0)
                Spacer()
                Button("Next") {
                    withAnimation {
                        selectedTab += 1
                    }
                }
                .fontWeight(.semibold)
            }
            .padding()
            
            TabView(selection: $selectedTab) {
                AddSpoolBasicInfo()
                    .tag(0)
                
                Text("Step 2")
                    .tag(1)
                
                Text("Step 3")
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    AddSpoolView()
}
