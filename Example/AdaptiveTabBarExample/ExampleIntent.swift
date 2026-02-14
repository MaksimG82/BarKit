//
//  ExampleIntent.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

enum ExampleIntent {
    /// Changes the currently selected tab.
    /// - Parameter item: The new tab item to select.
    case selectTab(ExampleTabItem)

    /// Switches the layout debugging mode.
    /// - Parameter enabled: `true` to show layout borders, `false` to hide them.
    case toggleDebug(Bool)
}
