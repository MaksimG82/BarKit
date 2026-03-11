//
//  LayoutSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 11.03.26.
//

import AdaptiveTabBar
import SwiftUI

struct LayoutSettingsView: View {
    var viewModel: ExampleViewModel

    var body: some View {
        List {
            Section("Content") {
                Picker("Tab Count", selection: Binding(
                    get: { viewModel.state.items.count },
                    set: { count in
                        switch count {
                        case 3: viewModel.send(.updateItems(ExampleTabItem.threeItems))
                        case 4: viewModel.send(.updateItems(ExampleTabItem.fourItems))
                        default: viewModel.send(.updateItems(ExampleTabItem.allCases))
                        }
                    }
                )) {
                    Text("3 Tabs").tag(3)
                    Text("4 Tabs").tag(4)
                    Text("5 Tabs").tag(5)
                }
                .pickerStyle(.segmented)
            }

            Section("Spacing") {
                VStack(alignment: .leading) {
                    Text("Tab Spacing: \(Int(viewModel.state.config.tabSpacing))")
                    Slider(value: Binding(
                        get: { viewModel.state.config.tabSpacing },
                        set: { viewModel.send(.updateTabSpacing($0)) }
                    ), in: 0 ... 40, step: 1)
                        .contentShape(Rectangle())
                }

                VStack(alignment: .leading) {
                    Text("Icon-Title Spacing: \(Int(viewModel.state.config.iconTitleSpacing))")
                    Slider(value: Binding(
                        get: { viewModel.state.config.iconTitleSpacing },
                        set: { viewModel.send(.updateIconTitleSpacing($0)) }
                    ), in: 0 ... 20, step: 1)
                        .contentShape(Rectangle())
                }
            }

            Section("Vertical Padding") {
                VStack(alignment: .leading) {
                    Text("Regular: \(Int(viewModel.state.config.tabItemVerticalPadding))")
                    Slider(value: Binding(
                        get: { viewModel.state.config.tabItemVerticalPadding },
                        set: { viewModel.send(.updateTabItemVerticalPadding($0)) }
                    ), in: 0 ... 30, step: 1)
                        .contentShape(Rectangle())
                }

                VStack(alignment: .leading) {
                    Text("Compact: \(Int(viewModel.state.config.tabItemVerticalPaddingCompact))")
                    Slider(value: Binding(
                        get: { viewModel.state.config.tabItemVerticalPaddingCompact },
                        set: { viewModel.send(.updateTabItemVerticalPaddingCompact($0)) }
                    ), in: 0 ... 20, step: 1)
                        .contentShape(Rectangle())
                }
            }
        }
        .navigationTitle("Layout")
    }
}
