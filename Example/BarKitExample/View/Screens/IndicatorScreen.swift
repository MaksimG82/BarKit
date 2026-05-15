//
//  IndicatorScreen.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 15.05.26.
//

import SwiftUI
import BarKit

struct IndicatorScreen: View {
    
    @Environment(\.verticalSizeClass) var sizeClass
    
    let viewModel: ExampleViewModel
    
    let bindings: IndicatorBindings
    
    var body: some View {
        List {
            descriptionSection
            unavailableSection
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .toolbar { resetButton }
        .navigationTitle("Selection indicator")
    }
}

// MARK: - View Components

private extension IndicatorScreen {

    // MARK: - Description

    var descriptionSection: some View {
        Section {
            Text("Customize the selection indicator that highlights the active tab. Adjust its appearance, shape, animation, and Metal shader effects applied at the indicator boundary.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Unavailable

    @ViewBuilder
    var unavailableSection: some View {
        if viewModel.state.tabBar.mode == .pinned {
            Section {
                ContentUnavailableView(
                    "Indicator not available",
                    systemImage: "rectangle.slash",
                    description: Text("Selection indicator is only supported in Floating mode. Switch the Tab Bar to Floating to configure it.")
                )
            }
        }
    }

    // MARK: - Toolbar

    var resetButton: some View {
        Button("Reset Indicator settings") { }
    }
}

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()

    NavigationStack {
        ZStack(alignment: .bottom) {
            IndicatorScreen(viewModel: viewModel, bindings: .init(viewModel: viewModel))
            TabBarContainer(viewModel: viewModel)
        }
        .ignoresSafeArea(
            .all,
            edges: viewModel.state.tabBar.mode == .floating ? .bottom : []
        )
    }
    .onAppear {
        viewModel.send(.selectTab(ExampleTabItem.allItems[3]))
    }
}




//Indicator color + border
//Shape (cornerRadius, inset)
//Animation (transition + scaleEffect)
//Drag gesture toggle
//Effects (lensDistortion / chromaticAberration + их параметры)
