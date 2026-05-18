//
//  ItemEdgeInsetSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

/// A reusable settings section for configuring item edge insets.
struct ItemEdgeInsetsSection: View {

    /// The header title for the section.
    let title: String

    /// Binding for the top inset.
    @Binding var top: CGFloat

    /// Binding for the bottom inset.
    @Binding var bottom: CGFloat

    var body: some View {
        Section {
            SettingSlider(title: "Top", value: $top, range: 0...24)
            SettingSlider(title: "Bottom", value: $bottom, range: 0...24)
        } header: {
            Text(title)
        }
    }
}
