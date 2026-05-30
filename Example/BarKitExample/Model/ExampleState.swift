//
//  ExampleState.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import BarKit
import SwiftUI

/// Represents the entire state of the Example app.
struct ExampleState {
 
    // MARK: - Navigation
 
    /// The list of tab items displayed in the bar.
    var tabBarItems: [ExampleTabItem] = ExampleTabItem.allItems
 
    /// The currently active tab.
    var selectedTab: ExampleTabItem
 
    /// Bumped when tab bar mode changes to force view recreation via `.id()`.
    var instanceID: UUID = UUID()
 
    // MARK: - Debug
 
    /// Flag for visual layout debugging.
    var isDebugLayoutEnabled: Bool = false
 
    // MARK: - Sub-States
 
    /// State for the Tab Bar screen.
    var tabBar: TabBarState = .init()
 
    /// State for the Standalone BarView screen.
    var standalone: StandaloneState = .init()
 
    // MARK: - Initialization
 
    init() {
        selectedTab = ExampleTabItem.allItems[0]
    }
}
 
// MARK: - Sub-States
 
/// State for the Tab Bar screen.
struct TabBarState {
    
    /// The current tab bar display mode (floating or pinned).
    var mode: TabBarMode = .floating
    
    /// State specific to the floating tab bar variant.
    var floatingTabBarState: FloatingTabBarState = .init()
    
    /// State specific to the pinned tab bar variant.
    var pinnedTabBarState: PinnedTabBarState = .init()
}
 
/// State for the Floating tab bar.
struct FloatingTabBarState {
    
    /// Visual and layout configuration for the floating tab bar.
    var barConfiguration: BarConfiguration = .init(accessibilitySortPriority: -1)
    
    /// Insets positioning the floating bar in regular height mode.
    var insets: EdgeInsets = .init(top: 0, leading: 16, bottom: 20, trailing: 16)
    
    /// Insets positioning the floating bar in compact height mode (e.g. landscape).
    var insetsCompact: EdgeInsets = .init(top: 0, leading: 16, bottom: 8, trailing: 16)
    
    /// A dictionary mapping item identifiers to their badge values.
    var badges: [AnyHashable: BadgeValue] = [:]
}

/// State for the Pinned tab bar.
struct PinnedTabBarState {
    
    /// Visual and layout configuration for the pinned tab bar.
    var barConfiguration: BarConfiguration = .init(accessibilitySortPriority: -1)
    
    /// A dictionary mapping item identifiers to their badge values.
    var badges: [AnyHashable: BadgeValue] = [:]
}

/// State for the Standalone BarView screen.
struct StandaloneState {
    
    /// The list of items displayed in the standalone bar.
    var items: [ExampleBarItem] = ExampleBarItem.allItems

    /// The currently selected standalone bar item.
    var selectedItem: ExampleBarItem
    
    /// The bar configuration for the standalone bar.
    var barConfiguration: BarConfiguration = .init()
    
    /// Insets applied around the standalone bar preview.
    var insets: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    
    /// A dictionary mapping item identifiers to their badge values.
    var badges: [AnyHashable: BadgeValue] = [:]
    
    init() {
        selectedItem = ExampleBarItem.allItems[0]
    }
}
