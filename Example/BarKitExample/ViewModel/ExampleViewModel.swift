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
                floatingTabBarConfiguration.background = background
            case .pinned:
                pinnedTabBarConfiguration.background = background
            }
            
        case let .updateRegularItemConfiguration(configuration):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfiguration.itemStyles[.regular] = configuration
            case .pinned:
                pinnedTabBarConfiguration.itemStyles[.regular] = configuration
            }
            
        case let .updateItemContentAxis(axis):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfiguration.itemContentAxis = axis
            case .pinned:
                pinnedTabBarConfiguration.itemContentAxis = axis
            }
            
        case let .updateHapticFeedbackEnabled(isEnabled):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfiguration.hapticFeedback = isEnabled ? .selection : nil
            case .pinned:
                pinnedTabBarConfiguration.hapticFeedback = isEnabled ? .selection : nil
            }
            
        case let .updateHapticFeedback(feedback):
            switch state.tabBar.mode {
            case .floating:
                floatingTabBarConfiguration.hapticFeedback = feedback
            case .pinned:
                pinnedTabBarConfiguration.hapticFeedback = feedback
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
            floatingTabBarConfiguration.cornerRadius = cornerRadius
            
        case let .updateShadow(shadow):
            floatingTabBarConfiguration.shadow = shadow
            
        case let .indicator(indicatorIntent):
            var indicator = floatingTabBarConfiguration.indicator ?? .init()
            handle(indicatorIntent, indicatorConfiguration: &indicator)
            floatingTabBarConfiguration.indicator = indicator
        }
    }
    // MARK: - PinnnedTabBar
    
    
    func handle(_ intent: PinnedTabBarIntent) {
        switch intent {
        case let .updateProminentItemConfiguration(configuration):
            state.tabBar.pinnedTabBarState.barConfiguration.itemStyles[.prominent] = configuration
            
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
            var indicator = standaloneBarConfiguration.indicator ?? .init()
            handle(indicatorIntent, indicatorConfiguration: &indicator)
            standaloneBarConfiguration.indicator = indicator
            
        case let .updateCornerRadius(radius):
            standaloneBarConfiguration.cornerRadius = radius
            
        case let .updateShadow(shadow):
            standaloneBarConfiguration.shadow = shadow
            
        case let .updateBackground(background):
            standaloneBarConfiguration.background = background
            
        case let .updateHapticFeedbackEnabled(isEnabled):
            standaloneBarConfiguration.hapticFeedback = isEnabled ? .selection : nil
            
        case let .updateHapticFeedback(feedback):
            standaloneBarConfiguration.hapticFeedback = feedback
            
        case let .updateRegularItemConfiguration(configuration):
            standaloneBarConfiguration.itemStyles[.regular] = configuration
            
        case let .updateItemContentAxis(axis):
            standaloneBarConfiguration.itemContentAxis = axis
            
        case let .updateItemAlignment(alignment):
            standaloneBarConfiguration.itemAlignment = alignment
            
        case let .updateItemContentAlignment(alignment):
            standaloneBarConfiguration.itemContentAlignment = alignment
            
        case .reset:
            state.standalone = .init()
        }
    }
    
    // MARK: - Indicator
    
    func handle(
        _ intent: IndicatorIntent,
        indicatorConfiguration: inout SelectionIndicatorConfiguration
    ) {
        switch intent {
        case let .updateColor(color):
            indicatorConfiguration.color = color
            
        case let .updateBorderEnabled(isEnabled):
            indicatorConfiguration.border = isEnabled ? .init() : nil
            
        case let .updateBorderColor(color):
            indicatorConfiguration.border?.color = color
            
        case let .updateBorderWidth(width):
            indicatorConfiguration.border?.lineWidth = width
            
        case let .updateCornerRadius(radius):
            indicatorConfiguration.cornerRadius = radius
            
        case let .updateAnimationParameters(parameters):
            indicatorConfiguration.transitionAnimation = .parameters(parameters)
            
        case let .updateDragGestureEnabled(isEnabled):
            indicatorConfiguration.isDragGestureEnabled = isEnabled
            
        case let .updateInset(inset):
            indicatorConfiguration.inset = inset
            
        case let .updateScaleEffectEnabled(isEnabled):
            indicatorConfiguration.scaleEffect = isEnabled ? .init() : nil
            
        case let .updateScaleEffectX(x):
            indicatorConfiguration.scaleEffect?.xScale = x
            
        case let .updateScaleEffectY(y):
            indicatorConfiguration.scaleEffect?.yScale = y
            
        case let .updateScaleEffectDuration(duration):
            indicatorConfiguration.scaleEffect?.duration = duration
            
        case let .updateScaleAnimationParameters(parameters):
            indicatorConfiguration.scaleEffect?.scalingAnimation = .parameters(parameters)
            
        case let .updateLensDistortion(isEnabled):
            if isEnabled {
                indicatorConfiguration.effects.append(.lensDistortion())
            } else {
                indicatorConfiguration.effects.removeAll { if case .lensDistortion = $0 { return true }; return false }
            }
            
        case let .updateLensDistortionConfiguration(effectConfiguration):
            if let index = indicatorConfiguration.effects
                .firstIndex(where: {
                    if case .lensDistortion = $0 { return true }
                    return false
                }) {
                indicatorConfiguration.effects[index] = .lensDistortion(effectConfiguration)
            }
            
        case let .updateChromaticAberration(isEnabled):
            if isEnabled {
                indicatorConfiguration.effects.append(.chromaticAberration())
            } else {
                indicatorConfiguration.effects
                    .removeAll {
                        if case .chromaticAberration = $0 { return true }
                        return false
                    }
            }
            
        case let .updateChromaticAberrationConfiguration(effectConfiguration):
            if let index = indicatorConfiguration.effects
                .firstIndex(where: {
                    if case .chromaticAberration = $0 { return true }
                    return false
                }) {
                indicatorConfiguration.effects[index] = .chromaticAberration(effectConfiguration)
            }
            
        case .reset:
            indicatorConfiguration = .init()
        }
    }
}
// MARK: - Helpers

extension ExampleViewModel {
    
    /// The bottom padding that content should apply to avoid being obscured by the floating bar.
    /// - Parameters:
    ///   - isCompact: Pass `true` when the vertical size class is compact (e.g. landscape).
    func contentOffset(_ isCompact: Bool) -> CGFloat {
        let itemConfiguration = floatingTabBarConfiguration.itemStyles[.regular] ?? ItemConfiguration()
        let insets = isCompact ? itemConfiguration.edgeInsetsCompact : itemConfiguration.edgeInsets
        return itemConfiguration.itemContentHeight(isVerticalCompact: isCompact)
        + insets.top
        + insets.bottom
        + state.tabBar.floatingTabBarState.insets.bottom
    }
}

// MARK: - Configurations

extension ExampleViewModel {
    
    /// The bar configuration for the floating tab bar.
    private(set) var floatingTabBarConfiguration: BarConfiguration {
        get { state.tabBar.floatingTabBarState.barConfiguration }
        set { state.tabBar.floatingTabBarState.barConfiguration = newValue }
    }
    
    /// The bar configuration for the pinned tab bar.
    private(set) var pinnedTabBarConfiguration: BarConfiguration {
        get { state.tabBar.pinnedTabBarState.barConfiguration }
        set { state.tabBar.pinnedTabBarState.barConfiguration = newValue }
    }
    
    /// The bar configuration for the standalone bar.
    private(set) var standaloneBarConfiguration: BarConfiguration {
        get { state.standalone.barConfiguration }
        set { state.standalone.barConfiguration = newValue }
    }
}
