//
//  SelectionScaleEffect.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.04.26.
//

import SwiftUI

/// Defines the scaling effect for the selection indicator during tab transitions.
public struct SelectionScaleEffect: Hashable {
    /// Animation applied specifically to the scaling effect (e.g., easeInOut).
    public var animation: Animation = .easeInOut(duration: 0.15)

    /// Horizontal scale factor during the transition (e.g., 1.2 for stretching).
    public var xScale: CGFloat = 1.2

    /// Vertical scale factor during the transition (e.g., 0.9 for squeezing).
    public var yScale: CGFloat = 1.2

    /// The time to wait before resetting the animation state.
    public var duration: Double = 0.2

    /// Creates a scaling effect configuration.
    ///
    /// - Parameters:
    ///   - animation: Animation for the scaling phase (e.g., elastic stretch).
    ///   - xScale: Horizontal scale multiplier (e.g., > 1.0 for stretching).
    ///   - yScale: Vertical scale multiplier (e.g., < 1.0 for squeezing).
    ///   - duration: The delay in seconds before the animation state resets.
    public init(
        animation: Animation = .easeInOut(duration: 0.15),
        xScale: CGFloat = 1.2,
        yScale: CGFloat = 1.2,
        duration: Double = 0.2
    ) {
        self.animation = animation
        self.xScale = xScale
        self.yScale = yScale
        self.duration = duration
    }
}
