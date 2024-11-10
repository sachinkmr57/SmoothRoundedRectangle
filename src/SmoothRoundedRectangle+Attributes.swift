//
//  SmoothRoundedRectangle+Attributes.swift
//  SmoothRoundedRectangle
//
//  Created by Kumar on 06/07/24.
//

import Foundation

public extension SmoothRoundedRectangle {
    
    /// Smoothing factor for corner radius
    enum Smoothness {
        case none   // 0
        case iOS    // 60
        case custom(_: CGFloat) // Custom factor between 0 and 100
    }
    
    struct Corners: OptionSet, Sendable {
        
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let topLeft = Corners(rawValue: 1 << 0)
        public static let topRight = Corners(rawValue: 1 << 1)
        public static let bottomLeft = Corners(rawValue: 1 << 2)
        public static let bottomRight = Corners(rawValue: 1 << 3)
        
        public static let all: Corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        public static let top: Corners = [.topLeft, .topRight]
        public static let bottom: Corners = [.bottomLeft, .bottomRight]
        public static let left: Corners = [.topLeft, .bottomLeft]
        public static let right: Corners = [.topRight, .bottomRight]
    }
}
