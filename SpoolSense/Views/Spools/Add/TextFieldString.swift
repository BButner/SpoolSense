//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct TextFieldString: View {
    var header: String
    var title: String
    @Binding var text: String
    var isInvalid: Bool
    var errorMessage: String
    
    @State private var shouldShowInvalid: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(header)\(isInvalid && shouldShowInvalid ? " \(errorMessage)" : "")")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(isInvalid && shouldShowInvalid ? .red : .gray)
                .textCase(.uppercase)
                .padding(.leading)
                .animation(.easeInOut(duration: 0.15), value: isInvalid)
                .animation(.easeInOut(duration: 0.15), value: shouldShowInvalid)
            
            TextField(title, text: $text)
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
    @State var previewExampleText: String = ""
    
    return VStack(alignment: .center) {
        TextFieldString(header: "Example Header", title: "Example Title", text: $previewExampleText, isInvalid: previewExampleText.isEmpty, errorMessage: "cannot be empty")
    }
    .padding()
}
