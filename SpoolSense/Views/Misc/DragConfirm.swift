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
    @Binding var isError: Bool
    
    @State private var showFinished: Bool = false
    
    var state: DragConfirmState {
        if isLoading && !isComplete {
            return .loading
        } else if isLoading && isComplete && !isError {
            return .success
        } else if isLoading && isComplete && isError {
            return .error
        } else {
            return .idle
        }
    }
    
    @State private var offset = CGSize.zero
    private let buttonLength: Double = 42
    private let buttonPadding: Double = 12
    private let cornerRadius: Double = 8
    
    private let defaultAnimation: Animation = .snappy(duration: 0.3, extraBounce: 0.15)
    
    func dragProgressFill(width: Double) -> Color {
        .indigo.opacity(
            max(
                offset.width / (width - buttonLength - buttonPadding),
                0.1
            )
        )
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                if state == .idle {
                    HStack {
                        Spacer()
                        Text(text)
                            .foregroundStyle(isEnabled ? .indigo.opacity(0.8) : .gray.opacity(0.8))
                        Spacer()
                    }
                    .transition(.opacity)
                    .animation(defaultAnimation, value: state)
                }
                
                ZStack {
                    if state == .idle {
                        Rectangle()
                            .fill(dragProgressFill(width: geo.size.width))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius - 2))
                            .matchedGeometryEffect(id: "indicator", in: namespace)
                            .animation(.interactiveSpring, value: offset)
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(.indigo)
                                .clipShape(RoundedRectangle(cornerRadius: buttonLength))
                                .matchedGeometryEffect(id: "indicator", in: namespace)
                                .frame(width: buttonLength + buttonPadding, height: buttonLength + buttonPadding)
                            
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(state == .idle ? 0 : 1.1)
                                .tint(.white)
                        }
                    }
                }
                .animation(defaultAnimation, value: state)
                
                if state == .idle {
                    ZStack {
                        Image(systemName: "chevron.right")
                            .frame(width: buttonLength, height: buttonLength)
                            .background(isEnabled ? .indigo : .gray)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius - 2))
                            .offset(x: offset.width, y: 0)
                            .foregroundStyle(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(6)
                            .opacity(state != .idle ? 0 : 1)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.width >= 0 {
                                            if gesture.translation.width > geo.size.width - (buttonLength + buttonPadding) {
                                                if offset != CGSize(width: geo.size.width - (buttonLength + buttonPadding), height: 0) {
                                                    Haptics.shared.play(.medium)
                                                }
                                                
                                                offset = CGSize(width: geo.size.width - (buttonLength + buttonPadding), height: 0)
                                            } else {
                                                offset = gesture.translation
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        if offset.width >= geo.size.width - (buttonLength + buttonPadding) {
                                            isLoading = true
                                            Haptics.shared.play(.medium)
                                            offset = .zero
                                        } else {
                                            offset = .zero
                                        }
                                    }
                            )
                            .animation(.interactiveSpring, value: offset)
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .frame(height: buttonLength + buttonPadding)
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
        @State private var isError: Bool = false
        
        var body: some View {
            NavigationStack {
                VStack {
                    Spacer()
                    
                    Button("Reset") {
                        isLoading = false
                        isComplete = false
                        isError = false
                    }
                    
                    Spacer()
                    
                    DragConfirm(text: "Swipe to Confirm", isLoading: $isLoading, isComplete: $isComplete, isError: $isError)
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
