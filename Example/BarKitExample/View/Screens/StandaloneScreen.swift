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
                appearanceLink
                backgroundLink
                indicatorLink
                itemSettingsLink
                hapticFeedbackLink
            }
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .toolbar { resetButton }
        .navigationTitle("Standalone")
    }
}


// MARK: - View Components

// MARK: - Navigation links

private extension StandaloneScreen {
    
    var appearanceLink: some View {
        settingsLink("Appearance", viewModel: viewModel, header: { barPreview }) {
            cornerRadiusSection
            shadowSection
        }
    }
    
    var indicatorLink: some View {
        settingsLink("Selection indicator", viewModel: viewModel, header: { barPreview }){
            indicatorSection
        }
    }

    var backgroundLink: some View {
        settingsLink("Background", viewModel: viewModel, header: { barPreview }) {
            backgroundSection
        }
    }

    
    var hapticFeedbackLink: some View {
        settingsLink("Haptic feedback", viewModel: viewModel) {
              hapticFeedbackSection
            }
    }
    
    var itemSettingsLink: some View {
        settingsLink("Bar item", viewModel: viewModel, header: { barPreview }) {
            itemConfigurationSection
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
                VStack(spacing: 8) {
                    previewContent
                    barView
                }
            case .vertical:
                HStack(spacing: 16) {
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
            config: viewModel.state.standalone.barConfiguration
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
        .cornerRadius(16)
    }
    
    // MARK: - Axis
    
    /// A section for switching the bar layout axis.
    var axisSection: some View {
        Section {
            Picker("Axis", selection: bindings.axis()) {
                Text("Horizontal").tag(BarLayoutAxis.horizontal)
                Text("Vertical").tag(BarLayoutAxis.vertical)
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
    
    // MARK: indicator section
    var indicatorSection: some View {
        IndicatorSection(
            viewModel: viewModel,
            bindings: .init(
                viewModel: viewModel,
                stateKeyPath: \.standalone.barConfiguration.indicator,
                wrapIntent: { .standalone(.indicator($0)) }
            ),
            stateKeyPath: \.standalone.barConfiguration.indicator,
            preview: { barPreview }
        )
    }
    
    // MARK: - Background section
    
    var backgroundSection: some View {
        BarBackgroundSection(
            background: bindings.background(),
            backgroundType: bindings.backgroundType(),
            backgroundColor: bindings.backgroundColor(),
            materialSelection: bindings.materialSelection()
        )
    }
    
    // MARK: - Haptic Feedback section

    var hapticFeedbackSection: some View {
        HapticFeedbackSection(
            isEnabled: bindings.hapticFeedbackEnabled(),
            hapticFeedback: bindings.hapticFeedback()
        )
    }
    
    // MARK: - ItemConfigurationSection
    
    @ViewBuilder
    var itemConfigurationSection: some View {
        itemEdgeInsetsSection
        itemColorsSection
        itemIconSizeSection
        itemTextStyleSection
        itemContentAxisSection
        itemAlignmentSection
        itemContentAlignmentSection
    }
    
    var itemEdgeInsetsSection: some View {
        ItemEdgeInsetsSection(
            title: "Item padding",
            top: bindings.regularItemConfig(\.edgeInsets.top),
            bottom: bindings.regularItemConfig(\.edgeInsets.bottom),
            leading: bindings.regularItemConfig(\.edgeInsets.leading),
            trailing: bindings.regularItemConfig(\.edgeInsets.trailing),
            
        )
    }
    
    var itemColorsSection: some View {
        ItemColorsSection(
            selectedColor: bindings.regularItemConfig(\.selectedColor),
            unselectedColor: bindings.regularItemConfig(\.unselectedColor)
        )
    }
    
    var itemIconSizeSection: some View {
        Section {
            SettingSlider(
                title: "Icon Size",
                value: bindings.regularItemConfig(\.iconSideLength),
                range: 16...48
            )
            SettingSlider(
                title: "Selected Scale",
                value: bindings.regularItemConfig(\.selectedIconScale),
                range: 1.0...1.5,
                step: 0.01,
                format: .fractionalTwo
            )
        } header: {
            Text("Icon size")
        }
    }
    
    var itemTextStyleSection: some View {
        ItemTextStyleSection(textStyle: bindings.regularItemConfig(\.textStyle))
    }
    
    var itemContentAxisSection: some View {
        ItemContentAxisSection(axis: bindings.itemContentAxis())
    }
    
    var itemAlignmentSection: some View {
        Section {
            Picker("Item Alignment", selection: bindings.itemAlignment()) {
                Text("Start").tag(BarItemAlignment.start)
                Text("Center").tag(BarItemAlignment.center)
                Text("End").tag(BarItemAlignment.end)
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Item alignment")
        }
    }

    var itemContentAlignmentSection: some View {
        Section {
            Picker("Content Alignment", selection: bindings.itemContentAlignment()) {
                Text("Start").tag(BarItemAlignment.start)
                Text("Center").tag(BarItemAlignment.center)
                Text("End").tag(BarItemAlignment.end)
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Item content alignment")
        }
    }
    
    // MARK: - Toolbar

    var resetButton: some View {
        Button("Reset bar settings") {
            viewModel.send(.standalone(.reset))
        }
    }
}
