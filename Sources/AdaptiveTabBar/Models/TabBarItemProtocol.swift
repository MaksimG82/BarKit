//
//  TabBarItemProtocol.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

/// Defines the requirements for a tab bar item
///
/// Conform to this protocol to create custom tab items:
/// ```swift
/// struct MyTab: TabBarItemProtocol {
///     let icon: TabBarIcon
///     let title: String
///     let style: TabItemStyle = .regular
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
}

public extension TabBarItemProtocol {
    var accessibilityLabel: String? {
        nil
    }
}
