//
//  UIBezier.swift
//  OntarioMedic
//
//  Created by Charles Trickey on 2019-09-05.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//
import UIKit

extension UIBezierPath {
    
    static func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> UIBezierPath {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
    static func line(from start: CGPoint, to end: CGPoint, lineWidth: CGFloat) -> UIBezierPath {
        let length = hypot(end.x - start.x, end.y - start.y)
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, lineWidth / 2),
            p(length, lineWidth / 2),
            p(length, -lineWidth / 2),
            p(0, -lineWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
    static func rect(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(start.x, start.y),
            p(end.x, start.y),
            p(end.x, end.y),
            p(start.x, end.y)
        ]
        
        let path = CGMutablePath()
        path.addLines(between: points)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
    static func pointed_box(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(start.x, start.y),
            p(end.x, start.y),
            p(end.x, start.y + (end.y - start.y)/2),
            p(start.x + (end.x - start.x)/2, end.y),
            p(start.x, start.y + (end.y - start.y)/2)
        ]
        
        let path = CGMutablePath()
        path.addLines(between: points)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
    static func diamond(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        
        let center = CGPoint( x: start.x + (end.x - start.x) / 2, y: start.y + (end.y - start.y))
       
        let X = (end.x - start.x)
        let Y = (end.y - start.y)
        let length = sqrt((X * X) + (Y * Y))/2
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(start.x, start.y),
            p(center.x + length * 1.5, start.y + length),
            p(end.x, end.y),
            p(center.x - length * 1.5, start.y + length)
        ]
        
        let path = CGMutablePath()
        path.addLines(between: points)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
}
