//
//  ItemEdgeInsetSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

/// A reusable settings section for configuring item edge insets.
/// A reusable settings section for configuring item edge insets.
struct ItemEdgeInsetsSection: View {

    /// The header title for the section.
    let title: String

    /// Binding for the top inset.
    var top: Binding<CGFloat>?

    /// Binding for the bottom inset.
    var bottom: Binding<CGFloat>?

    /// Binding for the leading inset.
    var leading: Binding<CGFloat>?
    
    /// Binding for the trailing inset.
    var trailing: Binding<CGFloat>?

    var body: some View {
        Section {
            if let top { SettingSlider(title: "Top", value: top, range: 0...24) }
            if let bottom { SettingSlider(title: "Bottom", value: bottom, range: 0...24) }
            if let leading { SettingSlider(title: "Leading", value: leading, range: 0...24) }
            if let trailing { SettingSlider(title: "Trailing", value: trailing, range: 0...24) }
        } header: {
            Text(title)
        }
    }
}
