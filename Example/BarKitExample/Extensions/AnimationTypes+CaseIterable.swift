//
//  AnimationTypes+CaseIterable.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 23.05.26.
//

import BarKit

extension AnimationParameters.AnimationType: @retroactive CaseIterable {
    public static var allCases: [AnimationParameters.AnimationType] {
        [.none, .easeIn, .easeOut, .easeInOut, .spring, .bouncy, .snappy, .smooth, .linear]
    }

    /// Display name for use in the settings UI.
    var displayName: String {
        switch self {
        case .none:         return "None"
        case .easeIn:       return "Ease In"
        case .easeOut:      return "Ease Out"
        case .easeInOut:    return "Ease In Out"
        case .spring:       return "Spring"
        case .bouncy:       return "Bouncy"
        case .snappy:       return "Snappy"
        case .smooth:       return "Smooth"
        case .linear:       return "Linear"
        }
    }
}
