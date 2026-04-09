//
//  FloatingSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 19.03.26.
//

import AdaptiveTabBar
import SwiftUI

struct FloatingSettingsView: View {
    @Environment(\.tabBarHeight) var tabBarHeight
    var viewModel: ExampleViewModel

    var body: some View {
        List {
            positionSection
            appearanceSection
        }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: tabBarHeight) }
        .navigationTitle("Floating Style")
    }
}

// MARK: - View Components

private extension FloatingSettingsView {
    var positionSection: some View {
        Section {
            slider(title: "Leading Inset", value: leadingBinding, range: 0 ... 40)
            slider(title: "Trailing Inset", value: trailingBinding, range: 0 ... 40)
            slider(title: "Bottom Inset", value: bottomBinding, range: 0 ... 60)
        } header: {
            Text("Positioning")
        } footer: {
            Text("Distance from screen edges and safe area.")
        }
    }

    var appearanceSection: some View {
        Section("Appearance") {
            slider(title: "Corner Radius", value: cornerRadiusBinding, range: 0 ... 40)
            slider(title: "Shadow Radius", value: shadowRadiusBinding, range: 0 ... 20)
        }
    }

    func slider(title: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        VStack(alignment: .leading) {
            Text("\(title): \(Int(value.wrappedValue))")
                .font(.subheadline)
            Slider(value: value, in: range, step: 1)
        }
    }
}

// MARK: - Bindings

private extension FloatingSettingsView {
    var config: FloatingConfiguration {
        viewModel.state.config.floatingConfig ?? .init()
    }

    var leadingBinding: Binding<CGFloat> {
        Binding(get: { config.leadingInset }, set: { viewModel.send(.updateFloatingLayout(.leadingInset($0))) })
    }

    var trailingBinding: Binding<CGFloat> {
        Binding(get: { config.trailingInset }, set: { viewModel.send(.updateFloatingLayout(.trailingInset($0))) })
    }

    var bottomBinding: Binding<CGFloat> {
        Binding(get: { config.bottomInset }, set: { viewModel.send(.updateFloatingLayout(.bottomInset($0))) })
    }

    var cornerRadiusBinding: Binding<CGFloat> {
        Binding(get: { config.cornerRadius }, set: { viewModel.send(.updateFloatingLayout(.cornerRadius($0))) })
    }

    var shadowRadiusBinding: Binding<CGFloat> {
        Binding(get: { config.shadowRadius }, set: { viewModel.send(.updateFloatingLayout(.shadowRadius($0))) })
    }
}
