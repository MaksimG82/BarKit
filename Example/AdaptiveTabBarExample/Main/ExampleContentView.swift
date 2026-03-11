//
//  ExampleContentView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.01.26.
//

import AdaptiveTabBar
import SwiftUI

@available(iOS 17.0, *)
struct ExampleContentView: View {
    @State private var viewModel = ExampleViewModel()

    var body: some View {
        // Добавляем VStack с нулевым отступом
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
                }
                .navigationTitle("Configuration")
            }

            TabBarView(
                items: viewModel.state.items,
                selected: Binding(
                    get: { viewModel.state.selectedTab },
                    set: { viewModel.send(.selectTab($0)) }
                ),
                config: viewModel.state.config
            )
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ExampleContentView()
}
