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
    public init(radius: CGFloat, style: Style = .smooth) {
        self.init(topLeadingRadius: radius, bottomLeadingRadius: radius, bottomTrailingRadius: radius, topTrailingRadius: radius, style: style)
    }
    
    /// Some corners with optional smoothness and same radius
    public init(radius: CGFloat, corners: Corners, style: Style = .smooth) {
        self.init(
            topLeadingRadius: corners.contains(.topLeading) ? radius : 0,
            bottomLeadingRadius: corners.contains(.bottomLeading) ? radius : 0,
            bottomTrailingRadius: corners.contains(.bottomTrailing) ? radius : 0,
            topTrailingRadius: corners.contains(.topTrailing) ? radius : 0,
            style: style
        )
    }
    /// Different corners with different radii and smoothing
    public init(
        topLeadingRadius: CGFloat = 0,
        bottomLeadingRadius: CGFloat = 0,
        bottomTrailingRadius: CGFloat = 0,
        topTrailingRadius: CGFloat = 0,
        style: Style
    ) {
        let smoothnessValue = style.value
        self.topLeftCorner = CornerAttributes(radius: topLeadingRadius, smoothness: smoothnessValue)
        self.topRightCorner = CornerAttributes(radius: topTrailingRadius, smoothness: smoothnessValue)
        self.bottomLeftCorner = CornerAttributes(radius: bottomLeadingRadius, smoothness: smoothnessValue)
        self.bottomRightCorner = CornerAttributes(radius: bottomTrailingRadius, smoothness: smoothnessValue)
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
