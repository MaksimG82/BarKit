//
//  ExampleContentView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.01.26.
//

import AdaptiveTabBar
import SwiftUI

struct ExampleContentView: View {
    @State private var viewModel = ExampleViewModel()

    var body: some View {
        VStack(spacing: 0) {
            NavigationStack {
                List {
                    NavigationLink("Colors") {
                        ColorsSettingsView(viewModel: viewModel)
                    }
                    NavigationLink("Typography") {
                        TypographySettingsView(viewModel: viewModel)
                    }
                    NavigationLink("Icon Sizes") {
                        IconSizeSettingsView(viewModel: viewModel)
                    }
                    NavigationLink("Tabs Layout") {
                        LayoutSettingsView(viewModel: viewModel)
                    }
                    NavigationLink("Animation") {
                        AnimationSettingsView(viewModel: viewModel)
                    }
                    Section("Tools") {
                        Toggle("Debug Layout", isOn: Binding(
                            get: { viewModel.state.isDebugLayoutEnabled },
                            set: { _ in viewModel.send(.toggleDebugLayout) }
                        ))
                    }
                }
                .navigationTitle("Configuration")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Reset all changes") {
                            viewModel.send(.resetState)
                        }
                    }
                }
            }

            TabBarView(
                items: viewModel.state.items,
                selected: Binding(
                    get: { viewModel.state.selectedTab },
                    set: { viewModel.send(.selectTab($0)) }
                ),
                config: viewModel.state.config
            )
            .debugLayout(viewModel.state.isDebugLayoutEnabled)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ExampleContentView()
}
