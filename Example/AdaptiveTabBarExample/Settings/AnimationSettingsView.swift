//
//  AnimationSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.03.26.
//

import AdaptiveTabBar
import SwiftUI

struct AnimationSettingsView: View {
    @Environment(\.tabBarHeight) var tabBarHeight

    var viewModel: ExampleViewModel

    // MARK: - Internal Types

    enum AnimationType: String, CaseIterable {
        case none = "None"
        case spring = "Spring"
        case easeInOut = "Ease In Out"
    }

    // MARK: - State

    @State private var type: AnimationType = .spring
    @State private var duration: TimeInterval = 0.3
    @State private var bounce: Double = 0.3

    // MARK: - Body

    var body: some View {
        List {
            pickerTypeSelectionSection

            if type != .none {
                settingsSection
            }

            footerSection
        }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: tabBarHeight) }
        .navigationTitle("Animation")
        .onChange(of: type) { update() }
    }
}

// MARK: - View Components

private extension AnimationSettingsView {
    var pickerTypeSelectionSection: some View {
        Section {
            Picker("Type", selection: $type) {
                ForEach(AnimationType.allCases, id: \.self) { Text($0.rawValue) }
            }
            .pickerStyle(.segmented)
        }
    }

    var settingsSection: some View {
        Section("Settings") {
            durationSlider

            if type == .spring {
                bounceSlider
            }
        }
    }

    var durationSlider: some View {
        VStack(alignment: .leading) {
            Text("Duration: \(String(format: "%.2f", duration))s")
            Slider(value: $duration, in: 0.1 ... 1.0) { _ in
                update()
            }
            .contentShape(Rectangle())
        }
    }

    var bounceSlider: some View {
        VStack(alignment: .leading) {
            Text("Bounciness: \(Int(bounce * 100))%")
            Slider(value: $bounce, in: 0 ... 0.9) { _ in
                update()
            }
            .contentShape(Rectangle())
        }
    }

    var footerSection: some View {
        Section {
            Text("SwiftUI animations offer vast possibilities.\nThis demo showcases only a fraction of those capabilities.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Actions

private extension AnimationSettingsView {
    func update() {
        let animation: Animation? = switch type {
        case .none: nil
        case .spring: .spring(duration: duration, bounce: bounce)
        case .easeInOut: .easeInOut(duration: duration)
        }
        viewModel.send(.updateAnimation(animation))
    }
}

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()
    NavigationStack {
        ZStack(alignment: .bottom) {
            AnimationSettingsView(viewModel: viewModel)

            TabBarView(
                items: viewModel.state.items,
                selected: .constant(viewModel.state.items[0]),
                config: viewModel.state.config
            )
            .overlay(Divider(), alignment: .top)
        }
    }
}
