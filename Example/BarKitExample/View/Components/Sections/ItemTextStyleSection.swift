//
//  ItemTextStyleSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

/// A reusable settings section for configuring item text style.
struct ItemTextStyleSection: View {

    /// Binding for the text style picker.
    @Binding var textStyle: Font.TextStyle

    var body: some View {
        Section {
            Picker("Text Style", selection: $textStyle) {
                ForEach(Font.TextStyle.allCases, id: \.self) {
                    Text(String(describing: $0)).tag($0)
                }
            }
        } header: {
            Text("Text style")
        }
    }
}
