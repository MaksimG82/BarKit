//
//  ExampleState.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import AdaptiveTabBar
import SwiftUI

/// Represents the entire state of the Example app screen.
/// Designed to be used within a ViewModel to drive the UI in a unidirectional flow.
struct ExampleState {
    // MARK: - Configuration

    /// The visual configuration of the TabBar.
    var config: TabBarConfiguration = .init()

    /// Flag for visual layout debugging.
    var isDebugLayoutEnabled: Bool = false

    // MARK: - Data & Selection

    /// The list of tab items currently displayed in the bar.
    var items: [ExampleTabItem] = ExampleTabItem.fiveItems

    /// The currently active tab.
    var selectedTab: ExampleTabItem

    // MARK: - Initialization

    /// Initializes the state with default items and selects the first one.
    init() {
        let defaultItems = ExampleTabItem.fiveItems
        items = defaultItems
        selectedTab = defaultItems.first ?? .init(type: .home, style: .regular)
    }
}
