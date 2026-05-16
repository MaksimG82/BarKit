//
//  AnimationParameters.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 14.04.26.
//

import BarKit
import SwiftUI

import SwiftUI

/// Configuration model that defines how animations and scale effects are applied to tab bar elements.
struct AnimationParameters: Equatable {
    
    // MARK: - Nested Types
    
    /// Supported animation timing curves and spring behaviors.
    enum AnimationType: String, CaseIterable {
        case none = "None"
        case easeIn = "Ease In"
        case easeOut = "Ease Out"
        case easeInOut = "Ease In Out"
        case spring = "Spring"
        case bouncy = "Bouncy"
        case snappy = "Snappy"
        case smooth = "Smooth"
        case linear = "Linear"
    }
    
    /// Parameters specifically for the indicator's stretching/scaling effect.
    struct ScaleSettings: Equatable {
        var xScale: CGFloat = 1.2
        var yScale: CGFloat = 1.2
        var resetDuration: Double = 0.2
    }
    
    // MARK: - Properties
    
    var type: AnimationType = .spring
    var duration: Double = 0.5
    var bounce: Double = 0.0
    var scaleSettings: ScaleSettings?
    
    // MARK: - Methods
    
    /// Converts current parameters into a SwiftUI Animation object.
    func makeAnimation() -> Animation? {
        switch type {
        case .none: return nil
        case .linear: return .linear(duration: duration)
        case .easeIn: return .easeIn(duration: duration)
        case .easeOut: return .easeOut(duration: duration)
        case .easeInOut: return .easeInOut(duration: duration)
        case .spring: return .spring(duration: duration, bounce: bounce)
        case .bouncy: return .bouncy(duration: duration, extraBounce: bounce)
        case .snappy: return .snappy(duration: duration, extraBounce: bounce)
        case .smooth: return .smooth(duration: duration, extraBounce: bounce)
        }
    }
}
