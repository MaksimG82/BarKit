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
 
        case let .indicator(indicatorIntent):
            handle(indicatorIntent)
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
            
        case let .update(materilaSelection):
            switch state.tabBar.mode {
            case .floating:
                state.tabBar.floatingTabBarMaterialSelection = materilaSelection
            case .pinned:
                state.tabBar.pinnedTabBarMaterialSelection = materilaSelection
            }
            
        case let .updateHapticFeedbackEnabled(isEnabled):
            floatingTabBarConfig.hapticFeedback = isEnabled ? .selection : nil
            pinnedTabBarConfig.hapticFeedback = isEnabled ? .selection : nil

        case let .updateHapticFeedback(feedback):
            floatingTabBarConfig.hapticFeedback = feedback
            pinnedTabBarConfig.hapticFeedback = feedback
            
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
            
        case .reset:
            state.standalone.barConfiguration = .init()
        }
    }
    
    func handle(_ intent: IndicatorIntent) {
        switch intent {
        case let .updateColor(color):
            state.indicator.indicatorConfig.color = color
            
        case let .updateBorderEnabled(isEnabled):
            state.indicator.indicatorConfig.border = isEnabled ? .init() : nil

        case let .updateBorderColor(color):
            state.indicator.indicatorConfig.border?.color = color

        case let .updateBorderWidth(width):
            state.indicator.indicatorConfig.border?.lineWidth = width
            
        case let .updateCornerRadius(radius):
            state.indicator.indicatorConfig.cornerRadius = radius
            
        case let .updateAnimationParameters(parameters):
            state.indicator.animationParameters = parameters
            state.indicator.indicatorConfig.transitionAnimation = parameters.makeAnimation()
        
        case let .updateDragGestureEnabled(isEnabled):
            state.indicator.indicatorConfig.isDragGestureEnabled = isEnabled
            
        case let .updateInset(inset):
            state.indicator.indicatorConfig.inset = inset
            
        case let .updateScaleEffectEnabled(isEnabled):
            state.indicator.indicatorConfig.scaleEffect = isEnabled ? .init() : nil

        case let .updateScaleEffectX(x):
            state.indicator.indicatorConfig.scaleEffect?.xScale = x

        case let .updateScaleEffectY(y):
            state.indicator.indicatorConfig.scaleEffect?.yScale = y

        case let .updateScaleEffectDuration(duration):
            state.indicator.indicatorConfig.scaleEffect?.duration = duration

        case let .updateScaleAnimationParameters(parameters):
            state.indicator.scaleAnimationParameters = parameters
            state.indicator.indicatorConfig.scaleEffect?.animation = parameters.makeAnimation() ?? .linear

        case let .updateLensDistortion(isEnabled):
            if isEnabled {
                state.indicator.indicatorConfig.effects.insert(.lensDistortion)
            } else {
                state.indicator.indicatorConfig.effects.remove(.lensDistortion)
            }

        case let .updateChromaticAberration(isEnabled):
            if isEnabled {
                state.indicator.indicatorConfig.effects.insert(.chromaticAberration)
            } else {
                state.indicator.indicatorConfig.effects.remove(.chromaticAberration)
            }

        case let .updateRefractionZoneWidth(width):
            state.indicator.indicatorConfig.refractionZoneWidth = width

        case let .updateRefractionStrength(strength):
            state.indicator.indicatorConfig.refractionStrength = strength

        case let .updateAberrationZoneWidth(width):
            state.indicator.indicatorConfig.aberrationZoneWidth = width

        case let .updateAberrationStrength(strength):
            state.indicator.indicatorConfig.aberrationStrength = strength
            
        case .reset:
            state.indicator = .init()
            
        }
    }
}
