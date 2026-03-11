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
    var items: [ExampleTabItem] = ExampleTabItem.allCases

    /// The currently selected tab.
    var selectedTab: ExampleTabItem = .home

    /// Flag for visual layout debugging.
    var isDebugEnabled: Bool = true
}
