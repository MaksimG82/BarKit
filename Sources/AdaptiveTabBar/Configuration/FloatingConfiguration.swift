//
//  FloatingConfiguration.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 14.03.26.
//

import SwiftUI

/// Specific layout parameters for the floating tab bar style.
public struct FloatingConfiguration {
    /// Inset from the leading edge of the screen.
    public var leadingInset: CGFloat = 16

    /// Inset from the trailing edge of the screen.
    public var trailingInset: CGFloat = 16

    /// Distance from the bottom safe area edge.
    /// - Warning: Values below 12 may cause the bar to overlap with the Home Indicator on edge-to-edge displays.
    public var bottomInset: CGFloat = 20

    /// Corner radius of the floating capsule.
    public var cornerRadius: CGFloat = 28

    /// Shadow blur radius to create depth.
    public var shadowRadius: CGFloat = 8
    
    /// Inset applied to the selection indicator inside the capsule.
    public var indicatorPadding: CGFloat = 2

    /// Corner radius of the selection indicator.
    public var indicatorCornerRadius: CGFloat = 24

    /// Configuration for the indicator's scaling (stretching/squeezing) effect.
    /// - Note: If nil, the indicator maintains its size during the transition.
    public var tabSelectionScaleEffect: SelectionScaleEffect?

    /// Animation for moving the indicator between tabs.
    /// - Note:  If nil, the indicator snaps to the new position instantly.
    public var indicatorTransitionAnimation: Animation? = .linear

    // MARK: - Init

    /// Creates a new configuration with customizable parameters.
    ///
    /// - Parameters:
    ///   - leadingInset: Inset from the leading edge of the screen.
    ///   - trailingInset: Inset from the trailing edge of the screen.
    ///   - bottomInset: Distance from the screen's bottom physical edge.
    ///     **Warning**: Values below 12 may cause overlap with the Home Indicator.
    ///   - cornerRadius: Corner radius of the floating capsule.
    ///   - shadowRadius: Shadow blur radius to create depth.
    ///   - tabSelectionScaleEffect: Configuration for the indicator's scaling (stretching/squeezing) effect.
    ///   - indicatorTransitionAnimation: Animation for moving the indicator between tabs.
    ///   - indicatorPadding: Inset applied to the selection indicator inside the capsule.
    ///   - indicatorCornerRadius: Corner radius of the selection indicator.
    public init(
        leadingInset: CGFloat = 16,
        trailingInset: CGFloat = 16,
        bottomInset: CGFloat = 20,
        cornerRadius: CGFloat = 28,
        shadowRadius: CGFloat = 8,
        indicatorPadding: CGFloat = 2,
        indicatorCornerRadius: CGFloat = 24,
        tabSelectionScaleEffect: SelectionScaleEffect? = nil,
        indicatorTransitionAnimation: Animation? = .spring(response: 0.3, dampingFraction: 0.7)
    ) {
        self.leadingInset = leadingInset
        self.trailingInset = trailingInset
        self.bottomInset = bottomInset
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.indicatorPadding = indicatorPadding
        self.indicatorCornerRadius = indicatorCornerRadius
        self.tabSelectionScaleEffect = tabSelectionScaleEffect
        self.indicatorTransitionAnimation = indicatorTransitionAnimation
    }
}

extension FloatingConfiguration: Hashable {}
