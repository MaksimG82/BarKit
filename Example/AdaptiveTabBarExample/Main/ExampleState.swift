//
//  ExampleState.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import AdaptiveTabBar
import SwiftUI

/// Represents the entire state of the Example app screen.
struct ExampleState {
    /// The current configuration of the TabBar.
    var config: TabBarConfiguration = .init()

    /// The list of tab items to display.
    var items: [ExampleTabItem] = ExampleTabItem.fiveItems

    /// Flag for visual layout debugging.
    var isDebugEnabled: Bool = true

    /// The currently selected tab.
    var selectedTab: ExampleTabItem

    init() {
        selectedTab = items.first ?? .init(type: .home, style: .regular)
    }
}
