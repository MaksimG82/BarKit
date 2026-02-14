//
//  ExampleView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.01.26.
//

import AdaptiveTabBar
import SwiftUI

@available(iOS 17.0, *)
struct ExampleView: View {
    @State private var viewModel = ExampleViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            TabBarView(
                items: viewModel.state.items,
                selected: Binding(
                    get: { viewModel.state.selectedTab },
                    set: { viewModel.send(.selectTab($0)) }
                ),
                config: viewModel.state.config
            )
        }
        .debugLayout(viewModel.state.isDebugEnabled)
    }
}

@available(iOS 17.0, *)
#Preview {
    ExampleView()
}
