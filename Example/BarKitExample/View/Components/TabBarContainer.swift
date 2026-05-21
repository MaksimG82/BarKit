//
//  TabBarContainer.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 05.05.26.
//

import SwiftUI
import BarKit

struct TabBarContainer: View {
    
    let viewModel: ExampleViewModel
    
    var body: some View {
        switch viewModel.state.tabBar.mode {
        case .floating:
            FloatingTabBarView(
                items: viewModel.state.tabBarItems,
                selected: selectedItem,
                config: viewModel.floatingTabBarConfig,
                indicatorConfig: viewModel.state.tabBar.indicator.configuration,
                floatingInsets: viewModel.state.tabBar.floatingTabBarState.insets,
                floatingInsetsCompact: viewModel.state.tabBar.floatingTabBarState.insetsCompact
            )
            
        case .pinned:
            PinnedTabBarView(
                items: viewModel.state.tabBarItems,
                selected: selectedItem,
                config: viewModel.pinnedTabBarConfig
            )
        }
    }
}

extension TabBarContainer {
    var selectedItem: Binding<ExampleTabItem> {
        Binding(
            get: { viewModel.state.selectedTab },
            set: { viewModel.send(.selectTab($0)) }
        )
    }
}
