//
//  PinnedLayoutView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 16.03.26.
//

import SwiftUI

/// A tab bar layout that pins the bar to the bottom of the screen.
///
/// This layout follows the traditional system behavior where the bar spans the full width
/// and integrates with the bottom safe area. It supports both standard and prominent
/// item styles.
struct PinnedLayoutView<Item: TabBarItemProtocol>: View {
    // MARK: - Property Wrappers

    /// Detects current vertical size class to toggle between compact and regular layouts.
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// The currently selected tab item.
    @Binding private var selected: Item

    // MARK: - Properties

    /// An array of data models conforming to ``TabBarItemProtocol``.
    let items: [Item]

    /// A binding to the current selection.
    let config: TabBarConfiguration

    /// An optional closure executed when a tab is tapped (even if already selected).
    let action: ((Item) -> Void)?

    // MARK: - Computed Properties

    /// Returns true if the layout is in a vertically constrained environment.
    private var isVerticalCompact: Bool {
        verticalSizeClass == .compact
    }

    /// Returns true if items array contains prominent items.
    private var hasProminentItems: Bool {
        items.contains(where: { $0.style == .prominent })
    }

    // MARK: - Init

    // Initializes a new `PinnedLayoutView`.
    //
    // - Parameters:
    //   - selected: A binding to the current selection.
    //   - items: An array of data models conforming to ``TabBarItemProtocol``.
    //   - config: A configuration object defining the visual style.
    //   - action: An optional closure executed when a tab is tapped (even if already selected).

    init(
        selected: Binding<Item>,
        items: [Item],
        config: TabBarConfiguration,
        action: ((Item) -> Void)? = nil
    ) {
        _selected = selected
        self.items = items
        self.config = config
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .bottom, spacing: config.tabSpacing) {
            ForEach(items, id: \.self) { item in
                TabItemView(
                    item: item,
                    isSelected: item == selected,
                    isVerticalCompact: isVerticalCompact,
                    config: config,
                    action: {
                        selected = item
                        action?(item)
                    }
                )
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(config.barAccessibilityLabel)
        .frame(
            height: hasProminentItems ? config.calculatedBarHeight(isVerticalCompact: isVerticalCompact) : nil,
            alignment: .bottom
        )
        .background {
            if let material = config.backgroundMaterial {
                Rectangle()
                    .fill(material)
                    .ignoresSafeArea()
            }
            config.backgroundColor.ignoresSafeArea()
        }
        .applyDebugVisuals(color: .green)
    }
}
