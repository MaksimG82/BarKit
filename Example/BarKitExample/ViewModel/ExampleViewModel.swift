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
final class OldExampleViewModel {
    // MARK: - State
    
    /// The single source of truth for the view.
    private(set) var state = OldExampleState()
    
    // MARK: - Intent Handling
    
    /// Entry point for all user actions.
    /// - Parameter intent: The user intent to process.
    func send(_ intent: OldExampleIntent) {
        switch intent {
        case let .selectTab(item):
            state.selectedTab = item
            
        case let .updateLayoutStyle(style):
            switch style {
            case .pinned:
                state.config.style = .pinned
            case .floating:
                state.config.style = .floating(.init())
            }
            
        case let .updateColor(colorType, color):
            switch colorType {
            case .background:
                state.config.backgroundColor = color
            case .tint:
                state.config.tintColor = color
            case .unselected:
                state.config.unselectedColor = color
            }
            
        case let .updateMaterial(material):
            state.config.backgroundMaterial = material
            
        case let .updateTextStyle(textStyle):
            state.config.textStyle = textStyle
            
        case let .updateRegularIconSize(size):
            state.config.regularIconSideLength = size
            
        case let .updateProminentIconSize(size):
            state.config.prominentIconSideLength = size
            
        case let .updateCompactIconScale(scale):
            state.config.compactIconScale = scale
            
        case let .updateSelectedIconScale(scale):
            state.config.selectedIconScale = scale
            
        case let .updateItems(items):
            guard let firstItem = items.first else { return }
            
            let targetItem = items.first(where: { $0.type == state.selectedTab.type })
            state.items = items
            state.selectedTab = targetItem ?? firstItem
            
        case let .toggleProminentStyle(tabType):
            if let index = state.items.firstIndex(where: { $0.type == tabType }) {
                let currentStyle = state.items[index].style
                state.items[index].style = (currentStyle == .prominent) ? .regular : .prominent
            }
            
        case let .updateTabSpacing(spacing):
            state.config.tabSpacing = spacing
            
        case let .updateIconTitleSpacing(spacing):
            state.config.iconTitleSpacing = spacing
            
        case let .updateTabItemTopPadding(padding):
            state.config.tabItemTopPadding = padding
            
        case let .updateTabItemBottomPadding(padding):
            state.config.tabItemBottomPadding = padding
            
        case let .updateTabItemTopPaddingCompact(padding):
            state.config.tabItemTopPaddingCompact = padding
            
        case let .updateTabItemBottomPaddingCompact(padding):
            state.config.tabItemBottomPaddingCompact = padding
            
        case let .updateTabItem(animation):
            state.config.tabItemAnimation = animation
            
        case let .updateIndcatorTransition(animation):
            state.config.floatingConfig?.indicatorTransitionAnimation = animation
            
        case let .updateIndicator(scaleEffect):
            state.config.floatingConfig?.tabSelectionScaleEffect = scaleEffect
            
        case let .updateFloatingLayout(floatingLayoutSettings):
            switch floatingLayoutSettings {
            case let .bottomInset(inset):
                state.config.floatingConfig?.bottomInset = inset
            case let .leadingInset(inset):
                state.config.floatingConfig?.leadingInset = inset
            case let .trailingInset(inset):
                state.config.floatingConfig?.trailingInset = inset
            case let .cornerRadius(radius):
                state.config.floatingConfig?.cornerRadius = radius
            case let .shadowRadius(radius):
                state.config.floatingConfig?.shadowRadius = radius
            }
            
        case .toggleDebugLayout:
            state.isDebugLayoutEnabled.toggle()
            
        case .resetState:
            state = .init()
        }
    }
}


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
}
 
// MARK: - Private
 
private extension ExampleViewModel {
 
    func handle(_ intent: TabBarIntent) {
        switch intent {
        case let .switchMode(mode):
            if mode != state.tabBar.mode {
                state.instanceID = UUID()
            }
            state.tabBar.mode = mode
        case .floating:
            break
        case .pinned:
            break
        }
    }
 
    func handle(_ intent: StandaloneIntent) {
        switch intent {
        case .horizontal:
            break
        case .vertical:
            break
        @unknown default:
            break
        }
    }
 
    func handle(_ intent: IndicatorIntent) {}
}
