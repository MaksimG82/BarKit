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
    
    // MARK: - Corner radius
    
    /// Binding for the corner radius of the bar.
    func cornerRadius() -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.state.standalone.barConfiguration },
            keyPath: \.cornerRadius,
            send: { .standalone(.updateCornerRadius($0.cornerRadius)) }
        )
    }
    
    // MARK: - Shadow

    /// Binding for the shadow visibility of the bar.
    func shadowEnabled() -> Binding<Bool> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.shadow != nil },
            set: { self.viewModel.send(.standalone(.updateShadow($0 ? .init() : nil))) }
        )
    }

    /// Binding for the shadow color of the bar.
    func shadowColor() -> Binding<Color> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.shadow?.color ?? .black.opacity(0.2) },
            set: {
                var shadow = self.viewModel.state.standalone.barConfiguration.shadow ?? .init()
                shadow.color = $0
                self.viewModel.send(.standalone(.updateShadow(shadow)))
            }
        )
    }

    /// Binding for a single property of the bar shadow configuration.
    func shadow(_ keyPath: WritableKeyPath<ShadowConfiguration, CGFloat>) -> Binding<CGFloat> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.shadow?[keyPath: keyPath] ?? 0 },
            set: {
                var shadow = self.viewModel.state.standalone.barConfiguration.shadow ?? .init()
                shadow[keyPath: keyPath] = $0
                self.viewModel.send(.standalone(.updateShadow(shadow)))
            }
        )
    }
}
