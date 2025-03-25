//
//  SmoothRoundedRectangle.swift
//  SmoothRoundedRectangle
//
//  Created by Kumar on 01/07/24.
//

import SwiftUI

public struct SmoothRoundedRectangle: InsettableShape {
    
    @Environment(\.layoutDirection) var layoutDirection
    
    var topLeftCorner: CornerAttributes = .init(radius: 0)
    var topRightCorner: CornerAttributes = .init(radius: 0)
    var bottomLeftCorner: CornerAttributes = .init(radius: 0)
    var bottomRightCorner: CornerAttributes = .init(radius: 0)

    var insetAmount = 0.0

    // MARK: - Initializers
    
    /// Standard all corners with optional smoothness and same radius
    public init(radius: CGFloat, smoothness: Smoothness = .none) {
        self.init(topLeadingRadius: radius, bottomLeadingRadius: radius, bottomTrailingRadius: radius, topTrailingRadius: radius, smoothness: smoothness)
    }
    
    /// Some corners with optional smoothness and same radius
    public init(radius: CGFloat, corners: Corners, smoothness: Smoothness = .none) {
        self.init(
            topLeadingRadius: corners.contains(.topLeading) ? radius : 0,
            bottomLeadingRadius: corners.contains(.bottomLeading) ? radius : 0,
            bottomTrailingRadius: corners.contains(.bottomTrailing) ? radius : 0,
            topTrailingRadius: corners.contains(.topTrailing) ? radius : 0,
            smoothness: smoothness
        )
    }
    /// Different corners with different radii and smoothing
    public init(
        topLeadingRadius: CGFloat = 0,
        bottomLeadingRadius: CGFloat = 0,
        bottomTrailingRadius: CGFloat = 0,
        topTrailingRadius: CGFloat = 0,
        smoothness: Smoothness
    ) {
        let smoothnessValue = smoothness.value
        self.topLeftCorner = CornerAttributes(radius: getLTRCorner(topLeadingRadius, topTrailingRadius), smoothness: smoothnessValue)
        self.topRightCorner = CornerAttributes(radius: getLTRCorner(topTrailingRadius, topLeadingRadius), smoothness: smoothnessValue)
        self.bottomLeftCorner = CornerAttributes(radius: getLTRCorner(bottomLeadingRadius, bottomTrailingRadius), smoothness: smoothnessValue)
        self.bottomRightCorner = CornerAttributes(radius: getLTRCorner(bottomTrailingRadius, bottomLeadingRadius), smoothness: smoothnessValue)
    }
    
    private func getLTRCorner(_ a: CGFloat, _ b: CGFloat) ->  CGFloat {
        layoutDirection == .rightToLeft ? b : a
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
