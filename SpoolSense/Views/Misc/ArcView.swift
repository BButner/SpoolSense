//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

struct ArcView: View {
    static var defaultStrokeLineWidth: Double = 8
    
    @Environment(\.isEnabled) var isEnabled
    var length: Double
    var endAngle: Angle
    var style: Color
    var strokeLineWidth: Double = defaultStrokeLineWidth
    var animated: Bool = true
    @State private var animatedAngleDegrees: Double = 0
    
    var body: some View {
        ArcShape(center: CGPoint(x: length / 2, y: length / 2), radius: length / 2, endAngleDegrees: animated ? animatedAngleDegrees : endAngle.degrees)
            .size(width: length, height: length)
            .stroke(
                isEnabled ? style : .gray,
                style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round)
            )
            .frame(width: length, height: length)
            .onChange(of: endAngle, initial: true) {
                DispatchQueue.main.async {
                    animatedAngleDegrees = endAngle.degrees < 0
                    ? 0
                    : endAngle.degrees > 360 ? 360 : endAngle.degrees
                }
            }
            .animation(.easeInOut, value: animatedAngleDegrees)
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
