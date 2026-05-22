//
//  ExampleContentView.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 12.01.26.
//

import BarKit
import SwiftUI

struct ExampleContentView: View {
 
    @Environment(\.verticalSizeClass) private var sizeClass
    
    // MARK: - Property Wrappers
 
    @State private var viewModel = ExampleViewModel()
 
    // MARK: - Body
 
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                contentRouter
            }
            .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
            TabBarContainer(viewModel: viewModel)
                .id(viewModel.state.instanceID)
        }
        .ignoresSafeArea(
            .all,
            edges: viewModel.state.tabBar.mode == .floating ? .bottom : []
        )
    }
}
 
// MARK: - Subviews
 
private extension ExampleContentView {
 
    /// Routes to the appropriate screen based on the selected tab.
    @ViewBuilder
    var contentRouter: some View {
        switch viewModel.state.selectedTab.type {
        case .overview:   Text("Overview")
        case .tabBar:     TabBarScreen(
            viewModel: viewModel,
            bindings: .init(viewModel: viewModel)
        )
        case .standalone: StandaloneScreen(
            viewModel: viewModel,
            bindings: .init(viewModel: viewModel)
        )
        case .codegeneration: Text("Under construction")
        }
    }
 
    /// A binding that bridges `ExampleTabItem` selection to `ExampleIntent`.
    var selectedItem: Binding<ExampleTabItem> {
        Binding(
            get: { viewModel.state.selectedTab },
            set: { viewModel.send(.tabBar(.selectTab($0))) }
        )
    }
}
 
#Preview() {
    ExampleContentView()
}
