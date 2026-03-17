//
//  TabBarStyle.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 14.03.26.
//

/// Defines the layout and positioning strategy of the tab bar.
public enum TabBarStyle {
    /// A traditional tab bar pinned to the bottom of the screen.
    /// Reflects the classic system appearance standard from iOS 7 through pre-iOS 18 versions.
    case pinned

    /// A modern, floating capsule-shaped tab bar with glass effects.
    /// Inspired by the "spatial" design language introduced in visionOS and adopted as the modern standard in iOS 18 and beyond.
    case floating(FloatingConfiguration)
}
