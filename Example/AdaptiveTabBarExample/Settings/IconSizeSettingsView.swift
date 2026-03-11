//
//  IconSizeSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 11.03.26.
//

import AdaptiveTabBar
import SwiftUI

struct IconSizeSettingsView: View {
    var viewModel: ExampleViewModel

    var body: some View {
        List {
            Section(header: Text("Icon Sizes")) {
                VStack(alignment: .leading) {
                    Text("Regular Side: \(Int(viewModel.state.config.regularIconSideLength))")
                        .font(.subheadline)
                    Slider(value: Binding(
                        get: { viewModel.state.config.regularIconSideLength },
                        set: { viewModel.send(.updateRegularIconSize($0)) }
                    ),
                    in: 10 ... 50,
                    step: 1)
                        .contentShape(Rectangle())
                }

                VStack(alignment: .leading) {
                    Text("Prominent Side: \(Int(viewModel.state.config.prominentIconSideLength))")
                        .font(.subheadline)
                    Slider(value: Binding(
                        get: { viewModel.state.config.prominentIconSideLength },
                        set: { viewModel.send(.updateProminentIconSize($0)) }
                    ),
                    in: 20 ... 80,
                    step: 1)
                        .contentShape(Rectangle())
                }
            }

            Section(header: Text("Landscape Scaling"), footer: Text("Scale factor applied in landscape mode.")) {
                VStack(alignment: .leading) {
                    Text("Compact Scale: \(String(format: "%.2f", viewModel.state.config.compactIconScale))")
                        .font(.subheadline)
                    Slider(value: Binding(
                        get: { viewModel.state.config.compactIconScale },
                        set: { viewModel.send(.updateCompactIconScale($0)) }
                    ),
                    in: 0.5 ... 1.0,
                    step: 0.05)
                        .contentShape(Rectangle())
                }
            }

            Section("Selection Scaling") {
                VStack(alignment: .leading) {
                    Text("Selected Scale: \(String(format: "%.2f", viewModel.state.config.selectedIconScale))")
                        .font(.subheadline)
                    Slider(
                        value: Binding(
                            get: { viewModel.state.config.selectedIconScale },
                            set: { viewModel.send(.updateSelectedIconScale($0)) }
                        ),
                        in: 1.0 ... 1.5,
                        step: 0.01
                    )

                    .contentShape(Rectangle())
                }
            }
        }
        .navigationTitle("Icon Sizes")
    }
}
