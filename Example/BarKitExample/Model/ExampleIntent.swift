//
//  ExampleIntent.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import BarKit
import SwiftUI

/// Defines all possible user actions that can modify the Example app state.
enum ExampleIntent {
    // MARK: - Navigation
    
    /// Changes the currently selected tab.
    case selectTab(ExampleTabItem)
    
    // MARK: - Debug
    
    /// Toggles the visual layout debugging mode.
    case toggleDebugLayout
    
    // MARK: - Screen Intents
    
    /// Actions for the Tab Bar screen.
    case tabBar(TabBarIntent)
    
    /// Actions for the Standalone BarView screen.
    case standalone(StandaloneIntent)
}

// MARK: - Sub-Intents

/// Actions available on the Tab Bar screen.
enum TabBarIntent {
    case floating(FloatingTabBarIntent)
    
    case pinned(PinnedTabBarIntent)
    
    /// Switches between floating and pinned mode. Resets all prominent items to regular.
    case switchMode(TabBarMode)
    
    /// Updates the ItemConfiguration for .regular style.
    case updateRegularItemConfig(ItemConfiguration)
    
    /// Updates the ItemConfiguration for .prominent style. Pinned mode only.
    case updateProminentItemConfig(ItemConfiguration)
    
    /// Updates the style of a tab item. Pinned mode only.
    case updateTabItemStyle(ExampleTabItem, BarItemStyle)
    
    /// Updates the arrangement of icon and title within each bar item.
    case updateItemContentAxis(ItemContentAxis?)
    
    /// Updates background of tabbar
    case updateMaterialSelection(MaterialSelection)
    
    /// Enables or disables haptic feedback for the tab bar.
    case updateHapticFeedbackEnabled(Bool)
    
    /// Updates the haptic feedback style for the tab bar.
    case updateHapticFeedback(HapticFeedback)
    
    /// Actions for the Indicator settings.
    case indicator(IndicatorIntent)
    
    /// Resets all Tab Bar settings to their default values.
    case reset
}

/// Actions available on the Floating tab bar.
enum FloatingTabBarIntent {
    /// Updates the floating tab bar insets for regular height size class.
    case updateInsets(EdgeInsets)
    
    /// Updates the floating tab bar insets for compact height size class (e.g. landscape).
    case updateInsetsCompact(EdgeInsets)
    
    /// Updates the background appearance of the floating tab bar.
    case updateBackground(BarBackground)
    
    /// The corner radius of the floating bar.
    case updateCornerRadius(CGFloat)
        
    /// Updates the shadow configuration of the floating tab bar. Pass `nil` to disable shadow.
    case updateShadow(ShadowConfiguration?)
}

/// Actions available on the Pinned tab bar.
enum PinnedTabBarIntent {
    /// Updates the background appearance of the pinned tab bar.
    case updateBackground(BarBackground)
}

/// Actions available on the Standalone BarView screen.
enum StandaloneIntent {
    /// Selects a standalone bar item.
    case selectItem(ExampleBarItem)
    
    /// Updates the layout axis of the standalone bar.
    case updateAxis(BarConfiguration.Axis)
    
    /// Actions for the Indicator settings.
    case indicator(IndicatorIntent)
    
    /// The corner radius of the floating bar.
    case updateCornerRadius(CGFloat)
        
    /// Updates the shadow configuration of the bar. Pass `nil` to disable shadow.
    case updateShadow(ShadowConfiguration?)
    
    /// Updates the background appearance of the bar.
    case updateBackground(BarBackground)
    
    /// Updates background of the bar
    case updateMaterialSelection(MaterialSelection)
    
    /// Enables or disables haptic feedback for the bar.
    case updateHapticFeedbackEnabled(Bool)
    
    /// Updates the haptic feedback style for the bar.
    case updateHapticFeedback(HapticFeedback)
    
    /// Updates the ItemConfiguration for .regular style.
    case updateRegularItemConfig(ItemConfiguration)
    
    /// Updates the arrangement of icon and title within each bar item.
    case updateItemContentAxis(ItemContentAxis?)
    
    /// Resets all settings to their default values.
    case reset
}

enum IndicatorIntent {
    
    // MARK: - Color
    
    /// updates selection indicator color
    case updateColor(Color)
    
    // MARK: - Border
    
    /// Enables or disables the border by setting `border` to a default value or `nil`.
    case updateBorderEnabled(Bool)
    
    /// Updates the color of the indicator border.
    case updateBorderColor(Color)
    
    /// Updates the line width of the indicator border.
    case updateBorderWidth(CGFloat)
    
    // MARK: - Corner radius
    
    /// Updates the corner radius of the indicator.
    case updateCornerRadius(CGFloat)
    
    // MARK: - Transition animation
    
    /// Updates the transition animation parameters.
    case updateAnimationParameters(AnimationParameters)
    
    // MARK: - Drag gesture
    
    /// Enables or disables the drag gesture on the selection indicator.
    case updateDragGestureEnabled(Bool)
    
    // MARK: - Insets
    
    /// Updates the inset between the indicator and the item frame.
    case updateInset(EdgeInsets)
    
    // MARK: - Scale Effect
    
    /// Enables or disables the scale effect on the selection indicator.
    case updateScaleEffectEnabled(Bool)
    
    /// Updates the x scale factor of the scale effect.
    case updateScaleEffectX(CGFloat)
    
    /// Updates the y scale factor of the scale effect.
    case updateScaleEffectY(CGFloat)
    
    /// Updates the reset duration of the scale effect.
    case updateScaleEffectDuration(Double)
    
    /// Updates the animation parameters for the scale effect.
    case updateScaleAnimationParameters(AnimationParameters)
    
    // MARK: - Lens effects
    
    /// Enables or disables the lens distortion effect.
    case updateLensDistortion(Bool)
    
    /// Enables or disables the chromatic aberration effect.
    case updateChromaticAberration(Bool)
    
    /// Updates the refraction zone width.
    case updateRefractionZoneWidth(CGFloat)
    
    /// Updates the refraction strength.
    case updateRefractionStrength(CGFloat)
    
    /// Updates the aberration zone width.
    case updateAberrationZoneWidth(CGFloat)
    
    /// Updates the aberration strength.
    case updateAberrationStrength(CGFloat)
    
    // MARK: - Reset
    
    /// Resets all Indicator settings to their default values.
    case reset
    
}

