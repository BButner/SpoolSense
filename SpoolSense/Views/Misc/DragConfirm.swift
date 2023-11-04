//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

enum DragConfirmState: Int {
    case idle, loading, success, error
}

struct DragConfirm: View {
    @Namespace var namespace
    @Environment(\.isEnabled) var isEnabled
    
    var text: String
    @Binding var isLoading: Bool
    @Binding var isComplete: Bool
    @State private var showFinished: Bool = false
    
    var state: DragConfirmState {
        if isLoading && !isComplete {
            return .loading
        } else if isLoading && isComplete {
            return .success
        } else {
            return .idle
        }
    }
    
    @State private var offset = CGSize.zero
    private let buttonLength: Double = 42
    private let buttonPadding: Double = 12
    private let cornerRadius: Double = 8
    
    private let defaultAnimation: Animation = .snappy(duration: 0.3, extraBounce: 0.2)
    
    func dragProgressFill(width: Double) -> Color {
        if !isEnabled {
            return .clear
        }
        
        if state == .loading || state == .success {
            return .indigo
        }
        
        return .indigo.opacity(offset.width / (width - buttonLength - buttonPadding))
    }
    
    public var body: some View {
        GeometryReader() { geometry in
            ZStack(alignment: state != .idle ? .center : .leading) {
                HStack {
                    Spacer()
                    Text(text)
                        .foregroundStyle(isEnabled ? .indigo.opacity(0.8) : .gray.opacity(0.8))
                    Spacer()
                }
                .opacity(state != .idle ? 0 : 1)
                .animation(defaultAnimation, value: state)
                .animation(defaultAnimation, value: isEnabled)
                
                Rectangle()
                    .fill(dragProgressFill(width: geometry.size.width))
                    .matchedGeometryEffect(id: "circle", in: namespace, properties: .position)
                    .clipShape(RoundedRectangle(cornerRadius: state != .idle ? buttonLength : cornerRadius))
                    .frame(width: buttonLength + buttonPadding + (state != .idle ? 0 : offset.width))
                    .animation(defaultAnimation, value: state)
                    .animation(defaultAnimation, value: showFinished)
                
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
                                        if offset != CGSize(width: geometry.size.width - (buttonLength + buttonPadding), height: 0) {
                                            Haptics.shared.play(.medium)
                                        }
                                        
                                        offset = CGSize(width: geometry.size.width - (buttonLength + buttonPadding), height: 0)
                                    } else {
                                        offset = gesture.translation
                                    }
                                }
                            }
                            .onEnded { _ in
                                if offset.width >= geometry.size.width - (buttonLength + buttonPadding) {
                                    isLoading = true
                                    Haptics.shared.play(.medium)
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
            }
        }
        .onChange(of: state) {
            if state == .success {
                showFinished = true
            }
        }
        .frame(height: buttonLength + buttonPadding, alignment: .center)
        .fixedSize(horizontal: false, vertical: true)
        .background(state != .idle ? .clear : isEnabled ? .indigo.opacity(0.1) : .gray.opacity(0.1))
        .animation(.easeInOut(duration: 0.0), value: state)
        .clipShape(RoundedRectangle(cornerRadius: state != .idle ? buttonLength : cornerRadius))
        .animation(defaultAnimation, value: state)
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
    struct DragConfirmPreview: View {
        @State private var isLoading: Bool = false
        @State private var isComplete: Bool = false
        
        var body: some View {
            NavigationStack {
                VStack {
                    Spacer()
                    
                    Button("Reset") {
                        isLoading = false
                        isComplete = false
                    }
                    
                    Spacer()
                    
                    DragConfirm(text: "Swipe to Confirm", isLoading: $isLoading, isComplete: $isComplete)
                        .onChange(of: isLoading) {
                            Task {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                    isComplete = true
                                }
                            }
                        }
                }
                .padding()
                .navigationTitle("Drag Confirm")
            }
        }
    }
    
    return DragConfirmPreview()
}
