//
//  IndicatorScreen.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 15.05.26.
//

import SwiftUI
import BarKit

struct IndicatorScreen: View {
    
    @Environment(\.verticalSizeClass) var sizeClass
    
    let viewModel: ExampleViewModel
    
    let bindings: IndicatorBindings
    
    var body: some View {
        List {
            descriptionSection
            if viewModel.state.tabBar.mode == .pinned {
                unavailableSection
            } else {
                
                dragGestureSection
                insetSection
                
                appearanceLink
                transitionAnimatrionLink
                scaleEffectLink
                lensEffectsLink
            }
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .toolbar { resetButton }
        .navigationTitle("Selection indicator")
    }
}

// MARK: - Navigation links

private extension IndicatorScreen {

    var appearanceLink: some View {
        settingsLink("Appearance", viewModel: viewModel) {
            colorSection
            borderSection
            cornerRadiusSection
        }
    }

    var transitionAnimatrionLink: some View {
        settingsLink("Transition animation", viewModel: viewModel) {
            animationSection
        }
    }

    var scaleEffectLink: some View {
        settingsLink("Scale effect", viewModel: viewModel) {
            scaleEffectSection
            scaleEffetAnimationSettings
        }
    }
    
    var lensEffectsLink: some View {
        settingsLink("Lens effect", viewModel: viewModel) {
            effectsSection
        }
    }
}

// MARK: - View Components

private extension IndicatorScreen {

    // MARK: - Description

    var descriptionSection: some View {
        Section {
            Text("Customize the selection indicator that highlights the active tab.\nAdjust its appearance, shape, animation, and Metal shader effects applied at the indicator boundary.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Unavailable

    @ViewBuilder
    var unavailableSection: some View {
        if viewModel.state.tabBar.mode == .pinned {
            Section {
                ContentUnavailableView(
                    "Indicator not available",
                    systemImage: "rectangle.slash",
                    description: Text("Selection indicator is only supported in Floating mode. Switch the Tab Bar to Floating to configure it.")
                )
            }
        }
    }
    
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
            if viewModel.state.indicator.indicatorConfig.border != nil {
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
        Section {
            SettingSlider(
                title: "Corner Radius",
                value: bindings.cornerRadius(),
                range: 0...40
            )
        } header: {
            Text("Corner Radius")
        } footer: {
            Text("For best results, keep the indicator corner radius close to the bar's corner radius.")
        }
    }
    
    // MARK: - Animation
    
    var animationSection: some View {
        AnimationSettingsSectionView(
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
            if viewModel.state.indicator.indicatorConfig.scaleEffect != nil {
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
    var scaleEffetAnimationSettings: some View {
        if viewModel.state.indicator.indicatorConfig.scaleEffect != nil {
            AnimationSettingsSectionView(
                parameters: bindings.scaleAnimationParameters(),
                headerText: "Scale Animation",
                footerText: "Animation applied to the scaling phase of the indicator."
            )
        }
    }
    
    // MARK: Lens effects
    
    var effectsSection: some View {
        Section {
            Toggle("Lens Distortion", isOn: bindings.lensDistortionEnabled())
            if viewModel.state.indicator.indicatorConfig.effects.contains(.lensDistortion) {
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
            if viewModel.state.indicator.indicatorConfig.effects.contains(.chromaticAberration) {
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
    
    // MARK: - Toolbar

    var resetButton: some View {
        Button("Reset Indicator settings") { }
    }
}

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()

    NavigationStack {
        ZStack(alignment: .bottom) {
            IndicatorScreen(viewModel: viewModel, bindings: .init(viewModel: viewModel))
            TabBarContainer(viewModel: viewModel)
        }
        .ignoresSafeArea(
            .all,
            edges: viewModel.state.tabBar.mode == .floating ? .bottom : []
        )
    }
    .onAppear {
        viewModel.send(.selectTab(ExampleTabItem.allItems[3]))
    }
}

//Effects (lensDistortion / chromaticAberration + их параметры)
