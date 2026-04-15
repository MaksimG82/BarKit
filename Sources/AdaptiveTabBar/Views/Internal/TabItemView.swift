//
//  TabItemView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 16.03.26.
//

import SwiftUI

/// A standalone view representing a single tab item.
struct TabItemView<Item: TabBarItemProtocol>: View {
    
    // MARK: - Environment
        
    /// The unique coordinate space name passed from the parent layout.
    @Environment(\.tabBarSpaceName) private var coordinateSpaceName

    // MARK: - State & Logic

    /// The data model for the tab.
    let item: Item

    /// Indicates if the tab is currently active.
    let isSelected: Bool

    /// The callback to execute on tap.
    let action: () -> Void

    // MARK: - Layout Context

    /// Returns true if the item should adapt to a space-constrained horizontal layout.
    let isVerticalCompact: Bool

    // MARK: - Visual Style

    /// The color applied to the icon and title.
    let itemColor: Color

    /// The typography style for the tab title.
    let textStyle: Font.TextStyle

    /// The transition used for state changes (e.g., selection).
    let animation: Animation?

    // MARK: - Metrics & Spacing

    /// The tab icon size.
    let iconSize: CGSize

    /// The scaling factor applied to the icon when selected.
    let selectedIconScale: CGFloat

    /// The distance between the icon and the title text, regardless of the size class.
    let iconTitleSpacing: CGFloat

    /// The inset applied to the top of the item.
    let topPadding: CGFloat

    /// The inset applied to the bottom of the item.
    let bottomPadding: CGFloat

    // MARK: - Init

    // Initializes a new `TabItemView`.
    //
    // - Parameters:
    //   - item: A data model conforming to ``TabBarItemProtocol``.
    //   - selected: Current selection state.
    //   - config: A configuration object defining the visual style.
    //   - action: An optional closure executed when a tab is tapped (even if already selected).

    init(
        item: Item,
        isSelected: Bool,
        isVerticalCompact: Bool,
        config: TabBarConfiguration,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.isSelected = isSelected
        self.isVerticalCompact = isVerticalCompact
        self.action = action
        itemColor = config.itemColor(isSelected: isSelected)
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
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
        .modifier(TabAccessibilityModifier(item: item, isSelected: isSelected))
        .applyDebugVisuals(color: .blue)
        .capturePreference(
            key: TabItemFrameKey.self,
            in: .named(coordinateSpaceName)
        ) { proxy in
            [item.id: proxy.frame(in: .named(coordinateSpaceName))]
        }
    }

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
