//
//  SmoothRoundedRectangle.swift
//  SmoothRoundedRectangle
//
//  Created by Kumar on 01/07/24.
//

import SwiftUI

public struct SmoothRoundedRectangle: InsettableShape {

    let topLeftCorner: CornerAttributes
    let topRightCorner: CornerAttributes
    let bottomLeftCorner: CornerAttributes
    let bottomRightCorner: CornerAttributes

    var insetAmount = 0.0

    // MARK: - Initializers
    
    /// Standard all corners with optional smoothness and same radius
    public init(radius: CGFloat, smoothness: Smoothness = .none) {
        self.init(topLeft: radius, topRight: radius, bottomRight: radius, bottomLeft: radius, smoothness: smoothness)
    }
    
    /// Some corners with optional smoothness and same radius
    public init(radius: CGFloat, corners: Corners, smoothness: Smoothness = .none) {
        self.init(
            topLeft: corners.contains(.topLeft) ? radius : 0,
            topRight: corners.contains(.topRight) ? radius : 0,
            bottomRight: corners.contains(.bottomRight) ? radius : 0,
            bottomLeft: corners.contains(.bottomLeft) ? radius : 0,
            smoothness: smoothness
        )
    }
    
    /// Different corners with different radii and smoothing
    public init(
        topLeft: CGFloat,
        topRight: CGFloat,
        bottomRight: CGFloat,
        bottomLeft: CGFloat,
        smoothness: Smoothness
    ) {
        let smoothnessValue = smoothness.value
        self.topLeftCorner = CornerAttributes(radius: topLeft, smoothness: smoothnessValue)
        self.topRightCorner = CornerAttributes(radius: topRight, smoothness: smoothnessValue)
        self.bottomRightCorner = CornerAttributes(radius: bottomRight, smoothness: smoothnessValue)
        self.bottomLeftCorner = CornerAttributes(radius: bottomLeft, smoothness: smoothnessValue)
    }
    
    // MARK: - Path
    
    public func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)

        let normRect = normalizeCorners(insetRect, rectAttr: SmoothRectangleAttributes(
            topRight: topRightCorner,
            bottomRight: bottomRightCorner,
            bottomLeft: bottomLeftCorner,
            topLeft: topLeftCorner)
        )
        
        var path = Path()
        path.move(to: CGPoint(x: normRect.topLeft.segmentLength, y: 0))
        
        drawCornerPath(&path, in: insetRect, cornerAttributes: normRect.topRight, corner: .topRight)
        drawCornerPath(&path, in: insetRect, cornerAttributes: normRect.bottomRight, corner: .bottomRight)
        drawCornerPath(&path, in: insetRect, cornerAttributes: normRect.bottomLeft, corner: .bottomLeft)
        drawCornerPath(&path, in: insetRect, cornerAttributes: normRect.topLeft, corner: .topLeft)
        path.closeSubpath()

        return path.offsetBy(dx: insetAmount, dy: insetAmount)
    }

    // MARK: - Insettable

    public func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}
