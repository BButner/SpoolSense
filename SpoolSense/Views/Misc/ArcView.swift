//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct ArcView<S>: View where S : ShapeStyle {
    var endAngle: Angle
    var style: S
    var strokeLineWidth: Double = 10
    @State private var animatedAngle: Angle = .degrees(-90.0)
    
    var animatableData: Angle {
        get { animatedAngle }
        set { animatedAngle = newValue }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

        Path { path in
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(-90),
                endAngle: animatedAngle,
                clockwise: false
            )
        }
        .stroke(
            style,
            style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
        }
        .onAppear {
            withAnimation {
                animatedAngle = endAngle
            }
        }
    }
}

#Preview {
    ArcView(endAngle: .degrees(156.0), style: .blue)
        .frame(width: 100, height: 100)
}
