//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct Stat: View {
    var title: String
    var value: String
    var icon: Image
    var color: Color = .indigo
    
    var body: some View {
        HStack {
            VStack {
                HStack(alignment: .center) {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(color)
                    
                    Text(title)
                        .font(.caption)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Text(value)
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    Stat(title: "Value", value: "$280.75", icon: Image(systemName: "dollarsign"))
}
