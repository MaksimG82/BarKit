//
//  AnimationSettingsSection.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.04.26.
//

import AdaptiveTabBar
import SwiftUI

struct AnimationParameters: Equatable {
    
    struct ScaleSettings: Equatable {
        var xScale: CGFloat = 1.2
        var yScale: CGFloat = 1.2
        var resetDuration: Double = 0.2
    }
    
    var type: AnimationType = .spring
    var duration: Double = 0.5
    var bounce: Double = 0.0
    
    var scaleSettings: ScaleSettings?
    
    func makeAnimation() -> Animation? {
        switch type {
        case .none: return nil
        case .linear: return .linear(duration: duration)
        case .easeIn: return .easeIn(duration: duration)
        case .easeOut: return .easeOut(duration: duration)
        case .easeInOut: return .easeInOut(duration: duration)
        case .spring: return .spring(duration: duration, bounce: bounce)
        case .bouncy: return .bouncy(duration: duration, extraBounce: bounce)
        case .snappy: return .snappy(duration: duration, extraBounce: bounce)
        case .smooth: return .smooth(duration: duration, extraBounce: bounce)
        }
    }
    
    func makeScaleEffect() -> SelectionScaleEffect? {
        guard
            let scaleSettings,
            let animation = makeAnimation()
        else { return nil }
        
        return SelectionScaleEffect(
            animation: animation,
            xScale: scaleSettings.xScale,
            yScale: scaleSettings.yScale
        )
    }
    
    static func defaultWithScaleSettings() -> AnimationParameters {
        AnimationParameters(
            type: .easeInOut,
            duration: 0.15,
            scaleSettings: AnimationParameters.ScaleSettings()
        )
    }
}

enum AnimationType: String, CaseIterable {
    case none = "None"
    case easeIn = "Ease In"
    case easeOut = "Ease Out"
    case easeInOut = "Ease In Out"
    case spring = "Spring"
    case bouncy = "Bouncy"
    case snappy = "Snappy"
    case smooth = "Smooth"
    case linear = "Linear"
}

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
