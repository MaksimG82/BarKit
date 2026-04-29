//
//  LayoutSettingsView.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 11.03.26.
//

import BarKit
import SwiftUI

struct LayoutSettingsView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.tabBarHeight) var tabBarHeight

    var viewModel: ExampleViewModel

    var body: some View {
        List {
            contentSection
            prominentSection
            spacingSection
            paddingSections
        }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: tabBarHeight) }
        .navigationTitle("Layout")
    }
}

// MARK: - View Components

private extension LayoutSettingsView {
    var contentSection: some View {
        Section("Content") {
            Picker("Tab Count", selection: itemsCountBinding) {
                Text("3 Tabs").tag(3)
                Text("4 Tabs").tag(4)
                Text("5 Tabs").tag(5)
            }
            .pickerStyle(.segmented)
        }
    }

    var prominentSection: some View {
        Section("Prominent Status") {
            ForEach(viewModel.state.items) { item in
                Toggle(item.title, isOn: prominentBinding(for: item))
            }
        }
    }

    var spacingSection: some View {
        Section("Spacing") {
            SettingSlider(title: "Tab Spacing", value: tabSpacingBinding, range: 0 ... 40)
            SettingSlider(title: "Icon-Title Spacing", value: iconTitleSpacingBinding, range: 0 ... 20)
        }
    }

    @ViewBuilder
    var paddingSections: some View {
        if verticalSizeClass == .compact {
            Section {
                SettingSlider(title: "Top (Compact)", value: topPaddingCompactBinding, range: 0 ... 20)
                SettingSlider(title: "Bottom (Compact)", value: bottomPaddingCompactBinding, range: 0 ... 20)
            } header: {
                Text("Vertical Padding (Landscape)")
            } footer: {
                Text("These settings apply only to compact height environments.")
            }
        } else {
            Section {
                SettingSlider(title: "Top", value: topPaddingBinding, range: 0 ... 30)
                SettingSlider(title: "Bottom", value: bottomPaddingBinding, range: 0 ... 30)
            } header: {
                Text("Vertical Padding (Portrait)")
            } footer: {
                Text("These settings apply only to regular height environments.")
            }
        }
    }
}

// MARK: - Bindings

private extension LayoutSettingsView {
    var itemsCountBinding: Binding<Int> {
        Binding(
            get: { viewModel.state.items.count },
            set: { count in
                let items = switch count {
                case 3: ExampleTabItem.threeItems
                case 4: ExampleTabItem.fourItems
                default: ExampleTabItem.fiveItems
                }
                viewModel.send(.updateItems(items))
            }
        )
    }

    func prominentBinding(for item: ExampleTabItem) -> Binding<Bool> {
        Binding(
            get: { item.style == .prominent },
            set: { _ in viewModel.send(.toggleProminentStyle(item.type)) }
        )
    }

    var tabSpacingBinding: Binding<CGFloat> {
        Binding(get: { viewModel.state.config.tabSpacing }, set: { viewModel.send(.updateTabSpacing($0)) })
    }

    var iconTitleSpacingBinding: Binding<CGFloat> {
        Binding(get: { viewModel.state.config.iconTitleSpacing }, set: { viewModel.send(.updateIconTitleSpacing($0)) })
    }

    var topPaddingBinding: Binding<CGFloat> {
        Binding(get: { viewModel.state.config.tabItemTopPadding }, set: { viewModel.send(.updateTabItemTopPadding($0)) })
    }

    var bottomPaddingBinding: Binding<CGFloat> {
        Binding(get: { viewModel.state.config.tabItemBottomPadding }, set: { viewModel.send(.updateTabItemBottomPadding($0)) })
    }

    var topPaddingCompactBinding: Binding<CGFloat> {
        Binding(get: { viewModel.state.config.tabItemTopPaddingCompact }, set: { viewModel.send(.updateTabItemTopPaddingCompact($0)) })
    }

    var bottomPaddingCompactBinding: Binding<CGFloat> {
        Binding(get: { viewModel.state.config.tabItemBottomPaddingCompact }, set: { viewModel.send(.updateTabItemBottomPaddingCompact($0)) })
    }
}

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()
    NavigationStack {
        ZStack(alignment: .bottom) {
            LayoutSettingsView(viewModel: viewModel)

            TabBarView(
                items: viewModel.state.items,
                selected: .constant(viewModel.state.items[0]),
                config: viewModel.state.config
            )
            .overlay(Divider(), alignment: .top)
        }
    }
}
