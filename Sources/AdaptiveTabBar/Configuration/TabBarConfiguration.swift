//
//  TabBarConfiguration.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

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

    // MARK: - Layout

    /// Spacing between icon and title in a tab item.
    let iconTitleSpacing: CGFloat

    /// Vertical padding inside tab item.
    let tabItemVerticalPadding: CGFloat

    // MARK: - Animation

    /// Animation applied to tab selection changes.
    let tabAnimation: Animation?

    // MARK: - Accecibility

    /// Accessibility label for the entire tab bar.
    let barAccessibilityLabel: String

    public init(
        tintColor: Color = .primary,
        unselectedColor: Color = .secondary,
        backgroundColor: Color = Color(uiColor: .systemBackground),
//        backgroundColor: Color = Color(uiColor: .red.withAlphaComponent(0.4)),
        textStyle: Font.TextStyle = .caption2,
        regularIconSideLength: CGFloat = 24,
        prominentIconSideLength: CGFloat = 40,
        iconTitleSpacing: CGFloat = 4,
        tabItemVerticalPadding: CGFloat = 2,
        tabAnimation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
        barAccessibilityLabel: String = "Tab Bar"
    ) {
        self.tintColor = tintColor
        self.unselectedColor = unselectedColor
        self.backgroundColor = backgroundColor
        self.textStyle = textStyle
        self.regularIconSideLength = regularIconSideLength
        self.prominentIconSideLength = prominentIconSideLength
        self.iconTitleSpacing = iconTitleSpacing
        self.tabItemVerticalPadding = tabItemVerticalPadding
        self.tabAnimation = tabAnimation
        self.barAccessibilityLabel = barAccessibilityLabel
    }
}

extension TabBarConfiguration {

    func iconSize(for style: TabItemStyle) -> CGSize {
        let side = (style == .prominent) ? prominentIconSideLength : regularIconSideLength
        return CGSize(width: side, height: side)
    }

    func barHeight(isCompactHeight: Bool) -> CGFloat {
            let fontLineHeight = UIFont.preferredFont(forTextStyle: textStyle.uiTextStyle).lineHeight
            let baseIconHeight = iconSize(for: .regular).height

            if isCompactHeight {
                let maxContentHeight = max(baseIconHeight * 0.8, fontLineHeight)
                return maxContentHeight + (tabItemVerticalPadding * 2)
            } else {
                return baseIconHeight + iconTitleSpacing + fontLineHeight + (tabItemVerticalPadding * 2)
            }
        }
}
