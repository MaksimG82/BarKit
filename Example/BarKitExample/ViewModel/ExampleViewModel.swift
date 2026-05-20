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
 
    // MARK: - Intent Handling
 
    /// Entry point for all user actions.
    func send(_ intent: ExampleIntent) {
        switch intent {
 
        case let .selectTab(item):
            state.selectedTab = item
 
        case .toggleDebugLayout:
            state.isDebugLayoutEnabled.toggle()
 
        case let .tabBar(tabBarIntent):
            handle(tabBarIntent)
 
        case let .standalone(standaloneIntent):
            handle(standaloneIntent)
        }
    }
    
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
 
// MARK: - Private
 
private extension ExampleViewModel {
 
    func handle(_ intent: TabBarIntent) {
        switch intent {
        case let .switchMode(mode):
            if mode != state.tabBar.mode {
                state.instanceID = UUID()
                if mode == .floating {
                    state.tabBarItems = state.tabBarItems.map { $0.withStyle(.regular) }
                }
            }
            state.tabBar.mode = mode
            
        case let .updateMaterialSelection(materilaSelection):
            switch state.tabBar.mode {
            case .floating:
                state.tabBar.floatingTabBarMaterialSelection = materilaSelection
            case .pinned:
                state.tabBar.pinnedTabBarMaterialSelection = materilaSelection
            }
            
        case let .updateHapticFeedbackEnabled(isEnabled):
            switch state.tabBar.mode {
            case .floating: floatingTabBarConfig.hapticFeedback = isEnabled ? .selection : nil
            case .pinned:   pinnedTabBarConfig.hapticFeedback = isEnabled ? .selection : nil
            }

        case let .updateHapticFeedback(feedback):
            switch state.tabBar.mode {
            case .floating: floatingTabBarConfig.hapticFeedback = feedback
            case .pinned:   pinnedTabBarConfig.hapticFeedback = feedback
            }
        case let .indicator(indicatorIntent):
            handle(indicatorIntent, state: &state.tabBar.indicator)
            
        case let .floating(floatingIntent):
            switch floatingIntent {
            case let .updateInsets(insets):
                state.tabBar.floatingTabBarState.insets = insets
                
            case let .updateInsetsCompact(insets):
                state.tabBar.floatingTabBarState.insetsCompact = insets
                
            case let .updateBackground(background):
                floatingTabBarConfig.background = background
            
            case let .updateCornerRadius(cornerRadius):
                floatingTabBarConfig.cornerRadius = cornerRadius
            
            case let .updateShadow(shadow):
                floatingTabBarConfig.shadow = shadow
            }
            
        case let .pinned(pinnedIntent):
            switch pinnedIntent {
            case let .updateBackground(background):
                pinnedTabBarConfig.background = background
            }
            
        case let .updateRegularItemConfig(config):
            state.tabBar.floatingTabBarState.barConfig.itemStyles[.regular] = config
            state.tabBar.pinnedTabBarState.barConfig.itemStyles[.regular] = config

        case let .updateProminentItemConfig(config):
            state.tabBar.pinnedTabBarState.barConfig.itemStyles[.prominent] = config
            
        case let .updateTabItemStyle(item, style):
            guard let index = state.tabBarItems.firstIndex(where: { $0.id == item.id }) else { return }
            state.tabBarItems[index].style = style
        
        case let .updateItemContentAxis(axis):
            floatingTabBarConfig.itemContentAxis = axis
            pinnedTabBarConfig.itemContentAxis = axis
            
        case .reset:
            state.tabBar = .init()
            state.instanceID = UUID()
        }
    }
    
    func handle(_ intent: StandaloneIntent) {
        switch intent {
        case let .selectItem(item):
            state.standalone.selectedItem = item
            
        case let .updateAxis(axis):
            state.standalone.barConfiguration.axis = axis
            
        case let .indicator(indicatorIntent):
            handle(indicatorIntent, state: &state.standalone.indicator)
            
        case let .updateCornerRadius(radius):
            state.standalone.barConfiguration.cornerRadius = radius

        case let .updateShadow(shadow):
            state.standalone.barConfiguration.shadow = shadow
            
        case .reset:
            state.standalone.barConfiguration = .init()
        }
    }
    
    func handle(_ intent: IndicatorIntent, state: inout BarIndicatorState) {
        switch intent {
        case let .updateColor(color):
            state.configuration.color = color
            
        case let .updateBorderEnabled(isEnabled):
            state.configuration.border = isEnabled ? .init() : nil

        case let .updateBorderColor(color):
            state.configuration.border?.color = color

        case let .updateBorderWidth(width):
            state.configuration.border?.lineWidth = width
            
        case let .updateCornerRadius(radius):
            state.configuration.cornerRadius = radius
            
        case let .updateAnimationParameters(parameters):
            state.animationParameters = parameters
            state.configuration.transitionAnimation = parameters.makeAnimation()
        
        case let .updateDragGestureEnabled(isEnabled):
            state.configuration.isDragGestureEnabled = isEnabled
            
        case let .updateInset(inset):
            state.configuration.inset = inset
            
        case let .updateScaleEffectEnabled(isEnabled):
            state.configuration.scaleEffect = isEnabled ? .init() : nil

        case let .updateScaleEffectX(x):
            state.configuration.scaleEffect?.xScale = x

        case let .updateScaleEffectY(y):
            state.configuration.scaleEffect?.yScale = y

        case let .updateScaleEffectDuration(duration):
            state.configuration.scaleEffect?.duration = duration

        case let .updateScaleAnimationParameters(parameters):
            state.scaleAnimationParameters = parameters
            state.configuration.scaleEffect?.animation = parameters.makeAnimation() ?? .linear

        case let .updateLensDistortion(isEnabled):
            if isEnabled {
                state.configuration.effects.insert(.lensDistortion)
            } else {
                state.configuration.effects.remove(.lensDistortion)
            }

        case let .updateChromaticAberration(isEnabled):
            if isEnabled {
                state.configuration.effects.insert(.chromaticAberration)
            } else {
                state.configuration.effects.remove(.chromaticAberration)
            }

        case let .updateRefractionZoneWidth(width):
            state.configuration.refractionZoneWidth = width

        case let .updateRefractionStrength(strength):
            state.configuration.refractionStrength = strength

        case let .updateAberrationZoneWidth(width):
            state.configuration.aberrationZoneWidth = width

        case let .updateAberrationStrength(strength):
            state.configuration.aberrationStrength = strength
            
        case .reset:
            state = .init()
            
        }
    }
}
