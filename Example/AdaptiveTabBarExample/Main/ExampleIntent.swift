//
//  ExampleIntent.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import BarKit
import SwiftUI

/// Defines all possible user intentions (actions) that can modify the state.
enum ExampleIntent {
    /// Defines target components for color updates.
    enum ColorType {
        /// The primary color for the selected tab.
        case tint

        /// The color for inactive/unselected tabs.
        case unselected

        /// The bar's background fill color.
        case background
    }

    /// Defines specific layout adjustments for the floating tab bar style.
    enum FloatingLayoutParam {
        /// Horizontal inset from the leading screen edge.
        case leadingInset(CGFloat)

        /// Horizontal inset from the trailing screen edge.
        case trailingInset(CGFloat)

        /// Vertical distance from the bottom safe area boundary.
        case bottomInset(CGFloat)

        /// The corner radius of the floating background capsule.
        case cornerRadius(CGFloat)

        /// The blur radius used to render the outer elevation shadow.
        case shadowRadius(CGFloat)
    }

    // MARK: - Navigation

    /// Changes the currently selected tab.
    case selectTab(ExampleTabItem)

    // MARK: - Visual Style

    /// Updates a specific color component of the tab bar.
    case updateColor(ColorType, Color)

    /// Updates the background blur effect using system materials.
    case updateMaterial(Material?)

    /// Changes the font style used for tab titles.
    case updateTextStyle(Font.TextStyle)

    /// Updates the size of regular (standard) tab icons.
    case updateRegularIconSize(CGFloat)

    /// Updates the size of prominent (emphasized) tab icons.
    case updateProminentIconSize(CGFloat)

    /// Adjusts the icon scale when the device is in compact height (landscape).
    case updateCompactIconScale(CGFloat)

    /// Sets the scale effect for the icon when its tab is selected.
    case updateSelectedIconScale(CGFloat)

    // MARK: - Content & Layout

    /// Sets layout style
    case updateLayoutStyle(TabBarStyle)

    /// Replaces the entire set of tab items.
    case updateItems([ExampleTabItem])

    /// Adjusts the horizontal spacing between tabs.
    case updateTabSpacing(CGFloat)

    /// Adjusts the vertical/horizontal spacing between the icon and the title.
    case updateIconTitleSpacing(CGFloat)

    /// Sets the top padding for tab items in regular height.
    case updateTabItemTopPadding(CGFloat)

    /// Sets the bottom padding for tab items in regular height.
    case updateTabItemBottomPadding(CGFloat)

    /// Sets the top padding for tab items in compact height.
    case updateTabItemTopPaddingCompact(CGFloat)

    /// Sets the bottom padding for tab items in compact height.
    case updateTabItemBottomPaddingCompact(CGFloat)

    /// Toggles the visual style (regular vs prominent) for a specific tab by its ID.
    case toggleProminentStyle(ExampleTabItem.TabType)

    // MARK: - Floating layout setup

    /// Updates floatinfg layout settings
    case updateFloatingLayout(FloatingLayoutParam)

    // MARK: - Animation

    /// Updates the item animation used when switching tabs.
    case updateTabItem(Animation?)

    /// Updates the animation responsible for moving the selection indicator between tabs.
    case updateIndcatorTransition(Animation?)

    /// Updates the scale and animation properties of the selection indicator during the jump.
    case updateIndicator(SelectionScaleEffect?)

    // MARK: - Behavior & Debug

    /// Switches the visual layout debugging mode (borders and safe areas).
    case toggleDebugLayout

    /// Reverts all configuration and state to their initial default values.
    case resetState
}
