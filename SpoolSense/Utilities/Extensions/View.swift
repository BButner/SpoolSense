/// Credit for this goes to: https://github.com/markiv/SwiftUI-Shimmer/blob/main/Sources/Shimmer/Shimmer.swift

import Foundation
import SwiftUI

struct Skeleton<S>: ViewModifier where S : Shape {
    var loading: Bool
    var clipShape: S
    @State private var animate: Bool = false
    let size: Double = 0.3
    
    var startPoint: UnitPoint {
        animate ? UnitPoint(x: 1, y: 0) : UnitPoint(x: 0.0 - size, y: 0.0)
    }
    
    var endPoint: UnitPoint {
        animate ? UnitPoint(x: 1.0 + size, y: 0) : UnitPoint(x: 0, y: 0)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .opacity(0)
        }
        .background(Color(.systemGray4))
        .clipShape(clipShape)
        .background(Color(.systemGray6))
        .clipShape(clipShape)
        .mask(
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.5), .black.opacity(0.8), .black.opacity(0.5)]),
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: animate)
        .onAppear {
            DispatchQueue.main.async {
                self.animate = true
            }
        }
    }
}

struct ConfirmationPopup<P>: View where P: View {
    @Binding var show: Bool
    let presenting: () -> P
    let id: String
    let namespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geometry in
            if show {
                ZStack(alignment: .center) {
                    self.presenting()
                        .blur(radius: self.show ? 1 : 0)
                    
                    Circle()
                        .fill(.indigo)
                        .matchedGeometryEffect(id: id, in: namespace)
                        .frame(width: show ? 100 : 0, height: show ? 1 : 0)
                }
            }
        }
    }
}

extension View {
    func skeleton<S>(
        loading: Bool,
        clipShape: S = RoundedRectangle(cornerRadius: 4, style: .continuous)
    ) -> some View where S : Shape {
        ZStack {
            if loading {
                modifier(Skeleton(loading: loading, clipShape: clipShape))
            } else {
                self
                    .transition(.scale)
            }
        }
        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: loading)
    }
    
    func confirmationPopup(show: Binding<Bool>, id: String, namespace: Namespace.ID) -> some View {
        ConfirmationPopup(show: show, presenting: { self }, id: id, namespace: namespace)
    }
    
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = SwiftUI.Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}
