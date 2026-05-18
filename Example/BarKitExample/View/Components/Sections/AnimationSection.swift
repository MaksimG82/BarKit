//
//  AnimationSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 12.04.26.
//

import SwiftUI

typealias AnimationType = AnimationParameters.AnimationType

struct AnimationSection: View {
    @Binding var parameters: AnimationParameters
    
    let headerText: String
    let footerText: String
    
    var body: some View {
        Section(
            header: Text(headerText).font(.headline)
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

private extension AnimationSection {
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
}

#Preview("Section without scale effect settings") {
    @Previewable @State var parameters: AnimationParameters = .init()
    Form {
        AnimationSection(
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
        AnimationSection(
            parameters: $parameters,
            headerText: "Tab item animation",
            footerText: "The animation applied to internal elements (icon and title) during selection changes."
        )
        
        AnimationSection(
            parameters: $parametersWithScaleEffects,
            headerText: "Indicator Scale Effect",
            footerText: "Animation for scaling the indicator during transitions."
        )
    }
}
