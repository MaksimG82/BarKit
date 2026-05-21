//
//  ShadowSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

/// A reusable settings section for configuring bar shadow.
struct ShadowSection: View {

    /// Binding for the shadow enabled toggle.
    @Binding var shadowEnabled: Bool

    /// Binding for the shadow color.
    @Binding var shadowColor: Color

    /// Binding for the shadow radius.
    @Binding var shadowRadius: CGFloat

    /// Binding for the shadow x offset.
    @Binding var shadowX: CGFloat

    /// Binding for the shadow y offset.
    @Binding var shadowY: CGFloat

    var body: some View {
        Section {
            Toggle("Shadow", isOn: $shadowEnabled)
            if shadowEnabled {
                ColorPicker("Color", selection: $shadowColor)
                SettingSlider(title: "Radius", value: $shadowRadius, range: 0...24)
                SettingSlider(title: "X", value: $shadowX, range: -16...16, step: 0.01, format: .fractionalTwo)
                SettingSlider(title: "Y", value: $shadowY, range: -16...16, step: 0.01, format: .fractionalTwo)
            }
        } header: {
            Text("Shadow")
        }
    }
}
