//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct TextFieldNumber<V>: View {
    var title: String
    @Binding var value: V
    var formatter: Formatter = NumberFormatterConstants.emptyZeroFormatter()
    var isInvalid: Bool
    var errorMessage: String
    
    @FocusState private var isFocused: Bool
    @State private var shouldShowInvalid: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(isInvalid && shouldShowInvalid ? "\(title) \(errorMessage)" : "\(title)")
                .font(.caption2)
                .foregroundStyle(
                    isFocused
                    ? isInvalid && shouldShowInvalid ? .red : .indigo
                    : isInvalid && shouldShowInvalid ? .red : .secondary
                )
                .fontWeight(.bold)
                .textCase(.uppercase)
                .animation(.easeInOut(duration: 0.15), value: isFocused)
                .animation(.easeInOut(duration: 0.15), value: isInvalid)
                .animation(.easeInOut(duration: 0.15), value: shouldShowInvalid)
            
            TextField("", value: $value, formatter: formatter)
                .textFieldStyle(IndigoTextFieldStyle(isFocused: isFocused, isInvalid: isInvalid, shouldShowInvalid: shouldShowInvalid))
                .focused($isFocused)
                .keyboardType(.decimalPad)
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
        TextFieldNumber(title: "Example", value: $previewExampleValue, isInvalid: previewExampleValue.isZero || previewExampleValue.isLess(than: 0), errorMessage: "cannot be zero")
    }
    .padding()
}
