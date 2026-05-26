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
    /// - Parameters:
    ///   - animation: The SwiftUI animation to apply.
    ///   - duration: Optional duration hint used to deactivate lens effects after the animation completes.
    ///     Pass `nil` to keep lens effects active indefinitely when using a custom animation.
    /// - Note: `Animation` is not `Sendable`; use across concurrency boundaries with care.
    case custom(Animation, duration: Double? = nil)

    /// Converts to a SwiftUI `Animation` for use in view modifiers.
    public var animation: Animation? {
        switch self {
        case let .parameters(value):
            return value.resolved
        case let .custom(animation, _):
            return animation
        }
    }
    
    /// The duration of the animation in seconds.
    /// Returns `nil` for `.custom` animations without an explicit duration —
    /// in that case lens effects remain active for the transition's lifetime.
    public var duration: Double {
        switch self {
        case let .parameters(params):
            return params.duration
        case let .custom(_, duration):
            return duration ?? 0.3
        }
    }
}
