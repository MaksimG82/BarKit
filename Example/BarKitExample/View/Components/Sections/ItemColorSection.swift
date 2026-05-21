//
//  ItemColorSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

/// A reusable settings section for configuring item selected and unselected colors.
struct ItemColorsSection: View {

    /// Binding for the selected item color.
    @Binding var selectedColor: Color

    /// Binding for the unselected item color.
    @Binding var unselectedColor: Color

    var body: some View {
        Section {
            ColorPicker("Selected", selection: $selectedColor)
            ColorPicker("Unselected", selection: $unselectedColor)
        } header: {
            Text("Item colors")
        } footer: {
            Text("Colors are stored as fixed RGB values and won't adapt to light/dark mode.\nSystem color names like .red won't be preserved in generated code.")
        }
    }
}
