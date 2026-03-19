//
//  FloatingLayoutView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 16.03.26.
//

import SwiftUI

/// A floating tab bar layout designed to replicate the "Liquid Glass" aesthetic.
///
/// It renders items within a detached, blurred capsule that adapts its content
/// to maintain a balanced, lightweight appearance.
struct FloatingLayoutView<Item: TabBarItemProtocol>: View {
    // MARK: - Property Wrappers

    /// Detects current vertical size class to toggle between compact and regular layouts.
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// The currently selected tab item.
    @Binding private var selected: Item

    @Namespace private var tabBarNamespace

    // MARK: - Properties

    /// An array of data models conforming to ``TabBarItemProtocol``.
    private let items: [Item]

    /// A binding to the current selection.
    private let config: TabBarConfiguration

    /// An optional closure executed when a tab is tapped (even if already selected).
    private let action: ((Item) -> Void)?

    // MARK: - Computed Properties

    /// Layout settings specific to the floating bar style.
    private var floatingConfig: FloatingConfiguration {
        config.floatingConfig ?? .init()
    }

    /// Returns true if the layout is in a vertically constrained environment.
    private var isVerticalCompact: Bool {
        verticalSizeClass == .compact
    }

    // MARK: - Init

    // Initializes a new `FloatingLayoutView`.
    //
    // - Parameters:
    //   - selected: A binding to the current selection.
    //   - items: An array of data models conforming to ``TabBarItemProtocol``.
    //   - config: A configuration object defining the visual style.
    //   - shouldAdaptProminentItems: A flag that determines whether items with a `.prominent` style should be automatically converted to `.regular` for a more consistent look within the floating bar.
    //   - action: An optional closure executed when a tab is tapped (even if already selected).

    init(
        selected: Binding<Item>,
        items: [Item],
        config: TabBarConfiguration,
        shouldAdaptProminentItems: Bool = true,
        action: ((Item) -> Void)? = nil
    ) {
        _selected = selected
        self.config = config
        self.action = action

        if shouldAdaptProminentItems, items.contains(where: { $0.style == .prominent }) {
            #if DEBUG
                print("⚠️ TabBarView: Prominent items detected and adapted to .regular for FloatingLayout.")
            #endif
            self.items = items.map { item in
                item.style == .prominent ? item.withStyle(.regular) : item
            }
        } else {
            self.items = items
        }
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .bottom, spacing: config.tabSpacing) {
            ForEach(items) { item in
                TabItemView(
                    item: item,
                    isSelected: item.id == selected.id,
                    isVerticalCompact: isVerticalCompact,
                    config: config
                ) {
                    selected = item
                    action?(item)
                }
                .matchedGeometryEffect(id: item.id, in: tabBarNamespace) // Animate by ID
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(config.barAccessibilityLabel)
        .background {
            ZStack {
                backgroundCapsule
                selectionIndicator
            }
        }
        .padding(.leading, floatingConfig.leadingInset)
        .padding(.trailing, floatingConfig.trailingInset)
        .padding(.bottom, floatingConfig.bottomInset)
    }

    // MARK: - Subviews

    private var backgroundCapsule: some View {
        RoundedRectangle(cornerRadius: floatingConfig.cornerRadius)
            .fill(config.backgroundColor)
            .shadow(radius: floatingConfig.shadowRadius)
            .background {
                if let material = config.backgroundMaterial {
                    RoundedRectangle(cornerRadius: floatingConfig.cornerRadius)
                        .fill(material)
                }
            }
    }

    private var selectionIndicator: some View {
        RoundedRectangle(cornerRadius: floatingConfig.cornerRadius - 4)
            .fill(Color.secondary.opacity(0.2))
            .padding(2)
            .matchedGeometryEffect(id: selected.id, in: tabBarNamespace, isSource: false)
    }
}
