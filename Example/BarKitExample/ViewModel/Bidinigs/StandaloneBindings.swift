//
//  StandaloneBindings.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI
import BarKit

/// Bindings scoped to the Standalone screen.
final class StandaloneBindings: BindingProvider {

    // MARK: - Dependencies

    let viewModel: ExampleViewModel

    // MARK: - Initialization

    init(viewModel: ExampleViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Selection

    /// Binding for the currently selected standalone bar item.
    func selectedItem() -> Binding<ExampleBarItem> {
        Binding(
            get: { self.viewModel.state.standalone.selectedItem },
            set: { self.viewModel.send(.standalone(.selectItem($0))) }
        )
    }
    
    // MARK: - Axis

    /// Binding for the bar layout axis.
    func axis() -> Binding<BarConfiguration.Axis> {
        binding(
            get: { self.viewModel.state.standalone.barConfiguration },
            keyPath: \.axis,
            send: { .standalone(.updateAxis($0.axis)) }
        )
    }
}
