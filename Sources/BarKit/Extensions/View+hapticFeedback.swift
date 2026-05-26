//
//  View+hapticFeedback.swift
//  BarKit
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

extension View {

    /// Applies sensory feedback on selection change if the platform supports it (iOS 17+).
    ///
    /// - Parameters:
    ///   - feedback: The haptic feedback style to trigger. Pass `nil` to disable.
    ///   - trigger: The value whose change triggers the feedback.
    @ViewBuilder
    func hapticFeedback<T: Equatable>(
        _ feedback: HapticFeedbackConfiguration?,
        trigger: T
    ) -> some View {
        if #available(iOS 17.0, *), let feedback {
            self.sensoryFeedback(feedback.sensoryFeedback, trigger: trigger)
        } else {
            self
        }
    }
}
