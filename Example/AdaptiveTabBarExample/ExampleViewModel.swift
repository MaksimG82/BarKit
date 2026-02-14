//
//  ExampleViewModel.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

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
        }
    }
}
