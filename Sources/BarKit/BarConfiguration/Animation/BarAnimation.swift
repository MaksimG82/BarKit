//
//  BarAnimation.swift
//  BarKit
//
//  Created by Maksim Gaisin on 21.05.26.
//

import SwiftUI

/// Defines the animation used for bar transitions.
/// Provides a serializable path via ``AnimationParameters``
/// and an escape hatch for arbitrary SwiftUI animations.
public enum BarAnimation {

    /// A named, parameterized animation — serializable and code-generatable.
    case parameters(AnimationParameters)

    /// An arbitrary SwiftUI animation — flexible but not serializable.
    case custom(Animation)

    // MARK: - Helpers

    /// Converts to a SwiftUI `Animation` for use in view modifiers.
    public var animation: Animation? {
        switch self {
        case let .parameters(value):
            return value.resolved
        case let .custom(animation):
            return animation
        }
    }
}
