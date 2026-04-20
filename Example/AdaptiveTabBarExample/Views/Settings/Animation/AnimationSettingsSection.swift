//
//  AnimationSettingsSection.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.04.26.
//

import SwiftUI

typealias AnimationType = AnimationParameters.AnimationType

struct AnimationSettingsSectionView: View {
    @Binding var parameters: AnimationParameters
    
    let headerText: String
    let footerText: String
    
    var body: some View {
        Section(
            header: Text(headerText).font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(Color(UIColor.label))
                .padding(.top, 24)
                .padding(.bottom, 8)
            ,
            footer: Text(footerText)
        ) {
            Picker("Animation Type", selection: $parameters.type) {
                ForEach(AnimationType.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.menu)
        }

        Section("Parameters") {
            parametersSection()
        }

        scaleSection
    }
}

// MARK: - View Components

private extension AnimationSettingsSectionView {
    var durationSlider: some View {
        SettingSlider(
            title: "Duration",
            value: $parameters.duration,
            range: 0.1...1.0,
            step: 0.01,
            format: .fractionalTwo
        )
    }
    
    var bounceSlider: some View {
        SettingSlider(
            title: "Extra Bounce",
            value: $parameters.bounce,
            range: 0...0.3,
            step: 0.01,
            format: .fractionalTwo
        )
    }
    
    @ViewBuilder
    func parametersSection() -> some View {
        switch parameters.type {
        case .none:
            Text("No parameters available")
            
        case .linear, .easeIn, .easeOut, .easeInOut:
            durationSlider
            
        case .bouncy, .smooth, .snappy, .spring:
            durationSlider
            bounceSlider
        }
    }
    
    @ViewBuilder
    var scaleSection: some View {
        if parameters.scaleSettings != nil && parameters.type != .none {
            Section(header: Text("Scale Settings")) {
                SettingSlider(
                    title: "X Scale",
                    value: Binding(
                        get: { parameters.scaleSettings?.xScale ?? 1.0 },
                        set: { parameters.scaleSettings?.xScale = $0 }
                    ),
                    range: 1.1...1.5,
                    step: 0.01,
                    format: .fractionalTwo
                )
                
                SettingSlider(
                    title: "Y Scale",
                    value: Binding(
                        get: { parameters.scaleSettings?.yScale ?? 1.0 },
                        set: { parameters.scaleSettings?.yScale = $0 }
                    ),
                    range: 1.1...1.5,
                    step: 0.01,
                    format: .fractionalTwo
                )
            }
        }
    }
    
    // MARK: - Actions
    
    private func updateDefaults(for type: AnimationType) {
        switch type {
        case .easeIn, .easeOut, .easeInOut, .linear:
            parameters.duration = 0.35
        case .spring, .bouncy, .snappy, .smooth:
            parameters.duration = 0.5
            parameters.bounce = 0.0
        case .none:
            parameters.duration = 0.0
        }
    }
}

#Preview("Section without scale effect settings") {
    @Previewable @State var parameters: AnimationParameters = .init()
    Form {
        AnimationSettingsSectionView(
            parameters: $parameters,
            headerText: "Tab item animation",
            footerText: "The animation applied to internal elements (icon and title) during selection changes."
        )
    }
}

#Preview("Section with scale effect settings") {
    @Previewable @State var parameters: AnimationParameters = .init()
    @Previewable @State var parametersWithScaleEffects = AnimationParameters(
        type: .spring,
        scaleSettings: AnimationParameters.ScaleSettings()
    )
    
    Form {
        AnimationSettingsSectionView(
            parameters: $parameters,
            headerText: "Tab item animation",
            footerText: "The animation applied to internal elements (icon and title) during selection changes."
        )
        
        AnimationSettingsSectionView(
            parameters: $parametersWithScaleEffects,
            headerText: "Indicator Scale Effect",
            footerText: "Animation for scaling the indicator during transitions."
        )
    }
}
