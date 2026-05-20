//
//  BarItemOverlayView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 29.04.26.
//

import SwiftUI

/// A purely visual, non-interactive layer that mirrors the layout of `BarItemView`.
/// Used as the upper layer in the dual-render stack for the selection color effect.
struct BarItemOverlayView<Item: BarItemProtocol>: View {

    // MARK: - Properties

    /// The data model for this item view.
    let item: Item

    /// Indicates if the element is currently selected.
    let isSelected: Bool

    // MARK: - Layout Context
    
    /// Returns true if the item should adapt to a space-constrained horizontal layout.
    let isVerticalCompact: Bool
    
    /// The layout axis of the parent bar, used to determine item sizing behaviour.
    let axis: BarConfiguration.Axis
    
    /// The icon-title arrangement inherited from `BarConfiguration`.
    /// `nil` defers resolution to `resolvedContentAxis`.
    let itemContentAxis: ItemContentAxis?
    
    /// The alignment of icon and title within the item along the cross-axis of the content stack.
    let itemContentAlignment: BarItemAlignment

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

    /// The insets applied inside the item view.
    let edgeInsets: EdgeInsets
    
    // MARK: - Computed Properties
    
    /// Resolves the effective icon-title arrangement, using the explicit config value
    /// or inferring from bar axis and size class when `itemContentAxis` is `nil`.
    var resolvedContentAxis: ItemContentAxis {
        itemContentAxis ?? (isVerticalCompact ? .horizontal :
            axis == .vertical ? .horizontal : .vertical)
    }

    // MARK: - Init

    /// Initializes a new `BarItemOverlayView`.
    ///
    /// - Parameters:
    ///   - item: A data model conforming to ``BarItemProtocol``.
    ///   - isSelected: Current selection state.
    ///   - isVerticalCompact: Whether the layout is in compact height mode.
    ///   - config: A configuration object defining the visual style.
    init(
        item: Item,
        isSelected: Bool,
        isVerticalCompact: Bool,
        config: BarConfiguration
    ) {
        self.item = item
        self.isSelected = isSelected
        self.isVerticalCompact = isVerticalCompact
        axis = config.axis
        itemContentAxis = config.itemContentAxis
        itemContentAlignment = config.itemContentAlignment

        let itemConfig = config.itemStyles[item.style] ?? config.itemStyles[.regular] ?? ItemConfiguration()
        itemColor = itemConfig.selectedColor
        selectedIconScale = itemConfig.selectedIconScale
        iconTitleSpacing = itemConfig.iconTitleSpacing
        textStyle = itemConfig.textStyle
        animation = config.itemStateAnimation

        let side = itemConfig.iconSideLength * (isVerticalCompact ? itemConfig.compactIconScale : 1.0)
        iconSize = CGSize(width: side, height: side)

        edgeInsets = isVerticalCompact ? itemConfig.edgeInsetsCompact : itemConfig.edgeInsets
    }

    // MARK: - Body

    var body: some View {
        Group {
            if resolvedContentAxis == .horizontal {
                HStack(alignment: itemContentAlignment.vertical, spacing: iconTitleSpacing) { content }
            } else {
                VStack(alignment: itemContentAlignment.horizontal, spacing: iconTitleSpacing) { content }
            }
        }
        .frame(maxWidth: axis == .vertical ? nil : .infinity)
        .frame(maxHeight: axis == .vertical ? .infinity : nil)
        .padding(edgeInsets)
        .allowsHitTesting(false)
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
