//
//  ExampleContentView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.01.26.
//

import AdaptiveTabBar
import SwiftUI

struct ExampleContentView: View {
    // MARK: - Property Wrappers

    @Environment(\.tabBarHeight) var tabBarHeight
    @Environment(\.verticalSizeClass) var sizeClass
    @State private var viewModel = ExampleViewModel()

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                List {
                    headerSection
                    styleSection
                    appearanceSection
                    layoutSection
                    animationSection
                }
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: currentBarHeight()) }
                .toolbar {
                    Button("Reset all changes") { viewModel.send(.resetState) }
                }
                .navigationTitle("AdaptiveTabBar")
            }
            .environment(\.tabBarHeight, currentBarHeight())
            
            VStack(spacing: 0) {
                if case .pinned = viewModel.state.config.style {
                    Divider()
                }
                
                tabBar
            }
        }
    }
}

// MARK: - View Components

private extension ExampleContentView {
    var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                Text("Explore how the tab bar adapts to different configurations.\nChange colors, sizes, layout settings to find the perfect fit for your app.")
                    .font(.subheadline)

                Text("Note: Tab selection only updates the UI state and does not perform actual navigation.")
                    .font(.subheadline)
            }
            .padding(.vertical, 4)
        }
    }

    var styleSection: some View {
        Section("Layout Style") {
            Picker("Selection Style", selection: Binding(
                get: {
                    switch viewModel.state.config.style {
                    case .pinned: "pinned"
                    case .floating: "floating"
                    }
                },
                set: { newValue in
                    let newStyle: TabBarStyle = (newValue == "pinned") ? .pinned : .floating(.init())
                    viewModel.send(.updateLayoutStyle(newStyle))
                }
            )) {
                Text("Pinned").tag("pinned")
                Text("Floating").tag("floating")
            }
            .pickerStyle(.segmented)
            .padding(.vertical, 4)

            if case .floating = viewModel.state.config.style {
                NavigationLink("Floating Settings") {
                    Text("FloatingSettingsView")
                }
            }
        }
    }

    var appearanceSection: some View {
        Section("Appearance") {
            NavigationLink("Colors") { ColorsSettingsView(viewModel: viewModel) }
            NavigationLink("Typography") { TypographySettingsView(viewModel: viewModel) }
            NavigationLink("Icon Sizes") { IconSizeSettingsView(viewModel: viewModel) }
        }
    }

    var layoutSection: some View {
        Section("Layout") {
            NavigationLink("Tabs Layout") { LayoutSettingsView(viewModel: viewModel) }

            Toggle("Debug Layout", isOn: Binding(
                get: { viewModel.state.isDebugLayoutEnabled },
                set: { _ in viewModel.send(.toggleDebugLayout) }
            ))
        }
    }

    var animationSection: some View {
        Section("Animation") {
            NavigationLink("Configuration") { AnimationSettingsView(viewModel: viewModel) }
        }
    }

    var tabBar: some View {
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

    // MARK: - Helping methods

    func currentBarHeight() -> CGFloat {
        viewModel.state.config.calculatedBarHeight(
            isVerticalCompact: sizeClass == .compact
        )
    }
}

#Preview {
    ExampleContentView()
}
