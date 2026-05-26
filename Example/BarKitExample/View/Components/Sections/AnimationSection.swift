//
//  AnimationSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 12.04.26.
//

import SwiftUI
import BarKit

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
                    Text($0.displayName).tag($0)
                }
            }
            .pickerStyle(.menu)
        }

        Section("Parameters") {
            parametersSection()
        }
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
