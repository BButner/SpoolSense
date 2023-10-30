//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct TextFieldNumber<V>: View {
    var header: String
    var title: String
    @Binding var value: V
    var formatter: Formatter = NumberFormatterConstants.emptyZeroFormatter()
    var isInvalid: Bool
    var errorMessage: String
    
    @State private var shouldShowInvalid: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(header)\(isInvalid && shouldShowInvalid ? " \(errorMessage)" : "")")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(isInvalid && shouldShowInvalid ? .red : .gray)
                .textCase(.uppercase)
                .padding(.leading)
                .animation(.easeInOut(duration: 0.15), value: isInvalid)
                .animation(.easeInOut(duration: 0.15), value: shouldShowInvalid)
            
            TextField(title, value: $value, formatter: formatter)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.primary)
                .padding(.horizontal)
                .frame(height: 44, alignment: .center)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
        }
        .onChange(of: isInvalid, initial: false) {
            if isInvalid && !shouldShowInvalid {
                shouldShowInvalid = true
            }
        }
    }
}

#Preview {
    @State var previewExampleValue: Double = 0
    
    return VStack(alignment: .center) {
        TextFieldNumber(header: "Example Header", title: "Example Title", value: $previewExampleValue, isInvalid: previewExampleValue.isZero || previewExampleValue.isLess(than: 0), errorMessage: "cannot be zero")
    }
    .padding()
}
