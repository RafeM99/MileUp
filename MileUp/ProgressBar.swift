//
//  ProgressBar.swift
//  MileUp
//
//  Created by Rafe Marriott on 24/01/2026.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    var colour: Color = Color.blue
    
    let arcSpan: CGFloat = 2.0 / 3.0
    var startAngle: Angle {
        Angle.degrees(270 - Double((arcSpan * 360) / 2))
    }
    
    private var clampedProgress: CGFloat { CGFloat(min(max(progress, 0), 1)) }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: arcSpan)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .opacity(0.2)
                .foregroundStyle(Color.gray)
                .rotationEffect(startAngle)
            
            Circle()
                .trim(from: 0, to: arcSpan * CGFloat(min(max(progress, 0), 1)))
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .foregroundStyle(colour)
                .rotationEffect(startAngle)
                .animation(.easeInOut(duration: 2), value: progress)
            
            Needle()
                .fill(.red)
                .frame(width: 10, height: 100)
                .offset(y: -50)
                .rotationEffect(.degrees(240 + (240 * Double(progress))))
                .animation(.easeInOut(duration: 2), value: progress)
        }
    }
}

#Preview {
    @Previewable @State var previewProgress: Float = 0.5
    return ProgressBar(progress: .constant(previewProgress))
}
