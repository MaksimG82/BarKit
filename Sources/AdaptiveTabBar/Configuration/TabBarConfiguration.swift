//
//  TabBarConfiguration.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

/// A configuration object that defines the visual style, layout, and behavior of the `TabBarView`.
///
/// Use this struct to customize colors, sizes, font textstyle, animations, and accessibility features.
public struct TabBarConfiguration {
    // MARK: - Colors

    /// Selected tab content color.
    let tintColor: Color

    /// Unselected tab content color.
    let unselectedColor: Color

    /// Tab bar Background color.
    let backgroundColor: Color

    // MARK: - Typography

    /// Tab items titles text style.
    let textStyle: Font.TextStyle

    // MARK: - Icon Sizes

    /// Side length of square icon for regular tab items.
    let regularIconSideLength: CGFloat

    /// Side length of square icon for prominent tab items.
    let prominentIconSideLength: CGFloat

    /// The scale factor applied to icons when the bar is in compact height mode (e.g., landscape).
    let compactIconScale: CGFloat

    // MARK: - Layout

    /// Spacing between tab items.
    let tabSpacing: CGFloat

    /// Spacing between icon and title in a tab item.
    let iconTitleSpacing: CGFloat

    /// Vertical padding inside tab item.
    let tabItemVerticalPadding: CGFloat

    /// Vertical padding inside tab item when the bar is in compact mode.
    let tabItemVerticalPaddingCompact: CGFloat

    // MARK: - Animation

    /// Animation applied to tab selection changes.
    let tabAnimation: Animation?

    /// The scale factor applied to the icon when it is selected.
    let selectedIconScale: CGFloat

    /// The scale factor applied to the icon when it is unselected.
    let unselectedIconScale: CGFloat

    // MARK: - Accecibility

    /// Accessibility label for the entire tab bar.
    let barAccessibilityLabel: String

    /// Creates a new configuration with customizable parameters.
    ///
    /// - Parameters:
    ///   - tintColor: Selected tab content color.
    ///   - unselectedColor: Unselected tab content color.
    ///   - backgroundColor: Tab bar Background color.
    ///   - textStyle: Tab items titles text style.
    ///   - regularIconSideLength: Side length of square icon for regular tab items.
    ///   - prominentIconSideLength: Side length of square icon for prominent tab items.
    ///   - compactIconScale: The scale factor applied to icons when the bar is in compact height mode (e.g., landscape).
    ///   - tabSpacing: Spacing between tab items.
    ///   - iconTitleSpacing: Spacing between icon and title in a tab item.
    ///   - tabItemVerticalPadding: Vertical padding inside tab item.
    ///   - tabItemVerticalPaddingCompact: Vertical padding inside tab item when the bar is in compact mode.
    ///   - tabAnimation: Animation applied to tab selection changes.
    ///   - selectedIconScale: The scale factor applied to the icon when it is selected.
    ///   - unselectedIconScale: The scale factor applied to the icon when it is unselected.
    ///   - barAccessibilityLabel: Accessibility label for the entire tab bar.
    public init(
        tintColor: Color = .primary,
        unselectedColor: Color = .secondary,
        backgroundColor: Color = Color(uiColor: .systemBackground),
        textStyle: Font.TextStyle = .caption2,
        regularIconSideLength: CGFloat = 24,
        prominentIconSideLength: CGFloat = 40,
        compactIconScale: CGFloat = 0.8,
        tabSpacing: CGFloat = 0,
        iconTitleSpacing: CGFloat = 4,
        tabItemVerticalPadding: CGFloat = 4,
        tabItemVerticalPaddingCompact: CGFloat = 2,
        tabAnimation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
        selectedIconScale: CGFloat = 1.1,
        unselectedIconScale: CGFloat = 1,
        barAccessibilityLabel: String = "Tab Bar"
    ) {
        self.tintColor = tintColor
        self.unselectedColor = unselectedColor
        self.backgroundColor = backgroundColor
        self.textStyle = textStyle
        self.regularIconSideLength = regularIconSideLength
        self.prominentIconSideLength = prominentIconSideLength
        self.compactIconScale = compactIconScale
        self.tabSpacing = tabSpacing
        self.iconTitleSpacing = iconTitleSpacing
        self.tabItemVerticalPadding = tabItemVerticalPadding
        self.tabItemVerticalPaddingCompact = tabItemVerticalPaddingCompact
        self.tabAnimation = tabAnimation
        self.selectedIconScale = selectedIconScale
        self.unselectedIconScale = unselectedIconScale
        self.barAccessibilityLabel = barAccessibilityLabel
    }
}

extension TabBarConfiguration {
    /// Calculates total bar height based on current layout and font metrics.
    func barHeight(isCompactHeight: Bool) -> CGFloat {
        let fontLineHeight = UIFont.preferredFont(forTextStyle: textStyle.uiTextStyle).lineHeight
        let baseIconHeight = iconSize(for: .regular, isCompact: isCompactHeight).height

        if isCompactHeight {
            let maxContentHeight = max(baseIconHeight * 0.8, fontLineHeight)
            return maxContentHeight + (tabItemVerticalPadding * 2)
        } else {
            return baseIconHeight + iconTitleSpacing + fontLineHeight + (tabItemVerticalPadding * 2)
        }
    }

    /// Returns the color associated with the selection state.
    func itemColor(isSelected: Bool) -> Color {
        if isSelected {
            tintColor
        } else {
            unselectedColor
        }
    }

    /// Resolves the final icon size considering style and screen orientation.
    func iconSize(for style: TabItemStyle, isCompact: Bool) -> CGSize {
        let multiplier = isCompact ? compactIconScale : 1.0

        switch style {
        case .regular:
            return CGSize(
                width: regularIconSideLength * multiplier,
                height: regularIconSideLength * multiplier
            )
        case .prominent:
            return CGSize(
                width: prominentIconSideLength * multiplier,
                height: prominentIconSideLength * multiplier
            )
        }
    }
}
