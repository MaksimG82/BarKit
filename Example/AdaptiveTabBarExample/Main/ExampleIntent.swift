//
//  ExampleIntent.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import SwiftUI

enum ExampleIntent {
    enum ColorType {
        case tint, unselected, background
    }

    /// Changes the currently selected tab.
    /// - Parameter item: The new tab item to select.
    case selectTab(ExampleTabItem)

    /// Switches the layout debugging mode.
    /// - Parameter enabled: `true` to show layout borders, `false` to hide them.
    case toggleDebug(Bool)

    case updateColor(ColorType, Color)

    case updateTextStyle(Font.TextStyle)

    case updateRegularIconSize(CGFloat)

    case updateProminentIconSize(CGFloat)

    case updateCompactIconScale(CGFloat)

    case updateSelectedIconScale(CGFloat)

    case updateItems([ExampleTabItem])

    case updateTabSpacing(CGFloat)

    case updateIconTitleSpacing(CGFloat)

    case updateTabItemTopPadding(CGFloat)

    case updateTabItemBottomPadding(CGFloat)

    case updateTabItemTopPaddingCompact(CGFloat)

    case updateTabItemBottomPaddingCompact(CGFloat)

    case toggleProminentStyle(UUID)
    
    case updateAnimation(Animation?)

    case resetState
}
