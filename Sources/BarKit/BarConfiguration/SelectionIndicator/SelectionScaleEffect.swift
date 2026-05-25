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
    public var scalingAnimation: BarAnimation?

    /// Horizontal scale factor during the transition.
    public var xScale: CGFloat

    /// Vertical scale factor during the transition.
    public var yScale: CGFloat

    /// Total duration of the scale cycle in seconds — scale up and reset combined.
    public var duration: Double

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

    /// Resolves the animation for use in view modifiers.
    public var resolvedAnimation: Animation? {
        scalingAnimation?.animation
    }
}
