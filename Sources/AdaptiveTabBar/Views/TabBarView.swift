//
//  TabBarView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

public struct TabBarView<Item: TabBarItemProtocol>: View {
    // MARK: - Property Wrappers

    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Binding private var selected: Item

    // MARK: - Dependencies

    private let items: [Item]
    private let config: TabBarConfiguration
    private let action: ((Item) -> Void)?

    // MARK: - Computed Properties

    private var isCompactHeight: Bool { verticalSizeClass == .compact }

    // MARK: - Init

    public init(
        items: [Item],
        selected: Binding<Item>,
        action: ((Item) -> Void)? = nil,
        config: TabBarConfiguration = .init()
    ) {
        self.items = items
        _selected = selected
        self.action = action
        self.config = config
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .bottom, spacing: config.tabSpacing) {
            ForEach(items, id: \.self) { item in
                makeTab(for: item, isSelected: item == selected)
            }
        }
        .frame(
            height: config.barHeight(isCompactHeight: isCompactHeight),
            alignment: .bottom
        )
        .background(config.backgroundColor.ignoresSafeArea(edges: .bottom))
        .accessibilityElement(children: .contain)
        .accessibilityLabel(config.barAccessibilityLabel)
        .applyDebugVisuals(color: .green)
    }
}

// MARK: - Private methods

private extension TabBarView {
    func makeTab(for item: Item, isSelected: Bool) -> some View {
        tabItemLayout(
            content: tabContent(for: item, isSelected: isSelected)
        )
        .contentShape(Rectangle())
        .animation(config.tabAnimation, value: selected)
        .onTapGesture {
            selected = item
            action?(item)
        }
        .modifier(
            TabAccessibilityModifier(
                item: item, isSelected: isSelected
            )
        )
        .applyDebugVisuals(color: .blue)
    }

    func tabItemLayout(content: some View) -> some View {
        Group {
            if isCompactHeight {
                HStack(spacing: config.iconTitleSpacing) { content }
            } else {
                VStack(spacing: config.iconTitleSpacing) { content }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(
            .vertical,
            isCompactHeight ?
                config.tabItemVerticalPaddingCompact
                : config.tabItemVerticalPadding
        )
    }

    @ViewBuilder
    func tabContent(for item: Item, isSelected: Bool) -> some View {
        let color = config.itemColor(isSelected: isSelected)

        TabIconView(icon: item.icon)
            .frame(size: config.iconSize(for: item.style, isCompact: isCompactHeight))
            .foregroundStyle(color)
            .scaleEffect(
                isSelected ?
                    config.selectedIconScale
                    : config.unselectedIconScale
            )

        Text(item.title)
            .font(.system(config.textStyle))
            .foregroundStyle(color)
            .lineLimit(1)
    }
}

// MARK: - Private Helpers

private struct TabAccessibilityModifier<Item: TabBarItemProtocol>: ViewModifier {
    let item: Item
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(item.accessibilityLabel ?? item.title)
            .accessibilityAddTraits(.isButton)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
            .accessibilityRemoveTraits(.isImage)
    }
}

#if DEBUG
    private struct PreviewTabItem: TabBarItemProtocol {
        let title: String
        var icon: TabBarIcon
        var style: TabItemStyle
    }

    @available(iOS 17.0, *)
    #Preview("Debug Layout") {
        @Previewable @State var selected: PreviewTabItem = .init(
            title: "Camera",
            icon: .system("camera.viewfinder"),
            style: .prominent
        )

        let mockItems: [PreviewTabItem] = [
            .init(title: "Settings", icon: .system("gearshape"), style: .regular),
            .init(title: "Camera", icon: .system("camera.viewfinder"), style: .prominent),
            .init(title: "Photos", icon: .system("photo.on.rectangle"), style: .regular)
        ]

        VStack {
            Spacer()
            TabBarView(items: mockItems, selected: $selected).environment(\.debugLayoutEnabled, true)
        }
    }

#endif
