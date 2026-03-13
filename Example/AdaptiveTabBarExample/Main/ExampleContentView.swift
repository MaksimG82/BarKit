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
        ZStack(alignment: .bottom) {
            NavigationStack {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("AdaptiveTabBar")
                                .font(.title3.bold())

                            Text("Explore how the tab bar adapts to different configurations.\nChange colors, sizes, layout settings to find the perfect fit for your app.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text("Note: Tab selection only updates the UI state and does not perform actual navigation.")
                                .font(.subheadline)
                        }
                        .padding(.bottom, 4)
                    }

                    Section("Appearance") {
                        NavigationLink("Colors") {
                            ColorsSettingsView(viewModel: viewModel)
                        }
                        NavigationLink("Typography") {
                            TypographySettingsView(viewModel: viewModel)
                        }
                        NavigationLink("Icon Sizes") {
                            IconSizeSettingsView(viewModel: viewModel)
                        }
                    }

                    Section("Layout") {
                        NavigationLink("Tabs Layout") {
                            LayoutSettingsView(viewModel: viewModel)
                        }
                        Toggle(
                            "Debug Layout",
                            isOn: Binding(
                                get: { viewModel.state.isDebugLayoutEnabled },
                                set: { _ in viewModel.send(.toggleDebugLayout) }
                            )
                        )
                    }

                    Section("Animation") {
                        NavigationLink("Animation") {
                            AnimationSettingsView(viewModel: viewModel)
                        }
                    }
                }
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
            .overlay(Divider(), alignment: .top)
            .debugLayout(viewModel.state.isDebugLayoutEnabled)
        }
    }
}

#Preview {
    ExampleContentView()
}
