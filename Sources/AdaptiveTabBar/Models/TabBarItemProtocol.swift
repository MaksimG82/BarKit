//
//  TabBarItemProtocol.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

/// Defines the properties and behavior for a single tab bar item.
///
/// Conform to this protocol to define the content and appearance of your tabs.
///
/// ### Example
/// ```swift
/// struct AppTab: TabBarItemProtocol {
///     let icon: TabBarIcon
///     let title: String
///     var style: TabItemStyle = .regular
///
///     func withStyle(_ newStyle: TabItemStyle) -> AppTab {
///         var copy = self
///         copy.style = newStyle
///         return copy
///     }
/// }
/// ```
public protocol TabBarItemProtocol: Hashable {
    // MARK: Content

    /// Icon representation to display in the tab.
    var icon: TabBarIcon { get }

    /// Text label shown below the icon.
    var title: String { get }

    // MARK: Appearance

    /// Visual style of the tab item.
    var style: TabItemStyle { get }

    // MARK: Accessibility

    /// Custom accessibility label (defaults to title if nil).
    var accessibilityLabel: String? { get }

    // MARK: - Transformation

    /// Returns a copy of the item with a different style.
    /// This is primarily used by layouts (e.g., `FloatingLayout`) to ensure
    /// visual consistency by adapting `.prominent` items to `.regular`.
    func withStyle(_ newStyle: TabItemStyle) -> Self
}

public extension TabBarItemProtocol {
    /// Default implementation that returns `nil`, falling back to the `title`.
    var accessibilityLabel: String? {
        nil
    }
}
