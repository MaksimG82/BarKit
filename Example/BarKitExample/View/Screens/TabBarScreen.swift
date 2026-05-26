//
//  TabBarScreen.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 05.05.26.
//

import SwiftUI
import BarKit

struct TabBarScreen: View {
    
    @Environment(\.verticalSizeClass) var sizeClass
    
    let viewModel: ExampleViewModel
    
    let bindings: TabBarBindings
    
    var body: some View {
        List {
            descriptionSection
            tabBarModePickerSection
            if viewModel.state.tabBar.mode == .floating {
                floatingLayoutLink
            }
            backgroundLink
            itemSettingsLink
            
            if viewModel.state.tabBar.mode == .floating {
                indicatorLink
            }
            hapticFeedbackLink
        }
        .floatingTabBarOffset(
            viewModel.contentOffset(sizeClass == .compact),
            barID: "tabBar"
        )

        .toolbar { resetButton }
        .navigationTitle("Tab bar")
    }
}

// MARK: - Navigation links

private extension TabBarScreen {

    var floatingLayoutLink: some View {
        settingsLink("Floating layout", viewModel: viewModel) {
            insetsSection
            insetsCompactSection
            cornerRadiusSection
            shadowSection
        }
    }

    var backgroundLink: some View {
        settingsLink("Background", viewModel: viewModel) {
            backgroundSection
        }
    }

    var itemSettingsLink: some View {
        settingsLink("Tab bar item", viewModel: viewModel) {
            itemConfigurationSection
        }
    }
    
    var hapticFeedbackLink: some View {
        settingsLink("Haptic feedback", viewModel: viewModel) {
              hapticFeedbackSection
            }
    }
    
    var indicatorLink: some View {
        settingsLink("Selection indicator", viewModel: viewModel) {
            IndicatorSection(
                viewModel: viewModel,
                bindings: .init(
                    viewModel: viewModel,
                    stateKeyPath: \.tabBar.floatingTabBarState.barConfiguration.indicator,
                    wrapIntent: { .tabBar(.floating(.indicator($0))) }
                ),
                stateKeyPath: \.tabBar.floatingTabBarState.barConfiguration.indicator
            )
        }
    }
    
}


// MARK: - View Components

private extension TabBarScreen {
 
    // MARK: - Description section
 
    var descriptionSection: some View {
        Section {
            Text("Configure the tab bar appearance and behavior. Switch between Floating and Pinned layouts using the toggle below.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
 
    // MARK: - Tab bar mode section
    
    var tabBarModePickerSection: some View {
        Section {
            Picker("Tab Bar Mode", selection: bindings.mode()) {
                Text("Floating").tag(TabBarMode.floating)
                Text("Pinned").tag(TabBarMode.pinned)
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Tab bar mode")
        }
    }
    
    // MARK: - Edge insets section
    
    var insetsSection: some View {
        Section {
            SettingSlider(
                title: "Leading",
                value: bindings.floatingInset(\.leading),
                range: 0...48
            )
            
            SettingSlider(
                title: "Trailing",
                value: bindings.floatingInset(\.trailing),
                range: 0...48
            )
            
            SettingSlider(
                title: "Bottom",
                value: bindings.floatingInset(\.bottom),
                range: 8...64
            )
        } header: {
            Text("Edge insets")
        } footer: {
            Text("Controls the distance of the floating bar from the screen edges.")
        }
    }
    
    var insetsCompactSection: some View {
        Section {
            SettingSlider(
                title: "Leading",
                value: bindings.floatingInsetCompact(\.leading),
                range: 0...48
            )

            SettingSlider(
                title: "Trailing",
                value: bindings.floatingInsetCompact(\.trailing),
                range: 0...48
            )

            SettingSlider(
                title: "Bottom",
                value: bindings.floatingInsetCompact(\.bottom),
                range: 8...64
            )
        } header: {
            Text("Edge insets (Compact)")
        } footer: {
            Text("Controls the distance of the floating bar from the screen edges in landscape.")
        }
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
    
    // MARK: - ItemConfigurationSection
    
    @ViewBuilder
    var itemConfigurationSection: some View {
        itemEdgeInsetsSection
        itemEdgeInsetsCompactSection
        itemColorsSection
        itemIconSizeSection
        itemTextStyleSection
        itemContentAxisSection
        if viewModel.state.tabBar.mode == .pinned {
            prominentItemsSection
        }
    }
    
    var itemEdgeInsetsSection: some View {
        ItemEdgeInsetsSection(
            title: "Item padding",
            top: bindings.regularItemConfiguration(\.edgeInsets.top),
            bottom: bindings.regularItemConfiguration(\.edgeInsets.bottom)
        )
    }

    var itemEdgeInsetsCompactSection: some View {
        ItemEdgeInsetsSection(
            title: "Item padding (Compact)",
            top: bindings.regularItemConfiguration(\.edgeInsetsCompact.top),
            bottom: bindings.regularItemConfiguration(\.edgeInsetsCompact.bottom)
        )
    }
    
    var itemColorsSection: some View {
        ItemColorsSection(
            selectedColor: bindings.regularItemConfiguration(\.selectedColor),
            unselectedColor: bindings.regularItemConfiguration(\.unselectedColor)
        )
    }
    
    var itemIconSizeSection: some View {
        Section {
            SettingSlider(
                title: "Icon Size",
                value: bindings.regularItemConfiguration(\.iconSideLength),
                range: 16...48
            )
            SettingSlider(
                title: "Selected Scale",
                value: bindings.regularItemConfiguration(\.selectedIconScale),
                range: 1.0...1.5,
                step: 0.01,
                format: .fractionalTwo
            )
            SettingSlider(
                title: "Compact Scale",
                value: bindings.regularItemConfiguration(\.compactIconScale),
                range: 0.5...1.0,
                step: 0.01,
                format: .fractionalTwo
            )
        } header: {
            Text("Icon size")
        }
    }
    
    var itemTextStyleSection: some View {
        ItemTextStyleSection(textStyle: bindings.regularItemConfiguration(\.textStyle))
    }
    
    var itemContentAxisSection: some View {
        ItemContentAxisSection(axis: bindings.itemContentAxis())
    }
    
    var prominentItemsSection: some View {
        Section {
            ForEach(viewModel.state.tabBarItems) { item in
                Toggle(item.title, isOn: bindings.tabItemStyle(for: item))
            }
            SettingSlider(
                title: "Icon Size",
                value: bindings.prominentItemConfiguration(\.iconSideLength),
                range: 24...56
            )
        } header: {
            Text("Prominent items")
        } footer: {
            Text("Only icon size is configurable for prominent style.")
        }
    }
    
    // MARK: - Haptic Feedback section

    var hapticFeedbackSection: some View {
        HapticFeedbackSection(
            isEnabled: bindings.hapticFeedbackEnabled(),
            hapticFeedback: bindings.hapticFeedback()
        )
    }
    
    // MARK: - Toolbar
    
    var resetButton: some View {
        Button("Reset tab bar settings") {
            viewModel.send(.tabBar(.reset))
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()
    @Previewable @Environment(\.verticalSizeClass) var sizeClass
    
    ZStack(alignment: .bottom) {
        NavigationStack {
            TabBarScreen(
                viewModel: viewModel,
                bindings: .init(viewModel: viewModel)
            )
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        
        TabBarContainer(viewModel: viewModel)
    }
    .ignoresSafeArea(
        .all,
        edges: viewModel.state.tabBar.mode == .floating ? .bottom : []
    )
    .onAppear {
        viewModel.send(.tabBar(.selectTab(ExampleTabItem.allItems[1])))
    }
}
