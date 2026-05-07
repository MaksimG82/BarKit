//
//  FloatingTabBarView.swift
//  BarKit
//

import SwiftUI

/// A floating tab bar that wraps `BarView`, adding edge insets positioning.
/// Renders a detached capsule with configurable horizontal and bottom spacing.
///
/// Safe area handling is the responsibility of the calling code.
///
/// **Usage:**
/// ```swift
/// ZStack(alignment: .bottom) {
///     ContentView()
///     FloatingTabBarView(items: items, selected: $selected, config: config)
/// }
/// .ignoresSafeArea(.all, edges: .bottom)
/// ```
public struct FloatingTabBarView<Item: BarItemProtocol>: View {

    // MARK: - Bindings

    /// The currently selected bar item.
    @Binding private var selected: Item

    // MARK: - Properties

    /// An array of data models conforming to ``BarItemProtocol``.
    private let items: [Item]

    /// Visual style, layout, and behavior configuration for the bar.
    private let config: BarConfiguration

    /// Appearance and behavior configuration for the selection indicator.
    private let indicatorConfig: SelectionIndicatorConfiguration

    /// Insets that position the capsule relative to the screen edges.
    /// - `leading` / `trailing`: horizontal distance from screen edges.
    /// - `bottom`: distance above the home indicator / safe area edge.
    /// - `top`: ignored — floating bars do not constrain their top edge.
    private let floatingInsets: EdgeInsets

    /// An optional closure executed when an item is tapped, even if already selected.
    private let action: ((Item) -> Void)?

    // MARK: - Init

    /// Creates a new `FloatingTabBarView`.
    ///
    /// - Parameters:
    ///   - items: An array of data models conforming to ``BarItemProtocol``.
    ///   - selected: A binding to the currently selected item.
    ///   - config: Visual and layout configuration for the bar.
    ///   - indicatorConfig: Configuration for the selection indicator.
    ///   - floatingInsets: Insets that position the capsule relative to screen edges.
    ///   - action: An optional closure executed when an item is tapped.
    public init(
        items: [Item],
        selected: Binding<Item>,
        config: BarConfiguration,
        indicatorConfig: SelectionIndicatorConfiguration = .init(),
        floatingInsets: EdgeInsets = .init(top: 0, leading: 16, bottom: 20, trailing: 16),
        action: ((Item) -> Void)? = nil
    ) {
        self.items = items
        _selected = selected
        self.config = config
        self.indicatorConfig = indicatorConfig
        self.floatingInsets = floatingInsets
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        BarView(
            items: items,
            selected: $selected,
            config: config,
            indicatorConfig: indicatorConfig,
            action: action
        )
        .padding(.leading, floatingInsets.leading)
        .padding(.trailing, floatingInsets.trailing)
        .padding(.bottom, floatingInsets.bottom)
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17.0, *)
#Preview("FloatingTabBarView") {
    @Previewable @State var selected: PreviewBarItem = .init(
        title: "Home",
        icon: .system("house.fill")
    )

    let items: [PreviewBarItem] = [
        .init(title: "Home",    icon: .system("house.fill")),
        .init(title: "Search",  icon: .system("magnifyingglass")),
        .init(title: "Profile", icon: .system("person.fill")),
    ]

    ZStack(alignment: .bottom) {
        Color.indigo.ignoresSafeArea()
        FloatingTabBarView(
            items: items,
            selected: $selected,
            config: .init(itemStyles: [.regular: .init()]),
            floatingInsets: .init(top: 0, leading: 16, bottom: 20, trailing: 16)
        )
    }
    .ignoresSafeArea(.all, edges: .bottom)
}

/// Preview-only bar item conforming to ``BarItemProtocol``.
private struct PreviewBarItem: BarItemProtocol {
    let title: String
    let icon: BarIcon
    var style: BarItemStyle = .regular
    var id: AnyHashable { title }
}

#endif
