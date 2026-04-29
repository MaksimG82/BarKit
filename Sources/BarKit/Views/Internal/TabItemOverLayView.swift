//
//  TabItemOverLayView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 20.04.26.
//

import SwiftUI

/// A purely visual, non-interactive layer that mirrors the layout of `TabItemView`.
/// Used as the upper layer in the dual-render stack for the selection color effect.
struct TabItemOverlayView<Item: TabBarItemProtocol>: View {

    // MARK: - Properties

    /// The data model for the tab.
    let item: Item

    /// Returns true if the item should adapt to a space-constrained horizontal layout.
    let isVerticalCompact: Bool

    // MARK: - Visual Style

    /// The color applied to the icon and title.
    let itemColor: Color

    /// The typography style for the tab title.
    let textStyle: Font.TextStyle

    // MARK: - Metrics & Spacing

    /// The tab icon size.
    let iconSize: CGSize

    /// The scaling factor applied to the icon when selected.
    let selectedIconScale: CGFloat

    /// Indicates if the tab is currently active.
    let isSelected: Bool

    /// The distance between the icon and the title text.
    let iconTitleSpacing: CGFloat

    /// The inset applied to the top of the item.
    let topPadding: CGFloat

    /// The inset applied to the bottom of the item.
    let bottomPadding: CGFloat

    /// The transition used for state changes.
    let animation: Animation?

    // MARK: - Init

    // Initializes a new `TabItemOverlayView`.
    //
    // - Parameters:
    //   - item: A data model conforming to ``TabBarItemProtocol``.
    //   - isSelected: Current selection state.
    //   - isVerticalCompact: Whether the layout is horizontally compact.
    //   - itemColor: The color to apply to icon and title.
    //   - config: A configuration object defining the visual style.

    init(
        item: Item,
        isSelected: Bool,
        isVerticalCompact: Bool,
        itemColor: Color,
        config: TabBarConfiguration
    ) {
        self.item = item
        self.isSelected = isSelected
        self.isVerticalCompact = isVerticalCompact
        self.itemColor = itemColor
        iconSize = config.iconSize(for: item.style, isVerticalCompact: isVerticalCompact)
        selectedIconScale = config.selectedIconScale
        iconTitleSpacing = config.iconTitleSpacing
        textStyle = config.textStyle
        animation = config.tabItemAnimation
        topPadding = isVerticalCompact ? config.tabItemTopPaddingCompact : config.tabItemTopPadding
        bottomPadding = isVerticalCompact ? config.tabItemBottomPaddingCompact : config.tabItemBottomPadding
    }

    // MARK: - Body

    var body: some View {
        Group {
            if isVerticalCompact {
                HStack(spacing: iconTitleSpacing) { content }
            } else {
                VStack(spacing: iconTitleSpacing) { content }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .allowsHitTesting(false)
    }

    // MARK: - Subviews

    private var content: some View {
        Group {
            TabIconView(icon: item.icon)
                .frame(size: iconSize)
                .foregroundStyle(itemColor)
                .scaleEffect(isSelected ? selectedIconScale : 1.0)

            Text(item.title)
                .font(.system(textStyle))
                .foregroundStyle(itemColor)
                .lineLimit(1)
        }
        .animation(animation, value: isSelected)
    }
}
