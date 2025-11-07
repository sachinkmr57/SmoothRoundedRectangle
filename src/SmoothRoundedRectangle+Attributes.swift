//
//  SmoothRoundedRectangle+Attributes.swift
//  SmoothRoundedRectangle
//
//  Created by Kumar on 06/07/24.
//

import Foundation

public extension SmoothRoundedRectangle {
    
    
    /// A smoothing style that controls how the rounded corners of a `SmoothRoundedRectangle` are computed.
    /// 
    /// Use these styles to choose between perfectly circular corners, Apple’s continuous (squircle-like)
    /// corners, or a custom smoothness factor. The style influences the curvature blend between edges and
    /// corners for a more refined appearance than a simple circular radius.
    /// 
    /// - circular: Produces classic circular arcs at the corners (equivalent to a smoothing factor of 0).
    ///   This matches the traditional rounded rectangle look where each corner is a quarter-circle.
    /// 
    /// - continuous: Matches the system’s continuous corner style (approximately a smoothing factor of 0.7 on iOS),
    ///   yielding a squircle-like shape that visually blends edges and corners more fluidly than pure circular arcs.
    /// 
    /// - smooth(_:): Lets you specify a custom smoothing factor in the range 0...1. Values closer to 0 resemble
    ///   circular corners; values closer to 1 increase the smooth blending between edges and corners. Use this
    ///   to fine-tune the aesthetic of the shape.
    /// 
    /// - smooth: A convenience alias equivalent to `.smooth(1)`, providing the maximum smoothing effect.
    enum Style {
        ///  No smoothing applied.
        ///  - Same as calling `smooth(0)`
        case circular
        /// iOS default smoothness.
        /// - Same as calling `smooth(0.7)`
        case continuous
        /// Custom factor between `0` and `1`, represented as a `Double`.
        /// - Note: Values outside the valid range will be clamped to the nearest bound.
        case smooth(_: Double)

        /// Maximum valid smoothness.
        /// - Same as calling `smooth(1)`
        public static var smooth: Self { .smooth(1) }
    }
    
    /// An option set representing which corners of a SmoothRoundedRectangle should be affected.
    ///
    /// Use `Corners` to selectively apply rounding and smoothing to specific corners of the shape.
    /// You can combine multiple corners using set algebra (e.g., `[.topLeading, .bottomTrailing]`).
    ///
    /// Common presets are provided for convenience:
    /// - `all`: Applies to all four corners.
    /// - `top`: Applies to the top-left and top-right corners.
    /// - `bottom`: Applies to the bottom-left and bottom-right corners.
    /// - `leading`: Applies to the leading-side corners (adapts to layout direction).
    /// - `trailing`: Applies to the trailing-side corners (adapts to layout direction).
    ///
    /// Individual corners:
    /// - `topLeading`: The top-leading corner.
    /// - `topTrailing`: The top-trailing corner.
    /// - `bottomLeading`: The bottom-leading corner.
    /// - `bottomTrailing`: The bottom-trailing corner.
    ///
    /// Conforms to:
    /// - `OptionSet`: Enables combining multiple corners using bitwise operations.
    /// - `Sendable`: Safe to use across concurrency domains.
    struct Corners: OptionSet, Sendable {
        
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let topLeading = Corners(rawValue: 1 << 0)
        public static let topTrailing = Corners(rawValue: 1 << 1)
        public static let bottomLeading = Corners(rawValue: 1 << 2)
        public static let bottomTrailing = Corners(rawValue: 1 << 3)
        
        public static let all: Corners = [.topLeading, .topTrailing, .bottomLeading, .bottomTrailing]
        public static let top: Corners = [.topLeading, .topTrailing]
        public static let bottom: Corners = [.bottomLeading, .bottomTrailing]
        public static let leading: Corners = [.topLeading, .bottomLeading]
        public static let trailing: Corners = [.topTrailing, .bottomTrailing]
    }
}
