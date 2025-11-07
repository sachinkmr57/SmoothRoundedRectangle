//
//  SmoothRoundedRectangle.swift
//  SmoothRoundedRectangle
//
//  Created by Kumar on 01/07/24.
//

import SwiftUI

/// A customizable SwiftUI shape that draws a rounded rectangle with optional "smooth" corner transitions.
///
/// SmoothRoundedRectangle allows you to specify individual corner radii while also applying a smoothing style
/// to produce visually pleasing, continuous corner curves. It conforms to `InsettableShape`, enabling
/// stroke insetting and precise layout control in SwiftUI.
///
/// Usage examples:
/// - Uniform radius on all corners:
///   ```swift
///   SmoothRoundedRectangle(radius: 16)
///       .fill(.blue)
///   ```
/// - Apply to specific corners:
///   ```swift
///   SmoothRoundedRectangle(radius: 20, corners: [.topLeading, .bottomTrailing])
///       .stroke(.red, lineWidth: 2)
///   ```
/// - Different radii per corner with a chosen style:
///   ```swift
///   SmoothRoundedRectangle(
///       topLeadingRadius: 24,
///       bottomLeadingRadius: 12,
///       bottomTrailingRadius: 32,
///       topTrailingRadius: 8,
///       style: .smooth
///   )
///   .fill(.green)
///   ```
///
/// Features:
/// - Supports left-to-right and right-to-left layout directions; leading/trailing-aware initializers will
///   automatically map to the correct physical corners.
/// - Conforms to `InsettableShape` so you can use `.inset(by:)` implicitly via `strokeBorder` and related APIs.
/// - Provides multiple convenience initializers for uniform radii, selected corners, or fully customized
///   per-corner radii with a smoothing `Style`.
///
/// Initializers:
/// - `init(radius:style:)`
///   Creates a rectangle with the same radius applied to all corners, using the given smoothing style.
/// - `init(radius:corners:style:)`
///   Applies the same radius to a subset of corners specified by `Corners`, using the given smoothing style.
/// - `init(topLeadingRadius:bottomLeadingRadius:bottomTrailingRadius:topTrailingRadius:style:)`
///   Allows fine-grained control of each corner radius with a chosen smoothing `Style`.
///
/// Notes:
/// - The effective geometry is adjusted by any inset amount to support accurate stroked borders.
/// - The actual corner drawing and normalization rely on associated helper types and functions
///   (e.g., `CornerAttributes`, `Style`, `Corners`, `SmoothRectangleAttributes`, `normalizeCorners`, `drawCornerPath`)
///   which define how smoothing is computed and applied to each corner.
///
/// Platform:
/// - Designed for SwiftUI on Apple platforms (iOS, iPadOS, macOS, watchOS, visionOS).
public struct SmoothRoundedRectangle: InsettableShape {
    let topLeftCorner: CornerAttributes
    let topRightCorner: CornerAttributes
    let bottomLeftCorner: CornerAttributes
    let bottomRightCorner: CornerAttributes

    var insetAmount = 0.0

    // MARK: - Initializers
    
