//
//  SmoothRoundedRectangle+Helper.swift
//  SmoothRoundedRectangle
//
//  Created by Kumar on 01/07/24.
//

import SwiftUI

typealias CornerAttributes = SmoothRoundedRectangle.SmoothCornerAttributes

extension SmoothRoundedRectangle {

    /// Attributes required for rounding a corner
    struct SmoothCornerAttributes {
        var radius: CGFloat
        var smoothness: CGFloat
        
        // Segment length consumed by rounding and smoothing
        var segmentLength: CGFloat
        
        init(radius: CGFloat, smoothness: CGFloat = 0) {
            self.radius = radius
            self.smoothness = smoothness
            self.segmentLength = radius * (1 + smoothness)
        }
    }
    
    enum Corner {
        case topRight, bottomRight, bottomLeft, topLeft
    }
    
    struct SmoothRectangleAttributes {
        var topRight: CornerAttributes
        var bottomRight: CornerAttributes
        var bottomLeft: CornerAttributes
        var topLeft: CornerAttributes
    }
    
    /// Parameters required for calculation of a smooth corner
    struct SmoothCornerParameters {
        
        // Refernce: Fig 11.1 in https://www.figma.com/blog/desperately-seeking-squircles/
        let a, b, c, d, p, r: CGFloat
        
        // Deviation angle for the line from centre to start of circular arc due to smoothing
        let theta: CGFloat
        
        func unpack() -> (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) {
            (a, b, c, d, p, r, theta)
        }
    }
    
    /// scale down smoothness and corner radius if segment length is more than available
    func normalizeCorners(_ rect: CGRect, rectAttr: SmoothRectangleAttributes) -> SmoothRectangleAttributes {
        let normalizedTopRight = getNormalizedCorner(rectAttr.topRight, in: rect, verticalNeighbour: rectAttr.bottomRight, horizontalNeighbour: rectAttr.topLeft)
        let normalizedBottomRight = getNormalizedCorner(rectAttr.bottomRight, in: rect, verticalNeighbour: rectAttr.topRight, horizontalNeighbour: rectAttr.bottomLeft)
        let normalizedBottomLeft = getNormalizedCorner(rectAttr.bottomLeft, in: rect, verticalNeighbour: rectAttr.topLeft, horizontalNeighbour: rectAttr.bottomRight)
        let normalizedTopLeft = getNormalizedCorner(rectAttr.topLeft, in: rect, verticalNeighbour: rectAttr.bottomLeft, horizontalNeighbour: rectAttr.topRight)
        
        return SmoothRectangleAttributes(
            topRight: normalizedTopRight,
            bottomRight: normalizedBottomRight,
            bottomLeft: normalizedBottomLeft,
            topLeft: normalizedTopLeft
        )
    }
    
    /// Compare a corner with both adjacent corners and compute normalized radius and smoothness
    private func getNormalizedCorner(
        _ base: CornerAttributes,
        in rect: CGRect,
        verticalNeighbour: CornerAttributes,
        horizontalNeighbour: CornerAttributes
    ) -> CornerAttributes {
        let (trR1, trS1) = calculateNormalization(base, horizontalNeighbour, edge: rect.size.width)
        let (trR2, trS2) = calculateNormalization(base, verticalNeighbour, edge: rect.size.height)
        return CornerAttributes(radius: min(trR1, trR2), smoothness: min(trS1, trS2))
    }
    
    /// Compare a corner with adjacent corner and compute normalized radius and smoothness
    private func calculateNormalization(
        _ base: CornerAttributes,
        _ adjacent: CornerAttributes,
        edge: CGFloat
    ) -> (CGFloat, CGFloat) {
        if (base.radius + adjacent.radius) >= edge {
            let scaleFactor = edge / (base.radius + adjacent.radius)
            return (base.radius * scaleFactor, 0)
        } else if (base.segmentLength + adjacent.segmentLength) > edge {
            let scaleFactor = edge / (base.segmentLength + adjacent.segmentLength)
            return (base.radius, (1 + base.smoothness) * scaleFactor - 1)
        } else {
            return (base.radius, base.smoothness)
        }
    }
    
