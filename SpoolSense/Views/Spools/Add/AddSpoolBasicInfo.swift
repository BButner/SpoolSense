//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct AddSpoolBasicInfo: View {
    @State private var spoolName: String = ""
    @State private var spoolBrand: String = ""
    @State private var bgColor = Color(.sRGB, red: 0, green: 0, blue: 0)
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Spool Info")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Get started adding a new spool with some basic information.")
                    .padding(.top, 2)
                    .multilineTextAlignment(.center)
            }
            
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
                
                HStack(spacing: 20) {
                    HStack {
                        Text("Spool Brand")
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
            
            ColorPicker("Spool Color", selection: $bgColor)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddSpoolBasicInfo()
}
