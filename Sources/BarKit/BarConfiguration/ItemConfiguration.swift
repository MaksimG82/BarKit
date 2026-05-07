//
//  ItemConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 29.04.26.
//

import SwiftUI

/// Defines the visual appearance of a single bar item in isolation.
public struct ItemConfiguration {

    /// The color applied to the icon and title of a selected item.
    public var selectedColor: Color

    /// The color applied to the icon and title of an unselected item.
    public var unselectedColor: Color

    /// The typography style for the item title.
    public var textStyle: Font.TextStyle

    /// Side length of the square icon.
    public var iconSideLength: CGFloat

    /// The scale factor applied to the icon when the item is selected.
    public var selectedIconScale: CGFloat

    /// The scale factor applied to the icon in compact height mode (e.g., landscape).
    public var compactIconScale: CGFloat

    /// Spacing between the icon and title within the item.
    public var iconTitleSpacing: CGFloat
    
    /// Padding applied inside the item view in regular height mode.
    public var edgeInsets: EdgeInsets

    /// Padding applied inside the item view in compact height mode (e.g., landscape).
    public var edgeInsetsCompact: EdgeInsets

    /// Creates a new item configuration.
    ///
    /// - Parameters:
    ///   - selectedColor: The color applied to a selected item's icon and title.
    ///   - unselectedColor: The color applied to an unselected item's icon and title.
    ///   - textStyle: The typography style for the item title.
    ///   - iconSideLength: Side length of the square icon.
    ///   - selectedIconScale: Scale factor applied to the icon when selected.
    ///   - compactIconScale: Scale factor applied to the icon in compact height mode.
    ///   - iconTitleSpacing: Spacing between the icon and title.
    ///   - edgeInsets: Padding applied inside the item view in regular height mode.
    ///   - edgeInsetsCompact: Padding applied inside the item view in compact height mode (e.g., landscape).
    public init(
        selectedColor: Color = .primary,
        unselectedColor: Color = .secondary,
        textStyle: Font.TextStyle = .caption2,
        iconSideLength: CGFloat = 24,
        selectedIconScale: CGFloat = 1.1,
        compactIconScale: CGFloat = 0.8,
        iconTitleSpacing: CGFloat = 4,
        edgeInsets: EdgeInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0),
        edgeInsetsCompact: EdgeInsets = .init(top: 4, leading: 0, bottom: 4, trailing: 0),
    ) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.textStyle = textStyle
        self.iconSideLength = iconSideLength
        self.selectedIconScale = selectedIconScale
        self.compactIconScale = compactIconScale
        self.iconTitleSpacing = iconTitleSpacing
        self.edgeInsets = edgeInsets
        self.edgeInsetsCompact = edgeInsetsCompact
    }
}

public extension ItemConfiguration {

    /// Calculates the content height of an item excluding edge insets.
    /// In compact mode, icon and title are arranged horizontally — height is the max of the two.
    /// In regular mode, icon and title are stacked vertically — height is the sum plus spacing.
    func itemContentHeight(isVerticalCompact: Bool) -> CGFloat {
        let scale = isVerticalCompact ? compactIconScale : 1.0
        let iconHeight = iconSideLength * scale
        let fontHeight = UIFont.preferredFont(forTextStyle: textStyle.uiTextStyle).lineHeight

        return isVerticalCompact
            ? max(iconHeight, fontHeight)
            : iconHeight + iconTitleSpacing + fontHeight
    }
}
