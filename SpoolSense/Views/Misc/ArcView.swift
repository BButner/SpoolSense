//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct ArcView<S>: View where S : ShapeStyle {
    var length: Double
    var endAngle: Angle
    var style: S
    var strokeLineWidth: Double = 8
    var animated: Bool = true
    @State private var animatedAngleDegrees: Double = 0
    
    var body: some View {
        ArcShape(center: CGPoint(x: length / 2, y: length / 2), radius: length / 2, endAngleDegrees: animated ? animatedAngleDegrees : endAngle.degrees)
            .size(width: length, height: length)
            .stroke(
                style,
                style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round)
            )
//            .shadow(color: .indigo.opacity(0.4), radius: animatedAngleDegrees == endAngle.degrees ? 6 : 0)
            .frame(width: length, height: length)
            .onChange(of: endAngle, initial: true) {
                withAnimation(.easeInOut) {
                    animatedAngleDegrees = endAngle.degrees < 0 
                    ? 0
                    : endAngle.degrees > 360 ? 360 : endAngle.degrees
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
    ArcView(length: 100, endAngle: .degrees(156.0), style: .blue)
}
