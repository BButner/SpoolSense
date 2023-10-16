//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct AddSpoolBasicInfo: View {
    @Environment(MainViewModel.self) private var mainContext
    
    @Binding var spoolName: String
    @Binding var filament: Filament?
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Basic Spool Info")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Text("Get started adding a new spool with some basic information.")
                .padding(.top, 2)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 30) {
                HStack(spacing: 20) {
                    HStack {
                        Text("Spool Name")
                            .fontWeight(.semibold)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        
                        Spacer()
                    }
                    .frame(width: 110)
                    
                    TextField("Required", text: $spoolName)
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            HStack {
                ZStack {
                    Rectangle()
                        .fill(filament?.color.uiColor() ?? .gray)
                        .mask {
                            Image(.filamentIcon)
                                .resizable()
                                .scaledToFit()
                                .blendMode(.softLight)
                        }
                        .animation(.easeInOut, value: filament)
                    
                    Image(.filamentIcon)
                        .resizable()
                        .scaledToFit()
                        .blendMode(.softLight)
                }
                .frame(width: 80, height: 80)
                
                Spacer()
                
                Picker("Filament", selection: $filament) {
                    Text("Select a Filament")
                    
                    Divider()
                    
                    ForEach(mainContext.filaments) { filament in
                        Text(filament.name)
                            .tag(filament as Filament?)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return AddSpoolBasicInfo(
        spoolName: .constant(""), filament: .constant(FilamentConstants.PrusamentOrange)
    )
    .environment(api)
    .environment(mainContext)
    .task {
        await mainContext.loadInitialData()
    }
}
