//
//  PinnedTabBarView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 03.05.26.
//


import SwiftUI

/// A pinned tab bar that wraps `BarView`, spanning the full screen width and integrating
/// with the bottom safe area via a background extension.
///
/// The following `BarConfiguration` properties are ignored — `PinnedTabBarView` always
/// overrides them: `axis` (forced to `.horizontal`), `cornerRadius` (forced to `0`),
/// `shadow` (forced to `nil`). All other properties are forwarded as-is.
///
/// **Usage:**
/// ```swift
/// VStack(spacing: 0) {
///     ContentView()
///     PinnedTabBarView(items: items, selected: $selected, config: config)
/// }
/// ```
public struct PinnedTabBarView<Item: BarItemProtocol>: View {

    // MARK: - Bindings

    /// The currently selected bar item.
    @Binding private var selected: Item

    // MARK: - Properties

    /// An array of data models conforming to ``BarItemProtocol``.
    private let items: [Item]

    /// Visual style and behavior configuration for the bar.
    /// - Note: `axis`, `cornerRadius`, `shadow`,`background`,`itemAlignement`and `baselineStyle`  are ignored.
    private let config: BarConfiguration

    /// An optional closure executed when an item is tapped, even if already selected.
    private let action: ((Item) -> Void)?

    // MARK: - Computed Properties

    /// A derived configuration with pinned-specific overrides applied.
    private var pinnedConfig: BarConfiguration {
        BarConfiguration(
            axis: .horizontal,
            cornerRadius: 0,
            shadow: nil,
            background: .color(.clear),
            itemStyles: config.itemStyles,
            itemAlignment: .end,
            baselineStyle: .regular
        )
    }

    // MARK: - Init

    /// Creates a new `PinnedTabBarView`.
    ///
    /// - Parameters:
    ///   - items: An array of data models conforming to ``BarItemProtocol``.
    ///   - selected: A binding to the currently selected item.
    ///   - config: Visual and behavior configuration. `axis`, `cornerRadius`, `shadow`,`background`,`itemAlignement`and `baselineStyle`  are ignored.
    ///   - action: An optional closure executed when an item is tapped.
    public init(
        items: [Item],
        selected: Binding<Item>,
        config: BarConfiguration,
        action: ((Item) -> Void)? = nil
    ) {
        self.items = items
        _selected = selected
        self.config = config
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        BarView(
            items: items,
            selected: $selected,
            config: pinnedConfig,
            indicatorConfig: nil,
            action: action
        )
        .frame(maxWidth: .infinity)
        .background {
            backgroundView
                .ignoresSafeArea(.all, edges: .bottom)
        }
        .overlay(alignment: .top) {
            Divider()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }

    // MARK: - Subviews

    /// The background view derived from the bar's `BarBackground` configuration.
    @ViewBuilder
    private var backgroundView: some View {
        switch config.background {
        case let .color(color):
            color
        case let .material(material, tint):
            Rectangle()
                .fill(material)
                .overlay { tint }
        case let .customBlur(_, tint):
            Rectangle()
                .fill(.clear)
                .overlay { tint }
        }
    }
}
// MARK: - Preview

#if DEBUG

@available(iOS 17.0, *)
#Preview("PinnedTabBarView - Regular") {
    @Previewable @State var selected: PreviewBarItem = .init(
        title: "Home",
        icon: .system("house.fill")
    )

    let items: [PreviewBarItem] = [
        .init(title: "Home",    icon: .system("house.fill")),
        .init(title: "Search",  icon: .system("magnifyingglass")),
        .init(title: "Profile", icon: .system("person.fill")),
    ]

    VStack(spacing: 0) {
        Color.white.ignoresSafeArea()
        PinnedTabBarView(
            items: items,
            selected: $selected,
            config: .init(itemStyles: [.regular: .init()],
            )
        )
        .environment(\.debugLayoutEnabled, false)
    }
}

@available(iOS 17.0, *)
#Preview("PinnedTabBarView - Prominent") {
    @Previewable @State var selected: PreviewBarItem = .init(
        title: "Camera",
        icon: .system("camera.fill"),
        style: .prominent
    )

    let items: [PreviewBarItem] = [
        .init(title: "Home",   icon: .system("house.fill"),    style: .regular),
        .init(title: "Camera", icon: .system("camera.fill"),   style: .prominent),
        .init(title: "Profile", icon: .system("person.fill"),  style: .regular),
    ]

    VStack(spacing: 0) {
        Color.white.ignoresSafeArea()
        PinnedTabBarView(
            items: items,
            selected: $selected,
            config: .init(
                background: .material(.ultraThin, tint: .blue.opacity(0.3)),
                itemStyles: [
                    .regular: .init(iconSideLength: 24),
                    .prominent: .init(iconSideLength: 40),
                ],
                itemSpacing: 0,
                itemStateAnimation: .easeInOut(duration: 0.2),
                baselineStyle: .regular,
                barAccessibilityLabel: "Tab Bar"
            )
        )
        .environment(\.debugLayoutEnabled, false)
    }
}

/// Preview-only bar item conforming to ``BarItemProtocol``.
private struct PreviewBarItem: BarItemProtocol {
    let title: String
    let icon: BarIcon
    var style: BarItemStyle = .regular
    var id: AnyHashable { title }
}

#endif
