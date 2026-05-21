//
//  AnimationParameters.swift
//  BarKit
//
//  Created by Maksim Gaisin on 14.04.26.
//

import SwiftUI

/// Defines the timing curve and duration of an animation.
/// Used as a serializable alternative to `SwiftUI.Animation`.
public struct AnimationParameters: Equatable {

    // MARK: - Nested Types

    /// Supported animation timing curves.
    public enum AnimationType: String, CaseIterable {
        case none     = "None"
        case easeIn   = "Ease In"
        case easeOut  = "Ease Out"
        case easeInOut = "Ease In Out"
        case spring   = "Spring"
        case bouncy   = "Bouncy"
        case snappy   = "Snappy"
        case smooth   = "Smooth"
        case linear   = "Linear"
    }

    // MARK: - Properties

    /// The timing curve of the animation.
    public var type: AnimationType

    /// The duration of the animation in seconds.
    public var duration: Double

    /// The bounce or extra bounce factor. Used by spring-based types.
    public var bounce: Double

    // MARK: - Init

    /// Creates a new `AnimationParameters` instance.
    /// - Parameters:
    ///   - type: The timing curve of the animation.
    ///   - duration: The duration in seconds.
    ///   - bounce: The bounce factor for spring-based animations.
    public init(
        type: AnimationType = .spring,
        duration: Double = 0.5,
        bounce: Double = 0.0
    ) {
        self.type = type
        self.duration = duration
        self.bounce = bounce
    }

    // MARK: - Methods

    /// Converts current parameters into a SwiftUI `Animation`.
    /// Returns `nil` when `type` is `.none`.
    public func makeAnimation() -> Animation? {
        switch type {
        case .none:      return nil
        case .linear:    return .linear(duration: duration)
        case .easeIn:    return .easeIn(duration: duration)
        case .easeOut:   return .easeOut(duration: duration)
        case .easeInOut: return .easeInOut(duration: duration)
        case .spring:    return .spring(duration: duration, bounce: bounce)
        case .bouncy:    return .bouncy(duration: duration, extraBounce: bounce)
        case .snappy:    return .snappy(duration: duration, extraBounce: bounce)
        case .smooth:    return .smooth(duration: duration, extraBounce: bounce)
        }
    }
}
