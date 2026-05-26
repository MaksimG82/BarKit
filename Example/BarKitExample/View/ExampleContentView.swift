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
    
    @State private var barVisibility: [String: Visibility] = [:]
 
    // MARK: - Body
 
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                contentRouter
            }
            .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
            
            if barVisibility["tabBar"] != .hidden {
                TabBarContainer(viewModel: viewModel)
                    .id(viewModel.state.instanceID)
            }
        }
        .registerBarVisibility($barVisibility)
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
        case .overview:
            OverviewView()
        case .tabBar:
            TabBarScreen(
            viewModel: viewModel,
            bindings: .init(viewModel: viewModel
                           )
        )
        case .standalone:
            StandaloneScreen(
            viewModel: viewModel,
            bindings: .init(viewModel: viewModel
                           )
        )
        case .codegeneration:
            CodeGenerationScreen(viewModel: viewModel)
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
