//
//  TabBarView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

/// A customizable, adaptive tab bar view that supports regular and prominent items.
///
/// `TabBarView` automatically switches between vertical and horizontal layouts
/// based on the device orientation (size class) and applies styles defined in `TabBarConfiguration`.
///
/// - Note: The view expects an array of items conforming to ``TabBarItemProtocol``.
public struct TabBarView<Item: TabBarItemProtocol>: View {
    // MARK: - Property Wrappers

    /// Detects current vertical size class to toggle between compact and regular layouts.
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// The currently selected tab item.
    @Binding private var selected: Item

    // MARK: - Dependencies

    private let items: [Item]
    private let config: TabBarConfiguration
    private let action: ((Item) -> Void)?

    // MARK: - Computed Properties

    private var isCompactHeight: Bool {
        verticalSizeClass == .compact
    }

    // MARK: - Init

    /// Initializes a new `TabBarView`.
    ///
    /// - Parameters:
    ///   - items: An array of data models conforming to ``TabBarItemProtocol``.
    ///   - selected: A binding to the current selection.
    ///   - action: An optional closure executed when a tab is tapped (even if already selected).
    ///   - config: A configuration object defining the visual style.
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
    /// Creates an individual tab button with a tap gesture and accessibility modifiers.
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

    /// Wraps the content in a VStack or HStack depending on the current size class.
    func tabItemLayout(content: some View) -> some View {
        Group {
            if isCompactHeight {
                HStack(spacing: config.iconTitleSpacing) { content }
            } else {
                VStack(spacing: config.iconTitleSpacing) { content }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, isCompactHeight ? config.tabItemTopPaddingCompact : config.tabItemTopPadding)
        .padding(.bottom, isCompactHeight ? config.tabItemBottomPaddingCompact : config.tabItemBottomPadding)
    }

    /// Composes the icon and title for a specific tab item.
    @ViewBuilder
    func tabContent(for item: Item, isSelected: Bool) -> some View {
        let color = config.itemColor(isSelected: isSelected)

        TabIconView(icon: item.icon)
            .frame(size: config.iconSize(for: item.style, isCompact: isCompactHeight))
            .foregroundStyle(color)
            .scaleEffect(
                isSelected ?
                    config.selectedIconScale : 1.0
            )

        Text(item.title)
            .font(.system(config.textStyle))
            .foregroundStyle(color)
            .lineLimit(1)
    }
}

#if DEBUG
    /// Data model used for Xcode Previews only.
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
