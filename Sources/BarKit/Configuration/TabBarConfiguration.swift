//
//  TabBarConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

/// A configuration object that defines the visual style, layout, and behavior of the `TabBarView`.
///
/// Use this struct to customize colors, sizes, font textstyle, layout, animations, and accessibility features.
public struct TabBarConfiguration {
    // MARK: - Style Selection

    /// The visual style of the tab bar.
    public var style: TabBarStyle

    // MARK: - Colors

    /// Selected tab content color.
    public var tintColor: Color

    /// Unselected tab content color.
    public var unselectedColor: Color

    /// Tab bar Background color.
    /// - Note: If backgroundMaterial is set, use colors with opacity to create tinted glass effects
    public var backgroundColor: Color

    /// Optional material for the background, providing a blur effect.
    /// If set, it will be rendered behind the background color.
    public var backgroundMaterial: Material?

    // MARK: - Typography

    /// Tab items titles text style.
    public var textStyle: Font.TextStyle

    // MARK: - Icon Sizes

    /// Side length of square icon for regular tab items.
    public var regularIconSideLength: CGFloat

    /// Side length of square icon for prominent tab items.
    public var prominentIconSideLength: CGFloat

    /// The scale factor applied to icons when the bar is in compact height mode (e.g., landscape).
    public var compactIconScale: CGFloat

    /// The scale factor applied to the icon when it is selected.
    public var selectedIconScale: CGFloat

    // MARK: - Layout

    /// Spacing between tab items.
    public var tabSpacing: CGFloat

    /// Spacing between icon and title in a tab item. (Vertical in compact sizeclass)
    public var iconTitleSpacing: CGFloat

    /// The top padding inside a tab item. Also increases the hit-test area.
    public var tabItemTopPadding: CGFloat

    /// The bottom padding inside a tab item. Also increases the hit-test area.
    public var tabItemBottomPadding: CGFloat

    /// The top padding inside a tab item (compact mode). Also increases the hit-test area.
    public var tabItemTopPaddingCompact: CGFloat

    /// The bottom padding inside a tab item (compact mode). Also increases the hit-test area.
    public var tabItemBottomPaddingCompact: CGFloat

    // MARK: - Animation

    /// The animation applied to internal elements (icon and title) during selection changes.
    public var tabItemAnimation: Animation?

    // MARK: - Accecibility

    /// Accessibility label for the entire tab bar.
    public var barAccessibilityLabel: String

    // MARK: - Init

    /// Creates a new configuration with customizable parameters.
    ///
    /// - Parameters:
    ///   - style: The visual style of the tab bar.
    ///   - tintColor: Selected tab content color.
    ///   - unselectedColor: Unselected tab content color.
    ///   - backgroundColor: Tab bar Background color.
    ///   - backgroundMaterial: Optional material for the background, providing a blur effect
    ///   - textStyle: Tab items titles text style.
    ///   - regularIconSideLength: Side length of square icon for regular tab items.
    ///   - prominentIconSideLength: Side length of square icon for prominent tab items.
    ///   - compactIconScale: The scale factor applied to icons when the bar is in compact height mode (e.g., landscape).
    ///   - selectedIconScale: The scale factor applied to the icon when it is selected.
    ///   - tabSpacing: Spacing between tab items.
    ///   - iconTitleSpacing: Spacing between icon and title in a tab item.
    ///   - tabItemTopPadding: Top padding inside tab item. Also increases the hit-test area.
    ///   - tabItemBottomPadding: Bottom padding inside tab item. Also increases the hit-test area.
    ///   - tabItemTopPaddingCompact: Top padding in compact mode. Also increases the hit-test area.
    ///   - tabItemBottomPaddingCompact: Bottom padding in compact mode. Also increases the hit-test area.
    ///   - tabItemAnimation: The animation applied to internal elements (icon and title) during selection changes.
    ///   - barAccessibilityLabel: Accessibility label for the entire tab bar.
    public init(
        style: TabBarStyle = .pinned,
        tintColor: Color = .primary,
        unselectedColor: Color = .secondary,
        backgroundColor: Color = .clear,
        backgroundMaterial: Material? = .ultraThinMaterial,
        textStyle: Font.TextStyle = .caption2,
        regularIconSideLength: CGFloat = 24,
        prominentIconSideLength: CGFloat = 40,
        compactIconScale: CGFloat = 0.8,
        selectedIconScale: CGFloat = 1.1,
        tabSpacing: CGFloat = 0,
        iconTitleSpacing: CGFloat = 4,
        tabItemTopPadding: CGFloat = 4,
        tabItemBottomPadding: CGFloat = 4,
        tabItemTopPaddingCompact: CGFloat = 2,
        tabItemBottomPaddingCompact: CGFloat = 2,
        tabItemAnimation: Animation? = .easeIn(duration: 0.3),
        barAccessibilityLabel: String = "Tab Bar"
    ) {
        self.style = style
        self.tintColor = tintColor
        self.unselectedColor = unselectedColor
        self.backgroundColor = backgroundColor
        self.backgroundMaterial = backgroundMaterial
        self.textStyle = textStyle
        self.regularIconSideLength = regularIconSideLength
        self.prominentIconSideLength = prominentIconSideLength
        self.compactIconScale = compactIconScale
        self.selectedIconScale = selectedIconScale
        self.tabSpacing = tabSpacing
        self.iconTitleSpacing = iconTitleSpacing
        self.tabItemTopPadding = tabItemTopPadding
        self.tabItemBottomPadding = tabItemBottomPadding
        self.tabItemTopPaddingCompact = tabItemTopPaddingCompact
        self.tabItemBottomPaddingCompact = tabItemBottomPaddingCompact
        self.tabItemAnimation = tabItemAnimation
        self.barAccessibilityLabel = barAccessibilityLabel
    }
}

// MARK: - Helping methods and variables

public extension TabBarConfiguration {
    /// Provides access to floating-specific layout settings if the current style is `.floating`.
    var floatingConfig: FloatingConfiguration? {
        get {
            if case let .floating(config) = style { return config }
            return nil
        }
        set {
            if let newValue {
                style = .floating(newValue)
            }
        }
    }

    /// Calculates a fixed height for the bar based on the current configuration and layout.
    func calculatedBarHeight(isVerticalCompact: Bool) -> CGFloat {
        let fontHeight = UIFont.preferredFont(forTextStyle: textStyle.uiTextStyle).lineHeight
        let iconHeight = iconSize(for: .regular, isVerticalCompact: isVerticalCompact).height
        let padding = isVerticalCompact
            ? tabItemTopPaddingCompact + tabItemBottomPaddingCompact
            : tabItemTopPadding + tabItemBottomPadding

        return isVerticalCompact
            ? max(iconHeight, fontHeight) + padding
            : iconHeight + iconTitleSpacing + fontHeight + padding
    }
}

extension TabBarConfiguration {
    /// Returns the color associated with the selection state.
    func itemColor(isSelected: Bool) -> Color {
        isSelected ? tintColor : unselectedColor
    }

    /// Resolves the final icon size considering style and screen orientation.
    func iconSize(for style: TabItemStyle, isVerticalCompact: Bool) -> CGSize {
        let multiplier = isVerticalCompact ? compactIconScale : 1.0
        let side = (style == .regular ? regularIconSideLength : prominentIconSideLength) * multiplier
        return CGSize(width: side, height: side)
    }
}
