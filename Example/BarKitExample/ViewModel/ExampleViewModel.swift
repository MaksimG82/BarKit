//
//  ExampleViewModel.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import BarKit
import Observation
import SwiftUI

/// Manages the state and logic for the Example application.
@Observable
final class ExampleViewModel {
 
    // MARK: - State
 
    /// The single source of truth for the view.
    private(set) var state = ExampleState()
 
    // MARK: - Intent Handling
 
    /// Entry point for all user actions.
    func send(_ intent: ExampleIntent) {
        switch intent {
 
        case .toggleDebugLayout:
            state.isDebugLayoutEnabled.toggle()
 
        case let .tabBar(tabBarIntent):
            handle(tabBarIntent)
 
        case let .standalone(standaloneIntent):
            handle(standaloneIntent)
        }
    }
}
 
private extension ExampleViewModel {
    
    // MARK: - TabBar
    
    func handle(_ intent: TabBarIntent) {
        switch intent {
            
        case let .floating(floatingIntent):
            handle(floatingIntent)
            
        case let .pinned(pinnedIntent):
            handle(pinnedIntent)
            
        case let .selectTab(item):
            state.selectedTab = item
            
        case let .switchMode(mode):
            if mode != state.tabBar.mode {
                state.instanceID = UUID()
                if mode == .floating {
                    state.tabBarItems = state.tabBarItems.map { $0.withStyle(.regular) }
                }
            }
            state.tabBar.mode = mode
            
        case let .updateBackground(background):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfig.background = background
            case .pinned:
                pinnedTabBarConfig.background = background
            }
            
        case let .updateRegularItemConfig(configuration):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfig.itemStyles[.regular] = configuration
            case .pinned:
                pinnedTabBarConfig.itemStyles[.regular] = configuration
            }
            
