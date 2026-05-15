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
    
    // MARK: - Color
    
    func color() -> Binding<Color> {
        binding(
            get: { self.viewModel.state.indicator.indicatorConfig },
            keyPath: \.color,
            send: { .indicator(.updateColor($0.color)) }
        )
    }
    
    // MARK: - Border

    /// Binding for the border visibility toggle.
    func borderEnabled() -> Binding<Bool> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.border != nil },
            set: { self.viewModel.send(.indicator(.updateBorderEnabled($0))) }
        )
    }

    /// Binding for the border color.
    func borderColor() -> Binding<Color> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.border?.color ?? .white.opacity(0.3) },
            set: { self.viewModel.send(.indicator(.updateBorderColor($0))) }
        )
    }

    /// Binding for the border line width.
    func borderWidth() -> Binding<CGFloat> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.border?.lineWidth ?? 1 },
            set: { self.viewModel.send(.indicator(.updateBorderWidth($0))) }
        )
    }
    
    /// Binding for the indicator corner radius.
    func cornerRadius() -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.state.indicator.indicatorConfig },
            keyPath: \.cornerRadius,
            send: { .indicator(.updateCornerRadius($0.cornerRadius)) }
        )
    }
    
    // MARK: - Animation

    /// Binding for the full animation parameters.
    func animationParameters() -> Binding<AnimationParameters> {
        binding(
            get: { self.viewModel.state.indicator.animationParameters },
            keyPath: \.self,
            send: { .indicator(.updateAnimationParameters($0)) }
        )
    }

    // MARK: - Drag gesture
    
    /// Binding for the drag gesture toggle.
    func dragGestureEnabled() -> Binding<Bool> {
        binding(
            get: { self.viewModel.state.indicator.indicatorConfig },
            keyPath: \.isDragGestureEnabled,
            send: { .indicator(.updateDragGestureEnabled($0.isDragGestureEnabled)) }
        )
    }
    
    // MARK: - Insets
    
    /// Binding for the horizontal inset (leading and trailing).
    func indicatorHorizontalInset() -> Binding<CGFloat> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.inset.leading },
            set: {
                var inset = self.viewModel.state.indicator.indicatorConfig.inset
                inset.leading = $0
                inset.trailing = $0
                self.viewModel.send(.indicator(.updateInset(inset)))
            }
        )
    }
    
    /// Binding for the vertical inset (top and bottom).
    func indicatorVerticalInset() -> Binding<CGFloat> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.inset.top },
            set: {
                var inset = self.viewModel.state.indicator.indicatorConfig.inset
                inset.top = $0
                inset.bottom = $0
                self.viewModel.send(.indicator(.updateInset(inset)))
            }
        )
    }
    
    // MARK: - Scale Effect

    /// Binding for the scale effect toggle.
    func scaleEffectEnabled() -> Binding<Bool> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.scaleEffect != nil },
            set: { self.viewModel.send(.indicator(.updateScaleEffectEnabled($0))) }
        )
    }

    /// Binding for the horizontal scale factor.
    func scaleEffectX() -> Binding<CGFloat> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.scaleEffect?.xScale ?? 1.2 },
            set: { self.viewModel.send(.indicator(.updateScaleEffectX($0))) }
        )
    }

    /// Binding for the vertical scale factor.
    func scaleEffectY() -> Binding<CGFloat> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.scaleEffect?.yScale ?? 1.2 },
            set: { self.viewModel.send(.indicator(.updateScaleEffectY($0))) }
        )
    }

    /// Binding for the scale effect reset duration.
    func scaleEffectDuration() -> Binding<Double> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.scaleEffect?.duration ?? 0.2 },
            set: { self.viewModel.send(.indicator(.updateScaleEffectDuration($0))) }
        )
    }

    /// Binding for the scale effect animation parameters.
    func scaleAnimationParameters() -> Binding<AnimationParameters> {
        binding(
            get: { self.viewModel.state.indicator.scaleAnimationParameters },
            keyPath: \.self,
            send: { .indicator(.updateScaleAnimationParameters($0)) }
        )
    }
    
    // MARK: - Lens effects
    
    /// Binding for the lens distortion toggle.
    func lensDistortionEnabled() -> Binding<Bool> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.effects.contains(.lensDistortion) },
            set: { self.viewModel.send(.indicator(.updateLensDistortion($0))) }
        )
    }

    /// Binding for the chromatic aberration toggle.
    func chromaticAberrationEnabled() -> Binding<Bool> {
        Binding(
            get: { self.viewModel.state.indicator.indicatorConfig.effects.contains(.chromaticAberration) },
            set: { self.viewModel.send(.indicator(.updateChromaticAberration($0))) }
        )
    }

    /// Binding for the refraction zone width.
    func refractionZoneWidth() -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.state.indicator.indicatorConfig },
            keyPath: \.refractionZoneWidth,
            send: { .indicator(.updateRefractionZoneWidth($0.refractionZoneWidth)) }
        )
    }

    /// Binding for the refraction strength.
    func refractionStrength() -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.state.indicator.indicatorConfig },
            keyPath: \.refractionStrength,
            send: { .indicator(.updateRefractionStrength($0.refractionStrength)) }
        )
    }

    /// Binding for the aberration zone width.
    func aberrationZoneWidth() -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.state.indicator.indicatorConfig },
            keyPath: \.aberrationZoneWidth,
            send: { .indicator(.updateAberrationZoneWidth($0.aberrationZoneWidth)) }
        )
    }

    /// Binding for the aberration strength.
    func aberrationStrength() -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.state.indicator.indicatorConfig },
            keyPath: \.aberrationStrength,
            send: { .indicator(.updateAberrationStrength($0.aberrationStrength)) }
        )
    }

}