    /// Compute start point, both control points for ramp up and down bezeri curves for all corners
    func computeCurvePoints(cornerAttributes: SmoothCornerParameters, rect: CGRect, corner: Corner) -> [CGPoint] {
        let (a, b, c, d, p, _, _) = cornerAttributes.unpack()

        switch corner {
        case .topRight:
            return [
                CGPoint(x: rect.size.width - (p - a - b - c), y: d),
                CGPoint(x: rect.size.width - (p - a), y: 0),
                CGPoint(x: rect.size.width - (p - a - b), y: 0),
                CGPoint(x: rect.size.width, y: p),
                CGPoint(x: rect.size.width, y: (p - a - b)),
                CGPoint(x: rect.size.width, y: (p - a))
            ]
        case .bottomRight:
            return [
                CGPoint(x: rect.size.width - d, y: rect.size.height - (p - a - b - c)),
                CGPoint(x: rect.size.width, y: rect.size.height - (p - a)),
                CGPoint(x: rect.size.width, y: rect.size.height - (p - a - b)),
                CGPoint(x: rect.size.width - p, y: rect.size.height),
                CGPoint(x: rect.size.width - (p - a - b), y: rect.size.height),
                CGPoint(x: rect.size.width - (p - a), y: rect.size.height)
            ]
        case .bottomLeft:
            return [
                CGPoint(x: (p - a - b - c), y: rect.size.height - d),
                CGPoint(x: (p - a), y: rect.size.height),
                CGPoint(x: (p - a - b), y: rect.size.height),
                CGPoint(x: 0, y: rect.size.height - p),
                CGPoint(x: 0, y: rect.size.height - (p - a - b)),
                CGPoint(x: 0, y: rect.size.height - (p - a))
            ]
        case .topLeft:
            return [
                CGPoint(x: d, y: (p - a - b - c)),
                CGPoint(x: 0, y: (p - a)),
                CGPoint(x: 0, y: (p - a - b)),
                CGPoint(x: p, y: 0),
                CGPoint(x: (p - a - b), y: 0),
                CGPoint(x: (p - a), y: 0)
            ]
        }
    }
    
    /// Compute all parameters required to draw the curves
    func computeParameters(rect: CGRect, cornerAttributes: CornerAttributes) -> SmoothCornerParameters {
        let smoothnessFactor = cornerAttributes.smoothness
        let p = (1 + smoothnessFactor) * cornerAttributes.radius
        
        let angleBeta = 90 * (1 - smoothnessFactor)
        let angleTheta = 45 * smoothnessFactor  // theta = (90 - beta)/2
        
        let c = cornerAttributes.radius * tan(angleTheta / 2 * .pi / 180) * cos(angleTheta * .pi / 180)
        let d = cornerAttributes.radius * tan(angleTheta / 2 * .pi / 180) * sin(angleTheta * .pi / 180)
        // let arcSeg be the segment consumed by corner rounding excluding smoothing
        let arcSeg = sin(angleBeta / 2 * .pi / 180) * cornerAttributes.radius * sqrt(2)
        let b = (p - arcSeg - c - d) / 3
        let a = 2 * b
        
        return SmoothCornerParameters(
            a: a, b: b, c: c, d: d, p: p, r: cornerAttributes.radius, theta: angleTheta
        )
    }
    
    /// Draw the corner path
    func drawCornerPath(
        _ path: inout Path,
        in rect: CGRect,
        cornerAttributes: SmoothCornerAttributes,
        corner: Corner
    ) {
        if cornerAttributes.radius != 0 {
            let attributes = computeParameters(rect: rect, cornerAttributes: cornerAttributes)
            let (_, _, _, _, p, radius, theta) = attributes.unpack()
            let points = computeCurvePoints(cornerAttributes: attributes, rect: rect, corner: corner)
            let startAngle = startAngle(corner)
            path.addLine(to: curveStart(rect, corner: corner, p: p))
            path.addCurve(to: points[0], control1: points[1], control2: points[2])
            path.addArc(
                center: centerPoint(rect, corner: corner, radius: radius),
                radius: radius,
                startAngle: Angle(degrees: Double(startAngle + theta)),
                endAngle: Angle(degrees: Double(startAngle + 90 - theta)),
                clockwise: false
            )
            path.addCurve(to: points[3], control1: points[4], control2: points[5])
        } else {
            path.addLine(to: curveStart(rect, corner: corner, p: 0))
        }
    }
    
    /// Starting point of the ramp up bezier curve
    func curveStart(_ rect: CGRect, corner: Corner, p: CGFloat) -> CGPoint {
        switch corner {
        case .topRight:
            return CGPoint(x: rect.width - p, y: 0)
        case .bottomRight:
            return CGPoint(x: rect.width, y: rect.height - p)
        case .bottomLeft:
            return CGPoint(x: p, y: rect.height)
        case .topLeft:
            return CGPoint(x: 0, y: p)
        }
    }
    
    /// Start angle for the circular arc
    func startAngle(_ corner: Corner) -> CGFloat {
        switch corner {
        case .topRight:
            270
        case .bottomRight:
            0
        case .bottomLeft:
            90
        case .topLeft:
            180
        }
    }
    
    /// Center for the circular arc
    func centerPoint(_ rect: CGRect, corner: Corner, radius: CGFloat) -> CGPoint {
        switch corner {
        case .topRight:
            return CGPoint(x: rect.width - radius, y: radius)
        case .bottomRight:
            return CGPoint(x: rect.width - radius, y: rect.height - radius)
        case .bottomLeft:
            return CGPoint(x: radius, y: rect.height - radius)
        case .topLeft:
            return CGPoint(x: radius, y: radius)
        }
    }
}

extension SmoothRoundedRectangle.Style {
    var value: CGFloat {
        switch self {
        case .circular:
            return 0
        case .continuous:
            return 0.6
        case .smooth(let value):
            return value
        }
    }
}
