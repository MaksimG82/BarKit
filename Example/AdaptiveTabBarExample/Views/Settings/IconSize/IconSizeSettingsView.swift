//
//  IconSizeSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 11.03.26.
//

import AdaptiveTabBar
import SwiftUI

struct IconSizeSettingsView: View {
    @Environment(\.tabBarHeight) var tabBarHeight

    var viewModel: ExampleViewModel

    // MARK: - Body

    var body: some View {
        List {
            dimensionsSection
            landscapeScalingSection
            selectionScalingSection
        }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: tabBarHeight) }
        .navigationTitle("Icon Sizes")
    }
}

// MARK: - View Components

private extension IconSizeSettingsView {
    var dimensionsSection: some View {
        Section("Icon Sizes") {
            SettingSlider(
                title: "Regular Side",
                value: regularSizeBinding,
                range: 10 ... 50
            )

            SettingSlider(
                title: "Prominent Side",
                value: prominentSizeBinding,
                range: 20 ... 80
            )
        }
    }

    var landscapeScalingSection: some View {
        Section(header: Text("Landscape Scaling"), footer: Text("Scale factor applied in landscape mode.")) {
            SettingSlider(
                title: "Compact Scale",
                value: compactScaleBinding,
                range: 0.5 ... 1.0,
                step: 0.05,
                format: .fractionalTwo
            )
        }
    }

    var selectionScalingSection: some View {
        Section("Selection Scaling") {
            SettingSlider(
                title: "Selected Scale",
                value: selectedScaleBinding,
                range: 1.0 ... 1.5,
                step: 0.01,
                format: .fractionalTwo,
            )
        }
    }
}

// MARK: - Bindings

private extension IconSizeSettingsView {
    var regularSizeBinding: Binding<CGFloat> {
        Binding(
            get: { viewModel.state.config.regularIconSideLength },
            set: { viewModel.send(.updateRegularIconSize($0)) }
        )
    }

    var prominentSizeBinding: Binding<CGFloat> {
        Binding(
            get: { viewModel.state.config.prominentIconSideLength },
            set: { viewModel.send(.updateProminentIconSize($0)) }
        )
    }

    var compactScaleBinding: Binding<CGFloat> {
        Binding(
            get: { viewModel.state.config.compactIconScale },
            set: { viewModel.send(.updateCompactIconScale($0)) }
        )
    }

    var selectedScaleBinding: Binding<CGFloat> {
        Binding(
            get: { viewModel.state.config.selectedIconScale },
            set: { viewModel.send(.updateSelectedIconScale($0)) }
        )
    }
}

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()
    NavigationStack {
        ZStack(alignment: .bottom) {
            IconSizeSettingsView(viewModel: viewModel)

            TabBarView(
                items: viewModel.state.items,
                selected: .constant(viewModel.state.items[0]),
                config: viewModel.state.config
            )
            .overlay(Divider(), alignment: .top)
        }
    }
}
