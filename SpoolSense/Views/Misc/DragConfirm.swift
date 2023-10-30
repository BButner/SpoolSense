//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct DragConfirm: View {
    @Environment(\.isEnabled) var isEnabled
    
    var text: String
    @Binding var isLoading: Bool
    @Binding var isComplete: Bool
    
    @State private var offset = CGSize.zero
    private let buttonLength: Double = 42
    private let buttonPadding: Double = 12
    private let cornerRadius: Double = 8
    
    private let defaultAnimation: Animation = .snappy(duration: 0.3, extraBounce: 0.2)
    
    public var body: some View {
        GeometryReader() { geometry in
            ZStack(alignment: isLoading ? .center : .leading) {
                HStack {
                    Spacer()
                    Text(text)
                        .foregroundStyle(isEnabled ? .indigo.opacity(0.8) : .gray.opacity(0.8))
                    Spacer()
                }
                .opacity(isLoading ? 0 : 1)
                .animation(defaultAnimation, value: isLoading)
                .animation(defaultAnimation, value: isEnabled)
                
                Rectangle()
                    .fill(
                        isLoading && isEnabled
                        ? isLoading ? .indigo
                        : .indigo.opacity(offset.width / (geometry.size.width - buttonLength))
                        : .clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: isLoading ? buttonLength : cornerRadius))
                    .frame(width: buttonLength + buttonPadding + (isLoading ? 0 : offset.width))
                    .animation(defaultAnimation, value: isLoading)
                    .animation(defaultAnimation, value: isEnabled)
                
                Image(systemName: "chevron.right")
                    .frame(width: buttonLength, height: buttonLength)
                    .background(isEnabled ? .indigo : .gray)
                    .clipShape(RoundedRectangle(cornerRadius: isLoading ? buttonLength : cornerRadius - 2))
                    .frame(width: buttonLength, height: buttonLength)
                    .offset(x: offset.width, y: 0)
                    .foregroundStyle(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.width >= 0 {
                                    
                                    if gesture.translation.width > geometry.size.width - (buttonLength + buttonPadding) {
                                        offset = CGSize(width: geometry.size.width - (buttonLength + buttonPadding), height: 0)
                                    } else {
                                        offset = gesture.translation
                                    }
                                }
                            }
                            .onEnded { _ in
                                if offset.width >= geometry.size.width - (buttonLength + buttonPadding) {
                                    isLoading = true
                                    print(isLoading)
                                    offset = .zero
                                } else {
                                    offset = .zero
                                }
                            }
                    )
                    .padding(6)
                    .opacity(isLoading ? 0 : 1)
                    .scaleEffect(isLoading ? 0.8 : 1)
                    .animation(defaultAnimation, value: isLoading)
                    .animation(defaultAnimation, value: isEnabled)
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(isLoading && !isComplete ? 1.3 : 0)
                    .opacity(isLoading && !isComplete ? 1 : 0)
                    .offset(x: offset.width, y: 0)
                    .animation(defaultAnimation, value: isLoading)
                    .animation(.interactiveSpring, value: isComplete)
                    .tint(.white)
                
                Image(systemName: "hand.thumbsup.fill")
                    .frame(width: buttonLength, height: buttonLength)
                    .offset(x: offset.width, y: 0)
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(6)
                    .opacity(isComplete ? 1 : 0)
                    .scaleEffect(isComplete ? 1 : 0)
                    .animation(.interactiveSpring, value: isComplete)
            }
        }
        .frame(height: buttonLength + buttonPadding, alignment: .center)
        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        .background(isLoading ? .clear : isEnabled ? .indigo.opacity(0.1) : .gray.opacity(0.1))
        .animation(.easeInOut(duration: 0.0), value: isLoading)
        .clipShape(RoundedRectangle(cornerRadius: isLoading ? buttonLength : cornerRadius))
        .animation(defaultAnimation, value: isLoading)
        .animation(defaultAnimation, value: isEnabled)
    }
}

extension DragConfirm {
    var keyWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes.lazy
            .compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }
            .first(where: { $0.keyWindow != nil })?
            .keyWindow
    }
}

#Preview {
    @State var isLoading: Bool = false
    @State var isComplete: Bool = false
    
    return VStack(alignment: .center) {
        DragConfirm(text: "Swipe to Confirm", isLoading: $isLoading, isComplete: $isComplete)
    }
    .padding()
}
