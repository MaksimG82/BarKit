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
    public var bottomInset: CGFloat = 12

    /// Corner radius of the floating capsule.
    public var cornerRadius: CGFloat = 28

    /// Shadow blur radius to create depth.
    public var shadowRadius: CGFloat = 8

    public init() {}
}
