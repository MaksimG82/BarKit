//
//  FloatingConfiguration.swift
//  BarKit
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
    
    /// The color applied to icon and title within the selection indicator bounds.
    /// Defaults to white for contrast against the indicator background.
    public var activeItemColor: Color = .blue

    /// Configuration for the indicator's scaling (stretching/squeezing) effect.
    /// - Note: If nil, the indicator maintains its size during the transition.
    public var tabSelectionScaleEffect: SelectionScaleEffect?

    /// Animation for moving the indicator between tabs.
    /// - Note:  If nil, the indicator snaps to the new position instantly.
    public var indicatorTransitionAnimation: Animation? = .linear
    
    // MARK: - Lens Effect

    /// Width in points of the zone near the boundary where lens distortion is applied. Typical range 2.0–12.0.
    public var refractionZoneWidth: CGFloat = 12.0

    /// Width in points of the zone near the boundary where chromatic aberration is applied. Typical range 1.0–6.0.
    public var aberrationZoneWidth: CGFloat = 8.0

    /// Maximum pixel displacement at the indicator boundary. Typical range 1.5–5.0.
    public var refractionStrength: CGFloat = 2.0

    /// RGB channel separation in pixels at the indicator boundary. Typical range 1.0–4.0.
    public var aberrationStrength: CGFloat = 4.0

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
    ///   - indicatorPadding: Inset applied to the selection indicator inside the capsule.
    ///   - indicatorCornerRadius: Corner radius of the selection indicator.
    ///   - activeItemColor: The color applied to icon and title within the selection indicator bounds.
    ///   - tabSelectionScaleEffect: Configuration for the indicator's scaling (stretching/squeezing) effect.
    ///   - indicatorTransitionAnimation: Animation for moving the indicator between tabs.
    ///   - refractionZoneWidth: Width in points of the zone near the boundary where lens distortion is applied. Typical range 2.0–12.0.
    ///   - aberrationZoneWidth: Width in points of the zone near the boundary where chromatic aberration is applied. Typical range 1.0–6.0.
    ///   - refractionStrength: Maximum pixel displacement at the indicator boundary. Typical range 1.5–5.0.
    ///   - aberrationStrength: RGB channel separation in pixels at the indicator boundary. Typical range 1.0–4.0.
    public init(
        leadingInset: CGFloat = 16,
        trailingInset: CGFloat = 16,
        bottomInset: CGFloat = 20,
        cornerRadius: CGFloat = 28,
        shadowRadius: CGFloat = 8,
        indicatorPadding: CGFloat = 2,
        indicatorCornerRadius: CGFloat = 24,
        activeItemColor: Color = .blue,
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
