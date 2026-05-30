//
//  BadgeSections.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 30.05.26.
//

import SwiftUI
import BarKit

/// A reusable settings section for configuring badge values and appearance.
struct BadgeSection<Item: BarItemProtocol>: View {

    /// The bar items for which badges can be configured.
    let items: [Item]

    /// A closure returning a badge value binding for a given item identifier.
    let badge: (AnyHashable) -> Binding<BadgeValue?>

    /// Binding for the badge configuration.
    @Binding var configuration: BadgeConfiguration

    var body: some View {
        badgeValuesSection
        badgeAppearanceSection
        badgeOffsetSection
    }
}

// MARK: - View Components

private extension BadgeSection {

    var badgeValuesSection: some View {
        Section {
            ForEach(items) { item in
                badgeRow(for: item)
            }
        } header: {
            Text("Badges")
        } footer: {
            Text("Set a badge value for each item. Leave empty to hide the badge.")
        }
    }

    func badgeRow(for item: Item) -> some View {
        let binding = badge(item.id)
        return HStack {
            Text(item.title)
            Spacer()
            Picker("", selection: Binding<BadgeValue?>(
                get: { binding.wrappedValue.map { _ in binding.wrappedValue } ?? nil },
                set: { binding.wrappedValue = $0 }
            )) {
                Text("None").tag(Optional<BadgeValue>.none)
                Text("Dot").tag(Optional<BadgeValue>.some(.dot))
                Text("Count").tag(Optional<BadgeValue>.some(.count(1)))
                Text("Label").tag(Optional<BadgeValue>.some(.label("New")))
            }
            .pickerStyle(.menu)
        }
    }

    var badgeAppearanceSection: some View {
        Section {
            ColorPicker("Background", selection: $configuration.backgroundColor)
            ColorPicker("Foreground", selection: $configuration.foregroundColor)
            Picker("Text Style", selection: $configuration.textStyle) {
                ForEach(Font.TextStyle.allCases, id: \.self) {
                    Text(String(describing: $0)).tag($0)
                }
            }
            SettingSlider(title: "Dot Diameter", value: $configuration.dotDiameter, range: 4...20)
            SettingSlider(title: "Horizontal Padding", value: $configuration.horizontalPadding, range: 0...16)
            SettingSlider(title: "Vertical Padding", value: $configuration.verticalPadding, range: 0...16)
        } header: {
            Text("Appearance")
        }
    }

    var badgeOffsetSection: some View {
        Section {
            SettingSlider(title: "Offset X", value: $configuration.offsetX, range: -5...5, step: 0.1, format: .fractionalOne)
            SettingSlider(title: "Offset Y", value: $configuration.offsetY, range: -5...5, step: 0.5, format: .fractionalOne)
        } header: {
            Text("Position")
        }
    }
}
