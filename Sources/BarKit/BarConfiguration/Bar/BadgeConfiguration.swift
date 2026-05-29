//
//  BadgeConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 28.05.26.
//

import SwiftUI

/// Defines the visual appearance of a badge overlay on a bar item.
public struct BadgeConfiguration: Equatable, Sendable {
    
    /// The alignment of the badge relative to the icon.
    public var alignment: Alignment

    /// Horizontal offset applied to the badge after alignment.
    public var offsetX: CGFloat

    /// Vertical offset applied to the badge after alignment.
    public var offsetY: CGFloat

    /// The background color of the badge.
    public var backgroundColor: Color

    /// The foreground color applied to the badge text or dot.
    public var foregroundColor: Color

    /// The typography style for `.count` and `.label` badges.
    public var textStyle: Font.TextStyle

    /// Horizontal padding inside `.count` and `.label` badges.
    public var horizontalPadding: CGFloat

    /// Vertical padding inside `.count` and `.label` badges.
    public var verticalPadding: CGFloat

    /// The diameter of the `.dot` badge.
    public var dotDiameter: CGFloat

    /// Creates a new `BadgeConfiguration`.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the badge relative to the icon.
    ///   - offsetX: Horizontal offset applied to the badge after alignment.
    ///   - offsetY: Vertical offset applied to the badge after alignment.
    ///   - backgroundColor: The background color of the badge.
    ///   - foregroundColor: The foreground color applied to the badge text or dot.
    ///   - textStyle: The typography style for `.count` and `.label` badges.
    ///   - horizontalPadding: Horizontal padding inside `.count` and `.label` badges.
    ///   - verticalPadding: Vertical padding inside `.count` and `.label` badges.
    ///   - dotDiameter: The diameter of the `.dot` badge.
    public init(
        alignment: Alignment = .topTrailing,
        offsetX: CGFloat = 4,
        offsetY: CGFloat = -2,
        backgroundColor: Color = .red,
        foregroundColor: Color = .white,
        textStyle: Font.TextStyle = .caption2,
        horizontalPadding: CGFloat = 4,
        verticalPadding: CGFloat = 2,
        dotDiameter: CGFloat = 8
    ) {
        self.alignment = alignment
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.textStyle = textStyle
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.dotDiameter = dotDiameter
    }
}
