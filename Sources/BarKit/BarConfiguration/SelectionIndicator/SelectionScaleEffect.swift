//
//  SelectionScaleEffect.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.04.26.
//

import SwiftUI

/// Defines the scaling effect for the selection indicator during tab transitions.
public struct SelectionScaleEffect {

    /// Animation applied specifically to the scaling effect.
    public var scalingAnimation: BarAnimation? = .parameters(.init(type: .easeInOut, duration: 0.15))

    /// Horizontal scale factor during the transition.
    public var xScale: CGFloat = 1.2

    /// Vertical scale factor during the transition.
    public var yScale: CGFloat = 1.2

    /// The time to wait before resetting the animation state.
    public var duration: Double = 0.2

    public init(
        scalingAnimation: BarAnimation = .parameters(.init(type: .easeInOut, duration: 0.15)),
        xScale: CGFloat = 1.2,
        yScale: CGFloat = 1.2,
        duration: Double = 0.2
    ) {
        self.scalingAnimation = scalingAnimation
        self.xScale = xScale
        self.yScale = yScale
        self.duration = duration
    }
}

// MARK: - Helpers

public extension SelectionScaleEffect {
 
    /// Resolves the animation for use in view modifiers.
    var resolvedAnimation: Animation? {
        scalingAnimation?.animation
    }
}
