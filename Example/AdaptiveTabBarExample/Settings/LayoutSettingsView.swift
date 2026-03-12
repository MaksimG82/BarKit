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
            contentSection
            prominentSection
            spacingSection
            paddingSection
        }
        .navigationTitle("Layout")
    }

    private var contentSection: some View {
        Section("Content") {
            Picker("Tab Count", selection: Binding(
                get: { viewModel.state.items.count },
                set: { count in
                    switch count {
                    case 3: viewModel.send(.updateItems(ExampleTabItem.threeItems))
                    case 4: viewModel.send(.updateItems(ExampleTabItem.fourItems))
                    default: viewModel.send(.updateItems(ExampleTabItem.fiveItems))
                    }
                }
            )) {
                Text("3 Tabs").tag(3)
                Text("4 Tabs").tag(4)
                Text("5 Tabs").tag(5)
            }
            .pickerStyle(.segmented)
        }
    }

    private var prominentSection: some View {
        Section("Prominent Status") {
            ForEach(viewModel.state.items) { item in
                Toggle(item.title, isOn: Binding(
                    get: { item.style == .prominent },
                    set: { _ in viewModel.send(.toggleProminentStyle(item.id)) }
                ))
            }
        }
    }

    private var spacingSection: some View {
        Section("Spacing") {
            sliderRow(title: "Tab Spacing",
                      value: Binding(get: { viewModel.state.config.tabSpacing },
                                     set: { viewModel.send(.updateTabSpacing($0)) }),
                      range: 0 ... 40)

            sliderRow(title: "Icon-Title Spacing",
                      value: Binding(get: { viewModel.state.config.iconTitleSpacing },
                                     set: { viewModel.send(.updateIconTitleSpacing($0)) }),
                      range: 0 ... 20)
        }
    }

    private var paddingSection: some View {
        Section("Vertical Padding") {
            sliderRow(title: "Top",
                      value: Binding(get: { viewModel.state.config.tabItemTopPadding },
                                     set: { viewModel.send(.updateTabItemTopPadding($0)) }),
                      range: 0 ... 30)

            sliderRow(title: "Bottom",
                      value: Binding(get: { viewModel.state.config.tabItemBottomPadding },
                                     set: { viewModel.send(.updateTabItemBottomPadding($0)) }),
                      range: 0 ... 30)

            sliderRow(title: "Top (Compact)",
                      value: Binding(get: { viewModel.state.config.tabItemTopPaddingCompact },
                                     set: { viewModel.send(.updateTabItemTopPaddingCompact($0)) }),
                      range: 0 ... 20)

            sliderRow(title: "Bottom (Compact)",
                      value: Binding(get: { viewModel.state.config.tabItemBottomPaddingCompact },
                                     set: { viewModel.send(.updateTabItemBottomPaddingCompact($0)) }),
                      range: 0 ... 20)
        }
    }

    private func sliderRow(title: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        VStack(alignment: .leading) {
            Text("\(title): \(Int(value.wrappedValue))")
            Slider(value: value, in: range, step: 1)
                .contentShape(Rectangle())
        }
    }
}
