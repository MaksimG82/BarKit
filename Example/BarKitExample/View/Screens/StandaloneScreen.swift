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
                indicatorLink
                appearanceLink
            }
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .toolbar { resetButton }
        .navigationTitle("Standalone")
    }}


// MARK: - View Components

// MARK: - Navigation links

private extension StandaloneScreen {
    
    var appearanceLink: some View {
        settingsLink("Appearance", viewModel: viewModel) {
            barPreview
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            cornerRadiusSection
            shadowSection
            
        }
    }

    var backgroundLink: some View {
        settingsLink("Background", viewModel: viewModel) {
//            backgroundSection
        }
    }

    var itemSettingsLink: some View {
        settingsLink("Tab bar item", viewModel: viewModel) {
//            itemConfigurationSection
        }
    }
    
    var hapticFeedbackLink: some View {
        settingsLink("Haptic feedback", viewModel: viewModel) {
//              hapticFeedbackSection
            }
    }
    
    var indicatorLink: some View {
        settingsLink("Selection indicator", viewModel: viewModel) {
            IndicatorSection(
                viewModel: viewModel,
                bindings: .init(
                    viewModel: viewModel,
                    stateKeyPath: \.standalone.indicator,
                    wrapIntent: { .standalone(.indicator($0)) }
                ),
                stateKeyPath: \.standalone.indicator,
                preview: { barPreview }
            )
        }
    }
    
}


extension StandaloneScreen {

    // MARK: - Preview
    
    /// A live preview of the standalone bar adapting to the current axis.
    var barPreview: some View {
        Group {
            switch viewModel.state.standalone.barConfiguration.axis {
            case .horizontal:
                VStack(spacing: 0) {
                    previewContent
                    barView
                }
            case .vertical:
                HStack(spacing: 0) {
                    barView
                    previewContent
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
        .padding(viewModel.state.standalone.insets)
    }

    private var barView: some View {
        BarView(
            items: viewModel.state.standalone.items,
            selected: bindings.selectedItem(),
            config: viewModel.state.standalone.barConfiguration,
            indicatorConfig: viewModel.state.standalone.indicator.configuration
        )
    }

    private var previewContent: some View {
        ZStack {
            Color(.secondarySystemBackground)
            VStack(spacing: 8) {
                Image(systemName: viewModel.state.standalone.selectedItem.icon.name)
                    .font(.system(size: 32))
                Text(viewModel.state.standalone.selectedItem.title)
                    .font(.headline)
            }
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: viewModel.state.standalone.barConfiguration.axis == .horizontal ? 120 : nil)
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
    
    // MARK: - Corner Radius Section
    
    var cornerRadiusSection: some View {
        CornerRadiusSection(cornerRadius: bindings.cornerRadius())
    }
    
    // MARK: - Shadow Section
    
    var shadowSection: some View {
        ShadowSection(
            shadowEnabled: bindings.shadowEnabled(),
            shadowColor: bindings.shadowColor(),
            shadowRadius: bindings.shadow(\.radius),
            shadowX: bindings.shadow(\.x),
            shadowY: bindings.shadow(\.y)
        )
    }
    
    // MARK: - Toolbar

    var resetButton: some View {
        Button("Reset bar settings") {
            viewModel.send(.standalone(.reset))
        }
    }
}
