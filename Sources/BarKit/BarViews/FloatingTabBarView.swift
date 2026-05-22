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

    // MARK: - Environment
    
    /// Detects current vertical size class to toggle between compact and regular layouts.
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    // MARK: - Bindings

    /// The currently selected bar item.
    @Binding private var selected: Item

    // MARK: - Properties

    /// An array of data models conforming to ``BarItemProtocol``.
    private let items: [Item]

    /// Visual style, layout, and behavior configuration for the bar.
    private let config: BarConfiguration

    /// Insets that position the capsule relative to the screen edges in regular size class.
    /// - `leading` / `trailing`: horizontal distance from screen edges.
    /// - `bottom`: distance above the home indicator / safe area edge.
    /// - `top`: ignored — floating bars do not constrain their top edge.
    private let floatingInsets: EdgeInsets

    /// Insets that position the capsule in compact height size class (e.g. landscape).
    /// If `nil`, `floatingInsets` is used for all size classes.
    private let floatingInsetsCompact: EdgeInsets?

    /// An optional closure executed when an item is tapped, even if already selected.
    private let action: ((Item) -> Void)?
    
    // MARK: - Computed Properties

    /// Resolves the active insets based on the current vertical size class.
    private var activeInsets: EdgeInsets {
        verticalSizeClass == .compact ? floatingInsetsCompact ?? floatingInsets : floatingInsets
    }

    // MARK: - Init

    /// Creates a new `FloatingTabBarView`.
    ///
    /// - Parameters:
    ///   - items: An array of data models conforming to ``BarItemProtocol``.
    ///   - selected: A binding to the currently selected item.
    ///   - config: Visual and layout configuration for the bar.
    ///   - floatingInsets: Insets that position the capsule relative to screen edges.
    ///   - floatingInsetsCompact:Insets for compact height size class (e.g. landscape).
    ///   - action: An optional closure executed when an item is tapped.
    public init(
        items: [Item],
        selected: Binding<Item>,
        config: BarConfiguration,
        floatingInsets: EdgeInsets = .init(top: 0, leading: 16, bottom: 20, trailing: 16),
        floatingInsetsCompact: EdgeInsets? = nil,
        action: ((Item) -> Void)? = nil
    ) {
        self.items = items
        _selected = selected
        self.config = config
        self.floatingInsets = floatingInsets
        self.floatingInsetsCompact = floatingInsetsCompact
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        BarView(
            items: items,
            selected: $selected,
            config: config,
            action: action
        )
        .padding(.leading, activeInsets.leading)
        .padding(.trailing, activeInsets.trailing)
        .padding(.bottom, activeInsets.bottom)
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
