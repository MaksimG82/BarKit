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
                items: viewModel.state.items,
                selected: selectedItem,
                config: viewModel.floatingTabBarConfig,
                indicatorConfig: viewModel.state.indicator.indicatorConfig,
                floatingInsets: viewModel.state.tabBar.floatingTabBarState.insets
            )
            
        case .pinned:
            PinnedTabBarView(
                items: viewModel.state.items,
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
