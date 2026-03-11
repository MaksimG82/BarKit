//
//  ExampleViewModel.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import AdaptiveTabBar
import Observation
import SwiftUI

/// Manages the state and logic for the Example application.
@available(iOS 17.0, *)
@Observable
final class ExampleViewModel {
    // MARK: - State

    /// The single source of truth for the view.
    /// Published as private(set) to ensure updates only happen via intents.
    private(set) var state = ExampleState()

    // MARK: - Intent Handling

    /// Entry point for all user actions.
    /// - Parameter intent: The user intent to process.
    func send(_ intent: ExampleIntent) {
        switch intent {
        case let .selectTab(item):
            state.selectedTab = item

        case let .toggleDebug(enabled):
            state.isDebugEnabled = enabled

        case let .updateColor(colorType, color):
            switch colorType {
            case .background:
                state.config.backgroundColor = color
            case .tint:
                state.config.tintColor = color
            case .unselected:
                state.config.unselectedColor = color
            }

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
            state.items = items
            guard let firstItem = items.first else {
                fatalError("")
            }
            state.selectedTab = firstItem

        case let .updateTabSpacing(spacing):
            state.config.tabSpacing = spacing

        case let .updateIconTitleSpacing(spacing):
            state.config.iconTitleSpacing = spacing

        case let .updateTabItemVerticalPadding(padding):
            state.config.tabItemVerticalPadding = padding

        case let .updateTabItemVerticalPaddingCompact(padding):
            state.config.tabItemVerticalPaddingCompact = padding
        }
    }
}