        case let .updateItemContentAxis(axis):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfig.itemContentAxis = axis
            case .pinned:
                pinnedTabBarConfig.itemContentAxis = axis
            }
            
        case let .updateHapticFeedbackEnabled(isEnabled):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfig.hapticFeedback = isEnabled ? .selection : nil
            case .pinned:
                pinnedTabBarConfig.hapticFeedback = isEnabled ? .selection : nil
            }
            
        case let .updateHapticFeedback(feedback):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfig.hapticFeedback = feedback
            case .pinned:
                pinnedTabBarConfig.hapticFeedback = feedback
            }
            
        case .reset:
            state.tabBar = .init()
            state.instanceID = UUID()
        }
    }
    
    
    // MARK: - FloatingTabBar
    
    func handle(_ intent: FloatingTabBarIntent) {
        switch intent {
        case let .updateInsets(insets):
            state.tabBar.floatingTabBarState.insets = insets
            
        case let .updateInsetsCompact(insets):
            state.tabBar.floatingTabBarState.insetsCompact = insets
            
        case let .updateCornerRadius(cornerRadius):
            floatingTabBarConfig.cornerRadius = cornerRadius
            
        case let .updateShadow(shadow):
            floatingTabBarConfig.shadow = shadow
            
        case let .indicator(indicatorIntent):
            var indicator = floatingTabBarConfig.indicator ?? .init()
            handle(indicatorIntent, configuration: &indicator)
            floatingTabBarConfig.indicator = indicator
        }
    }
    // MARK: - PinnnedTabBar
    
    
    func handle(_ intent: PinnedTabBarIntent) {
        switch intent {
        case let .updateProminentItemConfig(config):
            state.tabBar.pinnedTabBarState.barConfig.itemStyles[.prominent] = config
            
        case let .updateTabItemStyle(item, style):
            guard let index = state.tabBarItems.firstIndex(where: { $0.id == item.id }) else { return }
            state.tabBarItems[index].style = style
        }
    }
    
    // MARK: - Standalone
    
    func handle(_ intent: StandaloneIntent) {
        switch intent {
        case let .selectItem(item):
            state.standalone.selectedItem = item
            
        case let .updateAxis(axis):
            state.standalone.barConfiguration.axis = axis
            
        case let .indicator(indicatorIntent):
            var indicator = standaloneBarConfig.indicator ?? .init()
            handle(indicatorIntent, configuration: &indicator)
            standaloneBarConfig.indicator = indicator
            
        case let .updateCornerRadius(radius):
            standaloneBarConfig.cornerRadius = radius
            
        case let .updateShadow(shadow):
            standaloneBarConfig.shadow = shadow
            
        case let .updateBackground(background):
            standaloneBarConfig.background = background
            
        case let .updateHapticFeedbackEnabled(isEnabled):
            standaloneBarConfig.hapticFeedback = isEnabled ? .selection : nil
            
        case let .updateHapticFeedback(feedback):
            standaloneBarConfig.hapticFeedback = feedback
            
        case let .updateRegularItemConfig(configuration):
            standaloneBarConfig.itemStyles[.regular] = configuration
            
        case let .updateItemContentAxis(axis):
            standaloneBarConfig.itemContentAxis = axis
            
        case let .updateItemAlignment(alignment):
            standaloneBarConfig.itemAlignment = alignment
            
        case let .updateItemContentAlignment(alignment):
            standaloneBarConfig.itemContentAlignment = alignment
            
        case .reset:
            state.standalone = .init()
        }
    }
    
    // MARK: - Indicator
    
    func handle(
        _ intent: IndicatorIntent,
        configuration: inout SelectionIndicatorConfiguration
    ) {
        switch intent {
        case let .updateColor(color):
            configuration.color = color
            
        case let .updateBorderEnabled(isEnabled):
            configuration.border = isEnabled ? .init() : nil
            
        case let .updateBorderColor(color):
            configuration.border?.color = color
            
        case let .updateBorderWidth(width):
            configuration.border?.lineWidth = width
            
        case let .updateCornerRadius(radius):
            configuration.cornerRadius = radius
            
        case let .updateAnimationParameters(parameters):
            configuration.transitionAnimation = .parameters(parameters)
            
        case let .updateDragGestureEnabled(isEnabled):
            configuration.isDragGestureEnabled = isEnabled
            
        case let .updateInset(inset):
            configuration.inset = inset
            
        case let .updateScaleEffectEnabled(isEnabled):
            configuration.scaleEffect = isEnabled ? .init() : nil
            
        case let .updateScaleEffectX(x):
            configuration.scaleEffect?.xScale = x
            
        case let .updateScaleEffectY(y):
            configuration.scaleEffect?.yScale = y
            
        case let .updateScaleEffectDuration(duration):
            configuration.scaleEffect?.duration = duration
            
        case let .updateScaleAnimationParameters(parameters):
            configuration.scaleEffect?.scalingAnimation = .parameters(parameters)
            
        case let .updateLensDistortion(isEnabled):
            if isEnabled {
                configuration.effects.insert(.lensDistortion)
            } else {
                configuration.effects.remove(.lensDistortion)
            }
            
        case let .updateChromaticAberration(isEnabled):
            if isEnabled {
                configuration.effects.insert(.chromaticAberration)
            } else {
                configuration.effects.remove(.chromaticAberration)
            }
            
        case let .updateRefractionZoneWidth(width):
            configuration.refractionZoneWidth = width
            
        case let .updateRefractionStrength(strength):
            configuration.refractionStrength = strength
            
        case let .updateAberrationZoneWidth(width):
            configuration.aberrationZoneWidth = width
            
        case let .updateAberrationStrength(strength):
            configuration.aberrationStrength = strength
            
        case .reset:
            configuration = .init()
        }
    }
}
    // MARK: - Helpers

extension ExampleViewModel {
    
    /// The bottom padding that content should apply to avoid being obscured by the floating bar.
    /// - Parameters:
    ///   - isCompact: Pass `true` when the vertical size class is compact (e.g. landscape).
    func contentOffset(_ isCompact: Bool) -> CGFloat {
        let itemConfig = floatingTabBarConfig.itemStyles[.regular] ?? ItemConfiguration()
        let insets = isCompact ? itemConfig.edgeInsetsCompact : itemConfig.edgeInsets
        return itemConfig.itemContentHeight(isVerticalCompact: isCompact)
        + insets.top
        + insets.bottom
        + state.tabBar.floatingTabBarState.insets.bottom
    }
}

// MARK: - Configurations

extension ExampleViewModel {

    /// The bar configuration for the floating tab bar.
    private(set) var floatingTabBarConfig: BarConfiguration {
        get { state.tabBar.floatingTabBarState.barConfig }
        set { state.tabBar.floatingTabBarState.barConfig = newValue }
    }

    /// The bar configuration for the pinned tab bar.
    private(set) var pinnedTabBarConfig: BarConfiguration {
        get { state.tabBar.pinnedTabBarState.barConfig }
        set { state.tabBar.pinnedTabBarState.barConfig = newValue }
    }

    /// The bar configuration for the standalone bar.
    private(set) var standaloneBarConfig: BarConfiguration {
        get { state.standalone.barConfiguration }
        set { state.standalone.barConfiguration = newValue }
    }
}
