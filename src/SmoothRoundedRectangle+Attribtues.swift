//
//  SmoothRoundedRectangle+Attribtues.swift
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
        
        static let topLeft = Corners(rawValue: 1 << 0)
        static let topRight = Corners(rawValue: 1 << 1)
        static let bottomLeft = Corners(rawValue: 1 << 2)
        static let bottomRight = Corners(rawValue: 1 << 3)
        
        static let all: Corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        static let top: Corners = [.topLeft, .topRight]
        static let bottom: Corners = [.bottomLeft, .bottomRight]
        static let left: Corners = [.topLeft, .bottomLeft]
        static let right: Corners = [.topRight, .bottomRight]
    }
}
