//
//  IndicatorBindings.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 15.05.26.
//

import SwiftUI
import BarKit

/// Bindings scoped to the Indicator screen.
final class IndicatorBindings: BindingProvider {
    
    // MARK: - Dependencies
    
    let viewModel: ExampleViewModel
    
    // MARK: - Initialization
    
    init(viewModel: ExampleViewModel) {
        self.viewModel = viewModel
    }
}
