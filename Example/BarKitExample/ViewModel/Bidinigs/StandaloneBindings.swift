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
    
    // MARK: - Background

    /// The current tint or solid color extracted from the active background configuration.
    private var currentBackgroundColor: Color {
        switch viewModel.state.standalone.barConfiguration.background {
        case let .color(color):        return color
        case let .material(_, tint):   return tint
        case let .customBlur(_, tint): return tint
        }
    }

    /// Binding for the full `BarBackground`.
    func background() -> Binding<BarBackground> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.background },
            set: { self.viewModel.send(.standalone(.updateBackground($0))) }
        )
    }

    /// Binding for the background type, preserving current tint on switch.
    func backgroundType() -> Binding<BarBackgroundType> {
        Binding(
            get: {
                switch self.background().wrappedValue {
                case .color:      .color
                case .material:   .material
                case .customBlur: .customBlur
                }
            },
            set: { newType in
                switch newType {
                case .color:
                    self.background().wrappedValue = .color(self.currentBackgroundColor)
                case .material:
                    self.background().wrappedValue = .material(.ultraThin, tint: self.currentBackgroundColor)
                case .customBlur:
                    self.background().wrappedValue = .customBlur(.init(), tint: self.currentBackgroundColor)
                }
            }
        )
    }

    /// Binding for the tint or solid color, preserving the current background type.
    func backgroundColor() -> Binding<Color> {
        Binding(
            get: { self.currentBackgroundColor },
            set: { newColor in
                switch self.background().wrappedValue {
                case .color:
                    self.background().wrappedValue = .color(newColor)
                case let .material(material, _):
                    self.background().wrappedValue = .material(material, tint: newColor)
                case let .customBlur(config, _):
                    self.background().wrappedValue = .customBlur(config, tint: newColor)
                }
            }
        )
    }

    /// Binding for the material selection.
    func materialSelection() -> Binding<BarMaterial> {
        Binding(
            get: {
                if case let .material(barMaterial, _) = self.viewModel.standaloneBarConfig.background {
                    return barMaterial
                }
                return .ultraThin
            },
            set: { barMaterial in
                let tint = self.currentBackgroundColor
                self.viewModel.send(.standalone(.updateBackground(.material(barMaterial, tint: tint))))
            }
        )
    }
    
    // MARK: - Haptic Feedback

    /// Binding for the haptic feedback enabled toggle.
    func hapticFeedbackEnabled() -> Binding<Bool> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.hapticFeedback != nil },
            set: { self.viewModel.send(.standalone(.updateHapticFeedbackEnabled($0))) }
        )
    }

    /// Binding for the haptic feedback style picker.
    func hapticFeedback() -> Binding<HapticFeedback> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.hapticFeedback ?? .selection },
            set: { self.viewModel.send(.standalone(.updateHapticFeedback($0))) }
        )
    }
    
    // MARK: - Item Configuration

    /// Binding for the full regular `ItemConfiguration`.
    func regularItemConfig() -> Binding<ItemConfiguration> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.itemStyles[.regular] ?? .init() },
            set: { self.viewModel.send(.standalone(.updateRegularItemConfig($0))) }
        )
    }

    /// Binding for a single property of the regular `ItemConfiguration`.
    func regularItemConfig<T>(_ keyPath: WritableKeyPath<ItemConfiguration, T>) -> Binding<T> {
        binding(
            get: { self.viewModel.state.standalone.barConfiguration.itemStyles[.regular] ?? .init() },
            keyPath: keyPath,
            send: { .standalone(.updateRegularItemConfig($0)) }
        )
    }
    
    // MARK: - Item Content Axis

    /// Binding for the item content layout axis arrangement based on the current mode.
    func itemContentAxis() -> Binding<ItemContentAxis?> {
        Binding(
            get: {
                self.viewModel.state.standalone.barConfiguration.itemContentAxis
            },
            set: { self.viewModel.send(.standalone(.updateItemContentAxis($0))) }
        )
    }
    
    // MARK: - Alignment

    /// Binding for the item alignment along the cross-axis of the bar.
    func itemAlignment() -> Binding<BarItemAlignment> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.itemAlignment },
            set: { self.viewModel.send(.standalone(.updateItemAlignment($0))) }
        )
    }

    /// Binding for the icon and title alignment within each item.
    func itemContentAlignment() -> Binding<BarItemAlignment> {
        Binding(
            get: { self.viewModel.state.standalone.barConfiguration.itemContentAlignment },
            set: { self.viewModel.send(.standalone(.updateItemContentAlignment($0))) }
        )
    }
}
