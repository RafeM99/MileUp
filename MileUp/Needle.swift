//
//  Needle.swift
//  MileUp
//
//  Created by Rafe Marriott on 24/01/2026.
//

import SwiftUI

struct Needle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let apex = CGPoint(x: rect.midX, y: rect.minY)
        let rightBase = CGPoint(x: rect.maxX, y: rect.maxY)
        let leftBase = CGPoint(x: rect.minX, y: rect.maxY)
        let curveHeight = min(rect.width / 2, rect.height * 0.4)
        let control = CGPoint(x: rect.midX, y: rect.maxY + curveHeight)
        
        path.move(to: apex)
        path.addLine(to: rightBase)
        path.addQuadCurve(to: leftBase, control: control)
        path.addLine(to: apex)
        path.closeSubpath()
        return path
    }
}

