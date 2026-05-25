//
//  IndicatorBindings.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 15.05.26.
//

import SwiftUI
import BarKit

/// Bindings scoped to a single selection indicator configuration.
final class IndicatorBindings: BindingProvider {

    // MARK: - Dependencies

    let viewModel: ExampleViewModel

    /// Key path to the `BarIndicatorState` this binding scope reads from.
    private let stateKeyPath: KeyPath<ExampleState, SelectionIndicatorConfiguration?>

    /// Wraps an `IndicatorIntent` into the correct `ExampleIntent` for this scope.
    private let wrapIntent: (IndicatorIntent) -> ExampleIntent

    // MARK: - Initialization

    init(
        viewModel: ExampleViewModel,
        stateKeyPath: KeyPath<ExampleState, SelectionIndicatorConfiguration?>,
        wrapIntent: @escaping (IndicatorIntent) -> ExampleIntent
    ) {
        self.viewModel = viewModel
        self.stateKeyPath = stateKeyPath
        self.wrapIntent = wrapIntent
    }

    // MARK: - Convenience

    private var configuration: SelectionIndicatorConfiguration {
        viewModel.state[keyPath: stateKeyPath] ?? .init()
    }

    private func send(_ intent: IndicatorIntent) {
        viewModel.send(wrapIntent(intent))
    }

    // MARK: - Color

    /// Binding for the indicator color.
    func color() -> Binding<Color> {
        Binding(
            get: { self.configuration.color },
            set: { self.send(.updateColor($0)) }
        )
    }

    // MARK: - Border

    /// Binding for the border visibility toggle.
    func borderEnabled() -> Binding<Bool> {
        Binding(
            get: { self.configuration.border != nil },
            set: { self.send(.updateBorderEnabled($0)) }
        )
    }

    /// Binding for the border color.
    func borderColor() -> Binding<Color> {
        Binding(
            get: { self.configuration.border?.color ?? .white.opacity(0.3) },
            set: { self.send(.updateBorderColor($0)) }
        )
    }

    /// Binding for the border line width.
    func borderWidth() -> Binding<CGFloat> {
        Binding(
            get: { self.configuration.border?.lineWidth ?? 1 },
            set: { self.send(.updateBorderWidth($0)) }
        )
    }

    /// Binding for the indicator corner radius.
    func cornerRadius() -> Binding<CGFloat> {
        Binding(
            get: { self.configuration.cornerRadius },
            set: { self.send(.updateCornerRadius($0)) }
        )
    }

    // MARK: - Animation

    /// Binding for the transition animation parameters.
    func animationParameters() -> Binding<AnimationParameters> {
        Binding(
            get: {
                if case let .parameters(params) = self.configuration.transitionAnimation {
                    return params
                }
                return .init()
            },
            set: { self.send(.updateAnimationParameters($0)) }
        )
    }

    // MARK: - Drag gesture

    /// Binding for the drag gesture toggle.
    func dragGestureEnabled() -> Binding<Bool> {
        Binding(
            get: { self.configuration.isDragGestureEnabled },
            set: { self.send(.updateDragGestureEnabled($0)) }
        )
    }

    // MARK: - Insets

    /// Binding for the horizontal inset (leading and trailing).
    func indicatorHorizontalInset() -> Binding<CGFloat> {
        Binding(
            get: { self.configuration.inset.leading },
            set: {
                var inset = self.configuration.inset
                inset.leading = $0
                inset.trailing = $0
                self.send(.updateInset(inset))
            }
        )
    }

    /// Binding for the vertical inset (top and bottom).
    func indicatorVerticalInset() -> Binding<CGFloat> {
        Binding(
            get: { self.configuration.inset.top },
            set: {
                var inset = self.configuration.inset
                inset.top = $0
                inset.bottom = $0
                self.send(.updateInset(inset))
            }
        )
    }

    // MARK: - Scale Effect

    /// Binding for the scale effect toggle.
    func scaleEffectEnabled() -> Binding<Bool> {
        Binding(
            get: { self.configuration.scaleEffect != nil },
            set: { self.send(.updateScaleEffectEnabled($0)) }
        )
    }

    /// Binding for the horizontal scale factor.
    func scaleEffectX() -> Binding<CGFloat> {
        Binding(
            get: { self.configuration.scaleEffect?.xScale ?? 1.2 },
            set: { self.send(.updateScaleEffectX($0)) }
        )
    }

    /// Binding for the vertical scale factor.
    func scaleEffectY() -> Binding<CGFloat> {
        Binding(
            get: { self.configuration.scaleEffect?.yScale ?? 1.2 },
            set: { self.send(.updateScaleEffectY($0)) }
        )
    }

    /// Binding for the scale effect reset duration.
    func scaleEffectDuration() -> Binding<Double> {
        Binding(
            get: { self.configuration.scaleEffect?.duration ?? 0.2 },
            set: { self.send(.updateScaleEffectDuration($0)) }
        )
    }

    /// Binding for the scale effect animation parameters.
    func scaleAnimationParameters() -> Binding<AnimationParameters> {
        Binding(
            get: {
                if case let .parameters(params) = self.configuration.scaleEffect?.scalingAnimation {
                    return params
                }
                return .init()
            },
            set: { self.send(.updateScaleAnimationParameters($0)) }
        )
    }
    // MARK: - Lens effects

    /// Binding for the lens distortion toggle.
    func lensDistortionEnabled() -> Binding<Bool> {
        Binding(
            get: { self.configuration.effects.contains(where: { if case .lensDistortion = $0 { return true }; return false }) },
            set: { self.send(.updateLensDistortion($0)) }
        )
    }

    /// Binding for the lens distortion configuration.
    func lensDistortionConfig() -> Binding<LensDistortionConfiguration> {
        Binding(
            get: {
                guard case .lensDistortion(let config) = self.configuration.effects.first(where: { if case .lensDistortion = $0 { return true }; return false })
                else { return .init() }
                return config
            },
            set: { self.send(.updateLensDistortionConfig($0)) }
        )
    }

    /// Binding for the chromatic aberration toggle.
    func chromaticAberrationEnabled() -> Binding<Bool> {
        Binding(
            get: { self.configuration.effects.contains(where: { if case .chromaticAberration = $0 { return true }; return false }) },
            set: { self.send(.updateChromaticAberration($0)) }
        )
    }

    /// Binding for the chromatic aberration configuration.
    func chromaticAberrationConfig() -> Binding<ChromaticAberrationConfiguration> {
        Binding(
            get: {
                guard case .chromaticAberration(let config) = self.configuration.effects.first(where: { if case .chromaticAberration = $0 { return true }; return false })
                else { return .init() }
                return config
            },
            set: { self.send(.updateChromaticAberrationConfig($0)) }
        )
    }
}
