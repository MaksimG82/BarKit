//
//  TabBarItemProtocol.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

public protocol TabBarItemProtocol: Hashable {
    // Content
    var icon: TabBarIcon { get }
    var title: String { get }

    // Appearance
    var style: TabItemStyle { get }

    // Accecibility
    var accessibilityLabel: String? { get }
}

public extension TabBarItemProtocol {
    var accessibilityLabel: String? { nil }
}
