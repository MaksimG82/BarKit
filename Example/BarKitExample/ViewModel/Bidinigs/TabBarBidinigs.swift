//
//  TabBar.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 15.05.26.
//

import SwiftUI
import BarKit

/// Bindings scoped to the Tab Bar screen.
final class TabBarBindings: BindingProvider {
    
    // MARK: - Dependencies
    
    let viewModel: ExampleViewModel
    
    // MARK: - Initialization
    
    init(viewModel: ExampleViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - TabBar Mode
    
    /// Binding for the current tab bar mode (floating / pinned).
    func mode() -> Binding<TabBarMode> {
        binding(
            get: { self.viewModel.state.tabBar.mode },
            keyPath: \.self,
            send: { .tabBar(.switchMode($0)) }
        )
    }
    
    // MARK: - Background

    /// The current tint or solid color extracted from the active background configuration.
    private var currentBackgroundColor: Color {
        switch background().wrappedValue {
        case let .color(color):        return color
        case let .material(_, tint):   return tint
        case let .customBlur(_, tint): return tint
        }
    }

    /// Binding for the full `BarBackground` of the currently active tab bar mode.
    func background() -> Binding<BarBackground> {
        Binding(
            get: {
                switch self.viewModel.state.tabBar.mode {
                case .floating: self.viewModel.floatingTabBarConfig.background
                case .pinned:   self.viewModel.pinnedTabBarConfig.background
                }
            },
            set: {
                self.viewModel.send(.tabBar(.updateBackground($0)))
            }
        )
    }

    /// Binding for the background type (color / material / customBlur), preserving current tint on switch.
    func backgroundType() -> Binding<BarBackgroundType> {
        Binding(
            get: {
                switch self.background().wrappedValue {
                case .color:      .color
                case .material:   .material
                case .customBlur: .customBlur
                }
            },
            set: { newType in
                switch newType {
                case .color:      self.background().wrappedValue = .color(self.currentBackgroundColor)
                case .material:   self.background().wrappedValue = .material(.ultraThin, tint: self.currentBackgroundColor)
                case .customBlur: self.background().wrappedValue = .customBlur(.init(), tint: self.currentBackgroundColor)
                }
            }
        )
    }

    /// Binding for the tint or solid color of the active background, preserving the current background type.
    func backgroundColor() -> Binding<Color> {
        Binding(
            get: { self.currentBackgroundColor },
            set: { newColor in
                switch self.background().wrappedValue {
                case .color:
                    self.background().wrappedValue = .color(newColor)
                case let .material(material, _):
                    self.background().wrappedValue = .material(material, tint: newColor)
                case let .customBlur(config, _):
                    self.background().wrappedValue = .customBlur(config, tint: newColor)
                }
            }
        )
    }

    /// Binding for the material selection, updating both the material state and the background configuration.
    func materialSelection() -> Binding<BarMaterial> {
        Binding(
            get: {
                switch self.viewModel.state.tabBar.mode {
                case .floating:
                    if case let .material(barMaterial, _) = self.viewModel.floatingTabBarConfig.background {
                        return barMaterial
                    }
                    return .ultraThin
                case .pinned:
                    if case let .material(barMaterial, _) = self.viewModel.pinnedTabBarConfig.background {
                        return barMaterial
                    }
                    return .ultraThin
                }
            },
            set: { barMaterial in
                let tint = self.currentBackgroundColor
                self.background().wrappedValue = .material(barMaterial, tint: tint)
            }
        )
    }
    
    // MARK: - Insets

    /// Binding for a single edge of the floating tab bar insets in regular mode.
    func floatingInset(_ keyPath: WritableKeyPath<EdgeInsets, CGFloat>) -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.state.tabBar.floatingTabBarState.insets },
            keyPath: keyPath,
            send: { .tabBar(.floating(.updateInsets($0))) }
        )
    }

    /// Binding for a single edge of the floating tab bar insets in compact mode.
    func floatingInsetCompact(_ keyPath: WritableKeyPath<EdgeInsets, CGFloat>) -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.state.tabBar.floatingTabBarState.insetsCompact },
            keyPath: keyPath,
            send: { .tabBar(.floating(.updateInsetsCompact($0))) }
        )
    }
    
    /// Binding for the corner radius of the floating tab bar.
    func cornerRadius() -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.floatingTabBarConfig },
            keyPath: \.cornerRadius,
            send: { .tabBar(.floating(.updateCornerRadius($0.cornerRadius))) }
        )
    }
    
    // MARK: - Shadow

    /// Binding for the shadow visibility of the floating tab bar.
    func shadowEnabled() -> Binding<Bool> {
        Binding(
            get: { self.viewModel.floatingTabBarConfig.shadow != nil },
            set: { self.viewModel.send(.tabBar(.floating(.updateShadow($0 ? .init() : nil)))) }
        )
    }

    /// Binding for the shadow color of the floating tab bar.
    func shadowColor() -> Binding<Color> {
        Binding(
            get: { self.viewModel.floatingTabBarConfig.shadow?.color ?? .black.opacity(0.2) },
            set: {
                var shadow = self.viewModel.floatingTabBarConfig.shadow ?? .init()
                shadow.color = $0
                self.viewModel.send(.tabBar(.floating(.updateShadow(shadow))))
            }
        )
    }

    /// Binding for a single property of the floating tab bar shadow configuration.
    func shadow(_ keyPath: WritableKeyPath<ShadowConfiguration, CGFloat>) -> Binding<CGFloat> {
        Binding(
            get: { self.viewModel.floatingTabBarConfig.shadow?[keyPath: keyPath] ?? 0 },
            set: {
                var shadow = self.viewModel.floatingTabBarConfig.shadow ?? .init()
                shadow[keyPath: keyPath] = $0
                self.viewModel.send(.tabBar(.floating(.updateShadow(shadow))))
            }
        )
    }
    
    // MARK: - Item Configuration

    /// Binding for the full regular `ItemConfiguration`.
    func regularItemConfig() -> Binding<ItemConfiguration> {
        Binding(
            get: {
                switch self.viewModel.state.tabBar.mode {
                case .floating: self.viewModel.floatingTabBarConfig.itemStyles[.regular] ?? .init()
                case .pinned: self.viewModel.pinnedTabBarConfig.itemStyles[.regular] ?? .init()
                }
            },
            set: { self.viewModel.send(.tabBar(.updateRegularItemConfig($0))) }
        )
    }

    /// Binding for a single property of the regular `ItemConfiguration`.
    func regularItemConfig<T>(_ keyPath: WritableKeyPath<ItemConfiguration, T>) -> Binding<T> {
        binding(
            get: {
                switch self.viewModel.state.tabBar.mode {
                case .floating: self.viewModel.floatingTabBarConfig.itemStyles[.regular] ?? .init()
                case .pinned: self.viewModel.pinnedTabBarConfig.itemStyles[.regular] ?? .init()
                }
            },
            keyPath: keyPath,
            send: { .tabBar(.updateRegularItemConfig($0)) }
        )
    }

    /// Binding for a single property of the prominent `ItemConfiguration`.
    func prominentItemConfig(_ keyPath: WritableKeyPath<ItemConfiguration, CGFloat>) -> Binding<CGFloat> {
        binding(
            get: { self.viewModel.pinnedTabBarConfig.itemStyles[.prominent] ?? .init() },
            keyPath: keyPath,
            send: { .tabBar(.pinned(.updateProminentItemConfig($0))) }
        )
    }
    
    /// Binding for the style of a single tab item (regular / prominent).
    func tabItemStyle(for item: ExampleTabItem) -> Binding<Bool> {
        Binding(
            get: { item.style == .prominent },
            set: {
                let style: BarItemStyle = $0 ? .prominent : .regular
                self.viewModel.send(.tabBar(.pinned(.updateTabItemStyle(item, style))))
            }
        )
    }
    
    // MARK: - Item Content Axis

    /// Binding for the item content layout axis arrangement based on the current mode.
    func itemContentAxis() -> Binding<ItemContentAxis?> {
        Binding(
            get: {
                switch self.viewModel.state.tabBar.mode {
                case .floating: self.viewModel.floatingTabBarConfig.itemContentAxis
                case .pinned:   self.viewModel.pinnedTabBarConfig.itemContentAxis
                }
            },
            set: { self.viewModel.send(.tabBar(.updateItemContentAxis($0))) }
        )
    }
    
    // MARK: - Haptic Feedback

    /// Binding for the haptic feedback enabled toggle.
    func hapticFeedbackEnabled() -> Binding<Bool> {
        Binding(
            get: {
                switch self.viewModel.state.tabBar.mode {
                case .floating: self.viewModel.floatingTabBarConfig.hapticFeedback != nil
                case .pinned:   self.viewModel.pinnedTabBarConfig.hapticFeedback != nil
                }
            },
            set: { self.viewModel.send(.tabBar(.updateHapticFeedbackEnabled($0))) }
        )
    }

    /// Binding for the haptic feedback style picker.
    func hapticFeedback() -> Binding<HapticFeedbackConfiguration> {
        Binding(
            get: {
                switch self.viewModel.state.tabBar.mode {
                case .floating: self.viewModel.floatingTabBarConfig.hapticFeedback ?? .selection
                case .pinned:   self.viewModel.pinnedTabBarConfig.hapticFeedback ?? .selection
                }
            },
            set: { self.viewModel.send(.tabBar(.updateHapticFeedback($0))) }
        )
    }
}
