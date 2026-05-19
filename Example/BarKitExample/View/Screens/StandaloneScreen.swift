//
//  StandaloneScreen.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI
import BarKit

struct StandaloneScreen: View {
    
    @Environment(\.verticalSizeClass) var sizeClass

    
    let viewModel: ExampleViewModel
    
    let bindings: StandaloneBindings
    
    var body: some View {
        VStack(spacing: 0) {
            barPreview
            List {
                axisSection
            }
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .toolbar { resetButton }
        .navigationTitle("Standalone")
    }}


// MARK: - View Components

extension StandaloneScreen {

    // MARK: - Preview
    
    /// A live preview of the standalone bar.
    var barPreview: some View {
        BarView(
            items: viewModel.state.standalone.items,
            selected: bindings.selectedItem(),
            config: viewModel.state.standalone.barConfiguration
        )
        .padding(viewModel.state.standalone.insets)
        .background(Color(.secondarySystemBackground))
    }
    
    // MARK: - Axis
    
    /// A section for switching the bar layout axis.
    var axisSection: some View {
        Section {
            Picker("Axis", selection: bindings.axis()) {
                Text("Horizontal").tag(BarConfiguration.Axis.horizontal)
                Text("Vertical").tag(BarConfiguration.Axis.vertical)
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Axis")
        }
    }
    
    // MARK: - Toolbar

    var resetButton: some View {
        Button("Reset bar settings") {
            viewModel.send(.standalone(.reset))
        }
    }
}
