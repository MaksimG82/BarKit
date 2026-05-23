//
//  HapticFeedbackSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI
import BarKit

/// A reusable settings section for configuring haptic feedback.
struct HapticFeedbackSection: View {

    /// Binding for the haptic feedback enabled toggle.
    @Binding var isEnabled: Bool

    /// Binding for the haptic feedback style picker.
    @Binding var hapticFeedback: HapticFeedbackConfiguration

    var body: some View {
        Section {
            Toggle("Haptic Feedback", isOn: $isEnabled)
            if isEnabled {
                Picker("Style", selection: $hapticFeedback) {
                    Text("Selection").tag(HapticFeedbackConfiguration.selection)
                    Text("Impact").tag(HapticFeedbackConfiguration.impact)
                    Text("Success").tag(HapticFeedbackConfiguration.success)
                    Text("Warning").tag(HapticFeedbackConfiguration.warning)
                    Text("Error").tag(HapticFeedbackConfiguration.error)
                }
            }
        } header: {
            Text("Haptic Feedback")
        } footer: {
            Text("Requires iOS 17 or later.")
        }
    }
}
