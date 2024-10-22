//
//  CustomShapes.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 22/10/24.
//

import SwiftUI


struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        let points = [
            CGPoint(x: width * 0.5, y: 0),
            CGPoint(x: width, y: height * 0.25),
            CGPoint(x: width, y: height * 0.75),
            CGPoint(x: width * 0.5, y: height),
            CGPoint(x: 0, y: height * 0.75),
            CGPoint(x: 0, y: height * 0.25)
        ]
        
        var path = Path()
        path.move(to: points[0])
        
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        path.closeSubpath()
        
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        var path = Path()
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}


