//
//  BarBackgroundSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI
import BarKit

/// A reusable settings section for configuring bar background appearance.
struct BarBackgroundSection: View {

    /// Binding for the full `BarBackground` value.
    @Binding var background: BarBackground

    /// Binding for the background type picker.
    @Binding var backgroundType: BarBackgroundType

    /// Binding for the tint or solid color.
    @Binding var backgroundColor: Color

    /// Binding for the material selection picker.
    @Binding var materialSelection: BarMaterial

    var body: some View {
        Section {
            Picker("Type", selection: $backgroundType) {
                ForEach(BarBackgroundType.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            switch background {
            case .color:
                ColorPicker("Color", selection: $backgroundColor)
            case .material:
                ColorPicker("Tint", selection: $backgroundColor)
                Picker("Material", selection: $materialSelection) {
                    ForEach(BarMaterial.allCases, id: \.self) {
                        Text($0.displayName).tag($0)
                    }
                }
            case .customBlur:
                ColorPicker("Tint", selection: $backgroundColor)
                Text("Coming soon")
            }
        } header: {
            Text("Background")
        } footer: {
            Text("Defines the visual fill of the bar — solid color, system blur, or custom blur.\nNotes: Colors are stored as fixed RGB values and won't adapt to light/dark mode.\nSystem color names like .red won't be preserved in generated code.")
        }
    }
}
