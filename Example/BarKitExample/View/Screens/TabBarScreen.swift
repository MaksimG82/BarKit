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
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
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
            .defersSystemGestures(on: .all)
            
            SettingSlider(
                title: "Trailing",
                value: bindings.floatingInset(\.trailing),
                range: 0...48
            )
            .defersSystemGestures(on: .all)
            
            SettingSlider(
                title: "Bottom",
                value: bindings.floatingInset(\.bottom),
                range: 8...64
            )
            .defersSystemGestures(on: .all)
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
            .defersSystemGestures(on: .all)

            SettingSlider(
                title: "Trailing",
                value: bindings.floatingInsetCompact(\.trailing),
                range: 0...48
            )
            .defersSystemGestures(on: .all)

            SettingSlider(
                title: "Bottom",
                value: bindings.floatingInsetCompact(\.bottom),
                range: 8...64
            )
            .defersSystemGestures(on: .all)
        } header: {
            Text("Edge insets (Compact)")
        } footer: {
            Text("Controls the distance of the floating bar from the screen edges in landscape.")
        }
    }
    
    // MARK: - Background section
    
    var backgroundSection: some View {
        Section {
            Picker("Type", selection: bindings.backgroundType()) {
                ForEach(BarBackgroundType.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            switch bindings.background().wrappedValue {
            case .color:
                ColorPicker("Color", selection: bindings.backgroundColor())
            case .material(_, _):
                ColorPicker("Tint", selection: bindings.backgroundColor())
                
                Picker("Material", selection: bindings.materialSelection()) {
                    ForEach(MaterialSelection.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
            case .customBlur(_, _):
                ColorPicker("Tint", selection: bindings.backgroundColor())
                Text("Coming soon")
            }
            
        } header: {
            Text("Background")
        } footer: {
            Text("Defines the visual fill of the bar — solid color, system blur, or custom blur.")
        }
    }
    
    // MARK: - Corner Radius Section
    
    var cornerRadiusSection: some View {
        Section {
            SettingSlider(
                title: "Corner Radius",
                value: bindings.cornerRadius(),
                range: 0...40
            )
        } header: {
            Text("Corner radius")
        } footer: {
            if viewModel.state.tabBar.mode == .pinned {
                Text("Corner radius has no effect in Pinned mode.")
            }
        }
    }
    
    // MARK: - Shadow Section
    
    var shadowSection: some View {
        Section {
            Toggle("Shadow", isOn: bindings.shadowEnabled())
            if viewModel.floatingTabBarConfig.shadow != nil {
                ColorPicker("Color", selection: bindings.shadowColor())
                SettingSlider(
                    title: "Radius",
                    value: bindings.shadow(\.radius),
                    range: 0...24
                )
                SettingSlider(
                    title: "X",
                    value: bindings.shadow(\.x),
                    range: -16...16,
                    step: 0.01,
                    format: .fractionalTwo
                )
                
                SettingSlider(
                    title: "Y",
                    value: bindings.shadow(\.y),
                    range: -16...16,
                    step: 0.01,
                    format: .fractionalTwo
                )
            }
        } header: {
            Text("Shadow")
        } footer: {
            Text("Shadow has no effect in Pinned mode.")
                .opacity(viewModel.state.tabBar.mode == .pinned ? 1 : 0)
        }
    }
    
    // MARK: - ItemConfigurationSection
    
    @ViewBuilder
    var itemConfigurationSection: some View {
        itemEdgeInsetsSection
        itemEdgeInsetsCompactSection
        itemColorsSection
        itemIconSizeSection
        itemTextStyleSection
        if viewModel.state.tabBar.mode == .pinned {
            prominentItemsSection
        }
    }
    
    var itemEdgeInsetsSection: some View {
        Section {
            SettingSlider(
                title: "Top",
                value: bindings.regularItemConfig(\.edgeInsets.top),
                range: 0...24
            )
            SettingSlider(
                title: "Bottom",
                value: bindings.regularItemConfig(\.edgeInsets.bottom),
                range: 0...24
            )
        } header: {
            Text("Item padding")
        }
    }

    var itemEdgeInsetsCompactSection: some View {
        Section {
            SettingSlider(
                title: "Top",
                value: bindings.regularItemConfig(\.edgeInsetsCompact.top),
                range: 0...24
            )
            SettingSlider(
                title: "Bottom",
                value: bindings.regularItemConfig(\.edgeInsetsCompact.bottom),
                range: 0...24
            )
        } header: {
            Text("Item padding (Compact)")
        }
    }
    
    var itemColorsSection: some View {
        Section {
            ColorPicker("Selected", selection: bindings.regularItemConfig(\.selectedColor))
            ColorPicker("Unselected", selection: bindings.regularItemConfig(\.unselectedColor))
        } header: {
            Text("Item colors")
        }
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
            SettingSlider(
                title: "Compact Scale",
                value: bindings.regularItemConfig(\.compactIconScale),
                range: 0.5...1.0,
                step: 0.01,
                format: .fractionalTwo
            )
        } header: {
            Text("Icon size")
        }
    }
    
    var itemTextStyleSection: some View {
        Section {
            Picker("Text Style", selection: bindings.regularItemConfig(\.textStyle)) {
                ForEach(Font.TextStyle.allCases, id: \.self) {
                    Text(String(describing: $0)).tag($0)
                }
            }
        } header: {
            Text("Text style")
        }
    }
    
    var prominentItemsSection: some View {
        Section {
            ForEach(viewModel.state.items) { item in
                Toggle(item.title, isOn: bindings.tabItemStyle(for: item))
            }
            SettingSlider(
                title: "Icon Size",
                value: bindings.prominentItemConfig(\.iconSideLength),
                range: 24...56
            )
        } header: {
            Text("Prominent items")
        } footer: {
            Text("Only icon size is configurable for prominent style.")
        }
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
        viewModel.send(.selectTab(ExampleTabItem.allItems[1]))
    }
}
