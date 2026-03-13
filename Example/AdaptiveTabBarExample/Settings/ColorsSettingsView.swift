//
//  ColorsSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 14.02.26.
//

import AdaptiveTabBar
import SwiftUI

struct ColorsSettingsView: View {
    var viewModel: ExampleViewModel

    var body: some View {
        List {
            Section(
                header: Text("Tab Bar Colors"),
                footer: Text("Background color supports opacity.\nTint color affects only the selected item.")
            ) {
                ColorPicker(
                    "Background Color",
                    selection: Binding(
                        get: { viewModel.state.config.backgroundColor },
                        set: { viewModel.send(.updateColor(.background, $0)) }
                    )
                )

                ColorPicker(
                    "Selected Tint",
                    selection: Binding(
                        get: { viewModel.state.config.tintColor },
                        set: { viewModel.send(.updateColor(.tint, $0)) }
                    )
                )

                ColorPicker(
                    "Unselected Color",
                    selection: Binding(
                        get: { viewModel.state.config.unselectedColor },
                        set: { viewModel.send(.updateColor(.unselected, $0)) }
                    )
                )
            }
        }
        .toolbar {
            Button("Reset colors") {
                let defaultState = TabBarConfiguration()
                viewModel.send(.updateColor(.tint, defaultState.tintColor))
                viewModel.send(.updateColor(.unselected, defaultState.unselectedColor))
                viewModel.send(.updateColor(.background, defaultState.backgroundColor))
            }
        }
        .navigationTitle("Colors")
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
            .overlay(Divider(), alignment: .top)
        }
    }
}
