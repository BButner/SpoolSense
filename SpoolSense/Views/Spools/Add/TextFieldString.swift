//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct IndigoTextFieldStyle: TextFieldStyle {
    var isFocused: Bool
    var isInvalid: Bool
    var shouldShowInvalid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(
                        isFocused
                        ? isInvalid && shouldShowInvalid ? Color.red.opacity(0.1) : Color.indigo.opacity(0.1)
                        : Color.clear
                    )
                    .strokeBorder(
                        isFocused
                        ? isInvalid && shouldShowInvalid ? Color.red : Color.indigo
                        : isInvalid && shouldShowInvalid ? Color.red : Color.gray,
                        lineWidth: 1
                    )
                    .animation(.easeInOut(duration: 0.15), value: isFocused)
                    .animation(.easeInOut(duration: 0.15), value: isInvalid)
                    .animation(.easeInOut(duration: 0.15), value: shouldShowInvalid)
            )
    }
}

struct TextFieldString: View {
    var title: String
    @Binding var text: String
//    var formatStyle: FormatStyle = TextFieldString.formStyle()
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
            
            TextField("", text: $text)
                .textFieldStyle(IndigoTextFieldStyle(isFocused: isFocused, isInvalid: isInvalid, shouldShowInvalid: shouldShowInvalid))
                .focused($isFocused)
        }
        .onChange(of: isInvalid, initial: false) {
            if isInvalid && !shouldShowInvalid {
                shouldShowInvalid = true
            }
        }
    }
}

#Preview {
    @State var previewExampleText: String = ""
    
    return VStack(alignment: .center) {
        TextFieldString(title: "Example", text: $previewExampleText, isInvalid: previewExampleText.isEmpty, errorMessage: "cannot be empty")
    }
    .padding()
}
