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
    
    var mode: TabBarMode = .floating
    
    var floatingTabBarState: FloatingTabBarState = .init()
    
    var pinnedTabBarState: PinnedTabBarState = .init()
    
    var floatingTabBarMaterialSelection: MaterialSelection = .ultraThin
    
    var pinnedTabBarMaterialSelection: MaterialSelection = .ultraThin
    
    /// The selection indicator state for the Tab bar.
    var indicator: BarIndicatorState = .init()
}
 
/// State for the Floating tab bar.
struct FloatingTabBarState {
    
    var barConfig: BarConfiguration = .init(accessibilitySortPriority: -1)
    
    var insets: EdgeInsets = .init(
        top: 0, leading: 16, bottom: 20, trailing: 16
    )
    
    var insetsCompact: EdgeInsets = .init(
        top: 0, leading: 16, bottom: 8, trailing: 16
    )
}
 
/// State for the Pinned tab bar.
struct PinnedTabBarState {
    var barConfig: BarConfiguration = .init(accessibilitySortPriority: -1)
}
 
/// State for the Standalone BarView screen.
struct StandaloneState {
    
    /// The list of items displayed in the standalone bar.
    var items: [ExampleBarItem] = ExampleBarItem.allItems

    /// The currently selected standalone bar item.
    var selectedItem: ExampleBarItem
    
    /// The bar configuration for the standalone bar.
    var barConfiguration: BarConfiguration = .init()
    
    /// The selection indicator state for the standalone bar.
    var indicator: BarIndicatorState = .init()
    
    var insets: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    
    // MARK: - Initialization
 
    init() {
        selectedItem = ExampleBarItem.allItems[0]
    }
}

/// State for the BarView's selection indicator.
struct BarIndicatorState {
    
    var configuration: SelectionIndicatorConfiguration = .init()
    
    var animationParameters: AnimationParameters = .init()
    
    var scaleAnimationParameters: AnimationParameters = .init()
}
