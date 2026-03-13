//
//  ColorsSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 14.02.26.
//

import AdaptiveTabBar
import SwiftUI

struct ColorsSettingsView: View {
    @Environment(\.tabBarHeight) var tabBarHeight

    var viewModel: ExampleViewModel

    // MARK: - State

    @State private var selectedMaterial: MaterialSelection = .ultraThin

    // MARK: - Body

    var body: some View {
        List {
            colorsSection
            materialSection
        }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: tabBarHeight) }
        .toolbar { resetButton }
        .navigationTitle("Colors")
    }
}

// MARK: - View Components

private extension ColorsSettingsView {
    var colorsSection: some View {
        Section(
            header: Text("Tab Bar Colors"),
            footer: Text("Background color supports opacity.\nTint color affects only the selected item.")
        ) {
            ColorPicker("Background Color", selection: backgroundColorBinding)
            ColorPicker("Selected Tint", selection: tintColorBinding)
            ColorPicker("Unselected Color", selection: unselectedColorBinding)
        }
    }

    var materialSection: some View {
        Section(
            header: Text("Blur Effect (Material)"),
            footer: Text("If you use an opaque background color, it is recommended to set this to 'None' to save rendering resources.")
        ) {
            Picker("Material", selection: $selectedMaterial) {
                ForEach(MaterialSelection.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selectedMaterial) { _, newValue in
                viewModel.send(.updateMaterial(newValue.material))
            }
        }
    }

    var resetButton: some View {
        Button("Reset colors") {
            let defaultState = TabBarConfiguration()
            viewModel.send(.updateColor(.tint, defaultState.tintColor))
            viewModel.send(.updateColor(.unselected, defaultState.unselectedColor))
            viewModel.send(.updateColor(.background, defaultState.backgroundColor))
            viewModel.send(.updateMaterial(defaultState.backgroundMaterial))
            selectedMaterial = .ultraThin
        }
    }
}

// MARK: - Bindings

private extension ColorsSettingsView {
    var backgroundColorBinding: Binding<Color> {
        Binding(
            get: { viewModel.state.config.backgroundColor },
            set: { viewModel.send(.updateColor(.background, $0)) }
        )
    }

    var tintColorBinding: Binding<Color> {
        Binding(
            get: { viewModel.state.config.tintColor },
            set: { viewModel.send(.updateColor(.tint, $0)) }
        )
    }

    var unselectedColorBinding: Binding<Color> {
        Binding(
            get: { viewModel.state.config.unselectedColor },
            set: { viewModel.send(.updateColor(.unselected, $0)) }
        )
    }
}

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()
    NavigationStack {
        ZStack(alignment: .bottom) {
            ColorsSettingsView(viewModel: viewModel)

            TabBarView(
                items: viewModel.state.items,
                selected: .constant(viewModel.state.items[0]),
                config: viewModel.state.config
            )
            .overlay(alignment: .top) { Divider() }
        }
    }
}

private enum MaterialSelection: String, CaseIterable {
    case none = "None"
    case ultraThin = "Ultra Thin"
    case thin = "Thin"
    case regular = "Regular"
    case thick = "Thick"

    var material: Material? {
        switch self {
        case .none: nil
        case .ultraThin: .ultraThinMaterial
        case .thin: .thinMaterial
        case .regular: .regularMaterial
        case .thick: .thickMaterial
        }
    }
}
