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
    var strokeLineWidth: Double = 8
    var animated: Bool = true
    @State private var animatedAngleDegrees: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ArcShape(center: center, radius: radius, endAngleDegrees: animated ? animatedAngleDegrees : endAngle.degrees)
                .stroke(
                    style,
                    style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
        }
        .onAppear {
            withAnimation(.spring) {
                animatedAngleDegrees = endAngle.degrees
            }
        }
    }
}

struct ArcShape: Shape {
    var center: CGPoint
    var radius: Double
    var endAngleDegrees: Double
    
    var animatableData: Double {
        get { return endAngleDegrees }
        set { endAngleDegrees = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(endAngleDegrees - 90),
            clockwise: false
        )
        
        return path
    }
}

#Preview {
    ArcView(endAngle: .degrees(156.0), style: .blue)
        .frame(width: 100, height: 100)
}
