//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 30) {
                Image(.appIconTransparent)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Text("SpoolSense")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            Spacer()
            
            VStack(spacing: 15) {
                Button {
                    
                } label: {
                    ZStack(alignment: .center) {
                        HStack {
                            Image(systemName: "apple.logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                        }
                        
                        Text("Continue with Apple")
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                    }
                    .padding(6)
                }
                .buttonStyle(.borderedProminent)
                .tint(.primary)
                
                Button {
                    
                } label: {
                    ZStack(alignment: .center) {
                        HStack {
                            Image(.googleLogo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                            
                            Spacer()
                        }
                        
                        Text("Continue with Google")
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                        Spacer()
                    }
                    .padding(6)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return LoginView()
        .environment(api)
        .environment(mainContext)
}
