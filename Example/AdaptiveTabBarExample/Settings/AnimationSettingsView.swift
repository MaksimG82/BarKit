//
//  AnimationSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.03.26.
//

import SwiftUI

struct AnimationSettingsView: View {
    var viewModel: ExampleViewModel

    enum AnimationType: String, CaseIterable {
        case none = "None"
        case spring = "Spring"
        case easeInOut = "Ease In Out"
    }

    @State private var type: AnimationType = .spring
    @State private var duration: Double = 0.3
    @State private var bounce: Double = 0.3

    var body: some View {
        List {
            Section {
                Picker("Type", selection: $type) {
                    ForEach(AnimationType.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.segmented)
            }

            if type != .none {
                Section("Settings") {
                    VStack(alignment: .leading) {
                        Text("Duration: \(String(format: "%.2f", duration))s")
                        Slider(value: $duration, in: 0.1 ... 1.0)
                    }

                    if type == .spring {
                        VStack(alignment: .leading) {
                            Text("Bounciness: \(Int(bounce * 100))%")
                            Slider(value: $bounce, in: 0 ... 0.8)
                        }
                    }
                }
            }

            Section {
                Text("SwiftUI animations offer vast possibilities. This demo showcases only a fraction of those capabilities.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Animation")
        .onChange(of: type) { update() }
        .onChange(of: duration) { update() }
        .onChange(of: bounce) { update() }
    }

    private func update() {
        let animation: Animation? = switch type {
        case .none: nil
        case .spring: .spring(duration: duration, bounce: bounce)
        case .easeInOut: .easeInOut(duration: duration)
        }
        viewModel.send(.updateAnimation(animation))
    }
}
