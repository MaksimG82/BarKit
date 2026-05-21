//
//  CornerRadiusSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

/// A reusable settings section for configuring bar corner radius.
struct CornerRadiusSection: View {

    /// Binding for the corner radius value.
    @Binding var cornerRadius: CGFloat

    /// Optional footer text displayed below the section.
    var footer: String? = nil

    var body: some View {
        Section {
            SettingSlider(
                title: "Corner Radius",
                value: $cornerRadius,
                range: 0...40
            )
        } header: {
            Text("Corner radius")
        } footer: {
            if let footer {
                Text(footer)
            }
        }
    }
}
