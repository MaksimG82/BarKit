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
    var items: [ExampleTabItem] = ExampleTabItem.allItems
 
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
 
    /// State for the Indicator screen.
    var indicator: IndicatorState = .init()
 
    // MARK: - Initialization
 
    init() {
        selectedTab = ExampleTabItem.allItems.first!
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
}
 
/// State for the Floating tab bar.
struct FloatingTabBarState {
    
    var barConfig: BarConfiguration = .init()
    
    var insets: EdgeInsets = .init(
        top: 0, leading: 16, bottom: 20, trailing: 16
    )
    
    var insetsCompact: EdgeInsets = .init(
        top: 0, leading: 16, bottom: 8, trailing: 16
    )
}
 
/// State for the Pinned tab bar.
struct PinnedTabBarState {
    var barConfig: BarConfiguration = .init()
}
 
/// State for the Standalone BarView screen.
struct StandaloneState {
    var horizontal: HorizontalBarState = .init()
    var vertical: VerticalBarState = .init()
}
 
/// State for the horizontal BarView.
struct HorizontalBarState {
    var barConfig: BarConfiguration = .init()
    var insets: EdgeInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
}
 
/// State for the vertical BarView.
struct VerticalBarState {
    var barConfig: BarConfiguration = .init()
    var insets: EdgeInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
}
 
/// State for the Indicator screen.
struct IndicatorState {
    var indicatorConfig: SelectionIndicatorConfiguration = .init()
    var animationParameters: AnimationParameters = .init()
    var scaleAnimationParameters: AnimationParameters = .init()
}
