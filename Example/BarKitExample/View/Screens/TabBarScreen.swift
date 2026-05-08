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
    
    var body: some View {
        List {
            descriptionSection
            tabBarModePickerSection
            if viewModel.state.tabBar.mode == .floating {
                insetsSection
            }
            backgroundSection
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .toolbar { resetButton }
        .navigationTitle("Tab Bar")
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
            Picker("Tab Bar Mode", selection: tabBarModeBinding) {
                Text("Floating").tag(TabBarMode.floating)
                Text("Pinned").tag(TabBarMode.pinned)
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Tab bar mode")
        } footer: {
            Text("Floating renders a detached capsule above the home indicator. \nPinned spans the full screen width.")
        }
    }
    
    // MARK: - Edge insets section
    
    var insetsSection: some View {
        Section {
            SettingSlider(
                title: "Leading",
                value: floatingTabBarInsetBinding(\.leading),
                range: 0...48
            )
            .defersSystemGestures(on: .all)

            SettingSlider(
                title: "Trailing",
                value: floatingTabBarInsetBinding(\.trailing),
                range: 0...48
            )
            .defersSystemGestures(on: .all)

            SettingSlider(
                title: "Bottom",
                value: floatingTabBarInsetBinding(\.bottom),
                range: 8...64
            )
            .defersSystemGestures(on: .all)
        } header: {
            Text("Edge insets")
        } footer: {
            Text("Controls the distance of the floating bar from the screen edges.")
        }
    }
    
    // MARK: - Background section
    
    var backgroundSection: some View {
        Section {
            Picker("Type", selection: backgroundTypeBinding) {
                ForEach(BarBackgroundType.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            switch backgroundBinding.wrappedValue {
            case .color:
                ColorPicker("Color", selection: backgroundColorBinding)
            case .material(_, _):
                ColorPicker("Tint", selection: backgroundColorBinding)
                
                Picker("Material", selection: materialSelectionBinding) {
                    ForEach(MaterialSelection.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
            case .customBlur(_, _):
                ColorPicker("Tint", selection: backgroundColorBinding)
                Text("Coming soon")
            }
            
        } header: {
            Text("Background")
        } footer: {
            Text("Defines the visual fill of the bar — solid color, system blur, or custom blur.")
        }
    }
    
    
    // MARK: - Toolbar
    
    var resetButton: some View {
        Button("Reset Tab bar settings") { }
    }
}

// MARK: - Bindings

private extension TabBarScreen {
    
    // MARK: - Tab bar mode
    
    var tabBarModeBinding: Binding<TabBarMode> {
        Binding (
            get: { viewModel.state.tabBar.mode },
            set: { viewModel.send(.tabBar(.switchMode( $0 ))) }
        )
    }
    
    // MARK: - Background section
    
    var currentBackgroundColor: Color {
        switch backgroundBinding.wrappedValue {
        case let .color(color):          return color
        case let .material(_, tint):     return tint
        case let .customBlur(_, tint):   return tint
        }
    }
    
    var backgroundBinding: Binding<BarBackground> {
        Binding(
            get: {
                switch viewModel.state.tabBar.mode {
                case .floating: viewModel.floatingTabBarConfig.background
                case .pinned:   viewModel.pinnedTabBarConfig.background
                }
            },
            set: {
                switch viewModel.state.tabBar.mode {
                case .floating: viewModel.send(.tabBar(.floating(.updateBackground($0))))
                case .pinned:   viewModel.send(.tabBar(.pinned(.updateBackground($0))))
                }
            }
        )
    }
    
    var backgroundTypeBinding: Binding<BarBackgroundType> {
        Binding(
            get: {
                switch backgroundBinding.wrappedValue {
                case .color:      .color
                case .material:   .material
                case .customBlur: .customBlur
                }
            },
            set: { newType in
                switch newType {
                case .color:      backgroundBinding.wrappedValue = .color(currentBackgroundColor)
                case .material:   backgroundBinding.wrappedValue = .material(.ultraThinMaterial, tint: currentBackgroundColor)
                case .customBlur: backgroundBinding.wrappedValue = .customBlur(.init(), tint: currentBackgroundColor)
                }
            }
        )
    }
    
    var backgroundColorBinding: Binding<Color> {
        Binding(
            get: { currentBackgroundColor },
            set: { newColor in
                switch backgroundBinding.wrappedValue {
                case .color:
                    backgroundBinding.wrappedValue = .color(newColor)
                case let .material(material, _):
                    backgroundBinding.wrappedValue = .material(material, tint: newColor)
                case let .customBlur(config, _):
                    backgroundBinding.wrappedValue = .customBlur(config, tint: newColor)
                }
            }
        )
    }
    
    var materialSelectionBinding: Binding<MaterialSelection> {
        Binding(
            get: {
                switch viewModel.state.tabBar.mode {
                case .floating: viewModel.state.tabBar.floatingTabBarMaterialSelection
                case .pinned:   viewModel.state.tabBar.pinnedTabBarMaterialSelection
                }
            },
            set: { materialSelection in
                viewModel.send(.tabBar(.update(materialSelection)))
                let tint = currentBackgroundColor
                let newBackground: BarBackground = .material(materialSelection.material ?? .ultraThin, tint: tint)
                backgroundBinding.wrappedValue = newBackground
            }
        )
    }
    
    // MARK: - Edge insets section
    
    func floatingTabBarInsetBinding(
        _ keyPath: WritableKeyPath<EdgeInsets, CGFloat>
    ) -> Binding<CGFloat> {
        Binding(
            get: {
                viewModel.state.tabBar.floatingTabBarState.insets[keyPath: keyPath]
            },
            set: { newValue in
                var insets = viewModel.state.tabBar.floatingTabBarState.insets
                insets[keyPath: keyPath] = newValue
                viewModel.send(.tabBar(.floating(.updateInsets(insets))))
            }
        )
    }
}

enum BarBackgroundType: String, CaseIterable {
    case color    = "Color"
    case material = "Material"
    case customBlur = "Custom Blur"
}

enum MaterialSelection: String, CaseIterable {
    case bar = "bar"
    case ultraThin = "Ultra Thin"
    case thin = "Thin"
    case regular = "Regular"
    case thick = "Thick"

    var material: Material? {
        switch self {
        case .bar: .bar
        case .ultraThin: .ultraThinMaterial
        case .thin: .thinMaterial
        case .regular: .regularMaterial
        case .thick: .thickMaterial
        }
    }
}

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()

    NavigationStack {
        ZStack(alignment: .bottom) {
            TabBarScreen(viewModel: viewModel)
            TabBarContainer(viewModel: viewModel)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    .onAppear {
        viewModel.send(.selectTab(ExampleTabItem.allItems[1]))
    }
}
