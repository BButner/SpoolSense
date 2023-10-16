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
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(filament.color.uiColor())
                                .mask {
                                    Image(.filamentIcon)
                                        .resizable()
                                        .scaledToFit()
                                        .blendMode(.softLight)
                                }
                            
                            Image(.filamentIcon)
                                .resizable()
                                .scaledToFit()
                                .blendMode(.softLight)
                        }
                        .frame(width: 80, height: 80)
                        
                        VStack(alignment: .leading) {
                            Text(filament.brand)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            
                            Text(filament.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                Text("⌀")
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                                
                                Text(filament.diameter.formatted())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
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
