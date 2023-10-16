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
                    Text(filament.name)
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return FilamentsView()
        .environment(api)
        .environment(mainContext)
}
