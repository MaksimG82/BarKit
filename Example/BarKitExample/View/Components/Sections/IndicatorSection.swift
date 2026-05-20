//
//  IndicatorSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 15.05.26.
//

import SwiftUI
import BarKit

/// A reusable set of sections for configuring a selection indicator.
struct IndicatorSection: View {

    let viewModel: ExampleViewModel
    let bindings: IndicatorBindings
    let preview: AnyView
    private let stateKeyPath: KeyPath<ExampleState, BarIndicatorState>

    private var indicatorState: BarIndicatorState {
        viewModel.state[keyPath: stateKeyPath]
    }

    init(
        viewModel: ExampleViewModel,
        bindings: IndicatorBindings,
        stateKeyPath: KeyPath<ExampleState, BarIndicatorState>,
        @ViewBuilder preview: @escaping () -> some View = { EmptyView() }
     ) {
        self.viewModel = viewModel
        self.bindings = bindings
        self.stateKeyPath = stateKeyPath
        self.preview = AnyView(preview())
    }
    
    var body: some View {
        preview
        dragGestureSection
        insetSection
        appearanceLink
        transitionAnimationLink
        scaleEffectLink
        lensEffectsLink
    }
}

// MARK: - Navigation links

private extension IndicatorSection {

    var appearanceLink: some View {
        settingsLink("Appearance", viewModel: viewModel) {
            preview
            colorSection
            borderSection
            cornerRadiusSection
        }
    }

    var transitionAnimationLink: some View {
        settingsLink("Transition animation", viewModel: viewModel) {
            preview
            animationSection
        }
    }

    var scaleEffectLink: some View {
        settingsLink("Scale effect", viewModel: viewModel) {
            preview
            scaleEffectSection
            scaleEffectAnimationSettings
        }
    }

    var lensEffectsLink: some View {
        settingsLink("Lens effect", viewModel: viewModel) {
            preview
            effectsSection
        }
    }
}

// MARK: - View Components

private extension IndicatorSection {

    // MARK: - Color

    var colorSection: some View {
        Section {
            ColorPicker("Color", selection: bindings.color())
        } header: {
            Text("Color")
        } footer: {
            Text("Note: setting the indicator color to fully transparent conflicts with the drag gesture.")
        }
    }

    // MARK: - Border

    var borderSection: some View {
        Section {
            Toggle("Border", isOn: bindings.borderEnabled())
            if indicatorState.configuration.border != nil {
                ColorPicker("Color", selection: bindings.borderColor())
                SettingSlider(
                    title: "Width",
                    value: bindings.borderWidth(),
                    range: 0.5...4,
                    step: 0.5,
                    format: .fractionalOne
                )
            }
        } header: {
            Text("Border")
        }
    }

    // MARK: - Corner radius

    var cornerRadiusSection: some View {
        CornerRadiusSection(
            cornerRadius: bindings.cornerRadius(),
            footer: "For best results, keep the indicator corner radius close to the bar's corner radius."
        )
    }

    // MARK: - Animation

    var animationSection: some View {
        AnimationSection(
            parameters: bindings.animationParameters(),
            headerText: "Transition Animation",
            footerText: "Animation applied when the indicator moves between tabs."
        )
    }

    // MARK: - Drag gesture

    var dragGestureSection: some View {
        Section {
            Toggle("Drag Gesture", isOn: bindings.dragGestureEnabled())
        } header: {
            Text("Interaction")
        } footer: {
            Text("Allows the user to drag the indicator between tabs.")
        }
    }

    // MARK: - Inset

    var insetSection: some View {
        Section {
            SettingSlider(
                title: "Horizontal",
                value: bindings.indicatorHorizontalInset(),
                range: -16...16,
                step: 0.5,
                format: .fractionalOne
            )
            SettingSlider(
                title: "Vertical",
                value: bindings.indicatorVerticalInset(),
                range: -16...8,
                step: 0.5,
                format: .fractionalOne
            )
        } header: {
            Text("Inset")
        } footer: {
            Text("Positive values shrink the indicator, negative values expand it beyond the item bounds.")
        }
    }

    // MARK: - Scale effect

    var scaleEffectSection: some View {
        Section {
            Toggle("Scale Effect", isOn: bindings.scaleEffectEnabled())
            if indicatorState.configuration.scaleEffect != nil {
                SettingSlider(
                    title: "X Scale",
                    value: bindings.scaleEffectX(),
                    range: 1.0...2.0,
                    step: 0.01,
                    format: .fractionalTwo
                )
                SettingSlider(
                    title: "Y Scale",
                    value: bindings.scaleEffectY(),
                    range: 1.0...2.0,
                    step: 0.01,
                    format: .fractionalTwo
                )
                SettingSlider(
                    title: "Reset Duration",
                    value: bindings.scaleEffectDuration(),
                    range: 0.05...1.0,
                    step: 0.05,
                    format: .fractionalTwo
                )
            }
        } header: {
            Text("Scale Effect")
        } footer: {
            Text("Scales the indicator frame during transition. Works in combination with the transition animation.")
        }
    }

    @ViewBuilder
    var scaleEffectAnimationSettings: some View {
        if indicatorState.configuration.scaleEffect != nil {
            AnimationSection(
                parameters: bindings.scaleAnimationParameters(),
                headerText: "Scale Animation",
                footerText: "Animation applied to the scaling phase of the indicator."
            )
        }
    }

    // MARK: - Lens effects

    var effectsSection: some View {
        Section {
            Toggle("Lens Distortion", isOn: bindings.lensDistortionEnabled())
            if indicatorState.configuration.effects.contains(.lensDistortion) {
                SettingSlider(
                    title: "Zone Width",
                    value: bindings.refractionZoneWidth(),
                    range: 2.0...12.0,
                    step: 0.5,
                    format: .fractionalOne
                )
                SettingSlider(
                    title: "Strength",
                    value: bindings.refractionStrength(),
                    range: 1.5...5.0,
                    step: 0.1,
                    format: .fractionalOne
                )
            }
            Toggle("Chromatic Aberration", isOn: bindings.chromaticAberrationEnabled())
            if indicatorState.configuration.effects.contains(.chromaticAberration) {
                SettingSlider(
                    title: "Zone Width",
                    value: bindings.aberrationZoneWidth(),
                    range: 1.0...6.0,
                    step: 0.5,
                    format: .fractionalOne
                )
                SettingSlider(
                    title: "Strength",
                    value: bindings.aberrationStrength(),
                    range: 1.0...4.0,
                    step: 0.1,
                    format: .fractionalOne
                )
            }
        } header: {
            Text("Shader Effects")
        } footer: {
            Text("Metal shader effects applied at the indicator boundary. Available on iOS 17 and later.")
        }
    }
}
