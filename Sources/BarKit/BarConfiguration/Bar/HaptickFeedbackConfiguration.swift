//
//  Untitled.swift
//  BarKit
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

/// Defines the haptic feedback style triggered when the selected bar item changes.
/// Requires iOS 17 or later; has no effect on earlier versions.
public enum HapticFeedback {

    /// A feedback style that indicates a change in selection.
    case selection

    /// A feedback style that simulates a physical impact.
    case impact

    /// A feedback style that indicates a successful action.
    case success

    /// A feedback style that indicates a warning.
    case warning

    /// A feedback style that indicates an error.
    case error

    /// Maps to the corresponding `SensoryFeedback` value.
    @available(iOS 17.0, *)
    var sensoryFeedback: SensoryFeedback {
        switch self {
        case .selection: .selection
        case .impact:    .impact
        case .success:   .success
        case .warning:   .warning
        case .error:     .error
        }
    }
}