    /// Creates a SmoothRoundedRectangle with the same corner radius applied to all four corners,
    /// using the provided smoothing style.
    ///
    /// - Parameters:
    ///   - radius: The corner radius to apply uniformly to all corners, in points. Values less than or equal to zero result in square corners.
    ///   - style: The smoothing style that controls how the corner transitions are drawn. Use `.smooth` for continuous, visually pleasing curves or other styles as available.
    /// - Discussion:
    ///   This initializer is the most convenient way to produce a rounded rectangle with uniform corner radii.
    ///   The smoothing style affects the curvature near the corners to create more natural transitions than
    ///   standard circular arcs. The shape conforms to `InsettableShape`, so borders drawn with `strokeBorder`
    ///   will respect the correct inset geometry.
    /// - SeeAlso: `init(radius:corners:style:)`, `init(topLeadingRadius:bottomLeadingRadius:bottomTrailingRadius:topTrailingRadius:style:)`
    public init(radius: CGFloat, style: Style = .smooth) {
        self.init(topLeadingRadius: radius, bottomLeadingRadius: radius, bottomTrailingRadius: radius, topTrailingRadius: radius, style: style)
    }
    
    
    /// Creates a SmoothRoundedRectangle that applies the same corner radius to a specified subset of corners,
    /// using the provided smoothing style.
    ///
    /// - Parameters:
    ///   - radius: The corner radius, in points, to apply to the selected corners. Values less than or equal to zero
    ///             result in square corners for those selections.
    ///   - corners: A set of corners to which the radius should be applied. Use values such as
    ///              `[.topLeading, .bottomTrailing]` or `.all`. Leading/trailing are automatically mapped
    ///              based on the current layout direction (left-to-right or right-to-left).
    ///   - style: The smoothing style that controls the curvature transition at the rounded corners. Defaults to `.smooth`.
    ///
    /// - Discussion:
    ///   This initializer is useful when you want to round only certain corners while leaving others square.
    ///   The `style` parameter governs how the transition into each rounded corner is drawn, producing more
    ///   continuous and visually pleasing shapes than basic circular arcs. Because this shape conforms to
    ///   `InsettableShape`, borders drawn with `strokeBorder` will respect the correct inset geometry.
    ///
    /// - SeeAlso: `init(radius:style:)`, `init(topLeadingRadius:bottomLeadingRadius:bottomTrailingRadius:topTrailingRadius:style:)`
    public init(radius: CGFloat, corners: Corners, style: Style = .smooth) {
        self.init(
            topLeadingRadius: corners.contains(.topLeading) ? radius : 0,
            bottomLeadingRadius: corners.contains(.bottomLeading) ? radius : 0,
            bottomTrailingRadius: corners.contains(.bottomTrailing) ? radius : 0,
            topTrailingRadius: corners.contains(.topTrailing) ? radius : 0,
            style: style
        )
    }
    
    
    /// Creates a SmoothRoundedRectangle with individually configurable corner radii and a chosen smoothing style.
    ///
    /// - Parameters:
    ///   - topLeadingRadius: The radius, in points, for the top-leading corner. Leading/trailing are automatically
    ///     resolved based on the current layout direction (left-to-right or right-to-left). Values ≤ 0 produce a square corner.
    ///   - bottomLeadingRadius: The radius, in points, for the bottom-leading corner. Leading/trailing are automatically
    ///     resolved based on the current layout direction. Values ≤ 0 produce a square corner.
    ///   - bottomTrailingRadius: The radius, in points, for the bottom-trailing corner. Leading/trailing are automatically
    ///     resolved based on the current layout direction. Values ≤ 0 produce a square corner.
    ///   - topTrailingRadius: The radius, in points, for the top-trailing corner. Leading/trailing are automatically
    ///     resolved based on the current layout direction. Values ≤ 0 produce a square corner.
    ///   - style: The smoothing style that determines how the corner transitions are drawn. Use `.smooth` for
    ///     continuous, visually pleasing curves or another available style.
    ///
    /// - Discussion:
    ///   Use this initializer when you need fine-grained control of each corner’s radius. The provided `style`
    ///   governs how the transitions into and out of each corner are shaped, yielding more natural, continuous
    ///   curves than simple circular arcs. The shape conforms to `InsettableShape`, so borders drawn with
    ///   `strokeBorder` will respect the correct inset geometry. This initializer also respects the environment’s
    ///   layout direction, mapping leading/trailing radii to their corresponding physical corners.
    ///
    /// - SeeAlso:
    ///   - `init(radius:style:)` for a uniform radius on all corners
    ///   - `init(radius:corners:style:)` for applying the same radius to a selected subset of corners
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

    /// Insets the shape’s path by the specified amount and returns a new shape representing that inset geometry.
    ///
    /// - Parameter amount: The number of points by which to inset the shape on all sides. Positive values
    ///   shrink the shape inward; negative values expand it outward.
    /// - Returns: A new shape conforming to `InsettableShape` whose drawing and layout calculations are offset
    ///   by the given inset amount. This enables accurate stroked borders when using APIs like `strokeBorder`,
    ///   ensuring the stroke is drawn within the shape’s bounds.
    /// - Discussion:
    ///   The inset amount is accumulated each time this method is called, allowing multiple inset operations
    ///   to compose. The inset is applied to the rectangle used to compute the rounded and smoothed corners,
    ///   so both fill and stroke paths reflect the adjusted geometry.
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}
