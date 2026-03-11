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
            Section(header: Text("Tab Bar Colors")) {
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

                ColorPicker(
                    "Background Color",
                    selection: Binding(
                        get: { viewModel.state.config.backgroundColor },
                        set: { viewModel.send(.updateColor(.background, $0)) }
                    )
                )
            }
        }
        .navigationTitle("Colors")
    }
}
