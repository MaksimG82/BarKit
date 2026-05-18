//
//  BarItemView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 29.04.26.
//

import SwiftUI

/// A standalone view representing a single bar item.
struct BarItemView<Item: BarItemProtocol>: View {

    // MARK: - Environment

    /// The unique coordinate space name passed from the parent layout.
    @Environment(\.barSpaceName) private var coordinateSpaceName

    // MARK: - Properties

    /// The data model for this item view.
    let item: Item

    /// Indicates if the element is currently selected.
    let isSelected: Bool

    /// The callback to execute on tap.
    let action: () -> Void

    // MARK: - Layout Context

    /// Returns true if the item should adapt to a space-constrained horizontal layout.
    let isVerticalCompact: Bool

    // MARK: - Visual Style

    /// The color applied to the icon and title.
    let itemColor: Color

    /// The typography style for the title.
    let textStyle: Font.TextStyle

    /// The transition used for state changes.
    let animation: Animation?

    // MARK: - Metrics & Spacing

    /// The icon size.
    let iconSize: CGSize

    /// The scaling factor applied to the icon when selected.
    let selectedIconScale: CGFloat

    /// The distance between the icon and the title.
    let iconTitleSpacing: CGFloat

    /// The inset applied to the top of the element.
    let topPadding: CGFloat

    /// The inset applied to the bottom of the element.
    let bottomPadding: CGFloat

    // MARK: - Init

    /// Initializes a new `BarItemView`.
    ///
    /// - Parameters:
    ///   - item: A data model conforming to ``BarItemProtocol``.
    ///   - isSelected: Current selection state.
    ///   - isVerticalCompact: Whether the layout is in compact height mode.
    ///   - config: A configuration object defining the visual style.
    ///   - action: A closure executed when the element is tapped.
    init(
        item: Item,
        isSelected: Bool,
        isVerticalCompact: Bool,
        config: BarConfiguration,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.isSelected = isSelected
        self.isVerticalCompact = isVerticalCompact
        self.action = action

        let itemConfig = config.itemStyles[item.style] ?? config.itemStyles[.regular] ?? ItemConfiguration()
        itemColor = isSelected ? itemConfig.selectedColor : itemConfig.unselectedColor
        selectedIconScale = itemConfig.selectedIconScale
        iconTitleSpacing = itemConfig.iconTitleSpacing
        textStyle = itemConfig.textStyle
        animation = config.itemStateAnimation

        let side = itemConfig.iconSideLength * (isVerticalCompact ? itemConfig.compactIconScale : 1.0)
        iconSize = CGSize(width: side, height: side)

        let insets = isVerticalCompact ? itemConfig.edgeInsetsCompact : itemConfig.edgeInsets
        topPadding = insets.top
        bottomPadding = insets.bottom
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
        .applyDebugVisuals(color: .blue)
        .onTapGesture(perform: action)
        .capturePreference(
            key: BarItemFrameKey.self,
            in: .named(coordinateSpaceName)
        ) { proxy in
            [item.id: proxy.frame(in: .named(coordinateSpaceName))]
        }
        .modifier(BarItemAccessibilityModifier(item: item, isSelected: isSelected))
    }

    // MARK: - Subviews

    private var content: some View {
        Group {
            BarIconView(icon: item.icon)
                .frame(width: iconSize.width, height: iconSize.height)
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
