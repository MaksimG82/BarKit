//
//  ShadowConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 29.04.26.

import SwiftUI

/// Defines the shadow appearance of the bar capsule.
public struct ShadowConfiguration {
    /// The shadow color.
    public var color: Color
    /// The shadow blur radius.
    public var radius: CGFloat
    /// The horizontal offset of the shadow.
    public var x: CGFloat
    /// The vertical offset of the shadow.
    public var y: CGFloat

    /// Creates a new shadow configuration.
    ///
    /// - Parameters:
    ///   - color: The shadow color.
    ///   - radius: The shadow blur radius.
    ///   - x: The horizontal offset of the shadow.
    ///   - y: The vertical offset of the shadow.
    public init(
        color: Color = .black.opacity(0.2),
        radius: CGFloat = 8,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}
