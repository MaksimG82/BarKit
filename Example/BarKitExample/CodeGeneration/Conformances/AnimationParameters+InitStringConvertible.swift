//
//  AnimationParameters+InitStringConvertible.swift
//  BarKit
//
//  Created by Maksim Gaisin on 21.05.26.
//


import SwiftUI
import BarKit

extension AnimationParameters: InitStringConvertible, DefaultRepresentable {
    
    /// Default instance used as a baseline for diff.
    static var `default` = AnimationParameters()
    
    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// .spring(duration: 0.5, bounce: 0.0)
    /// ```
    var initString: String {
        switch type {
        case .none:      return "nil"
        case .linear:    return ".linear(duration: \(duration))"
        case .easeIn:    return ".easeIn(duration: \(duration))"
        case .easeOut:   return ".easeOut(duration: \(duration))"
        case .easeInOut: return ".easeInOut(duration: \(duration))"
        case .spring:    return ".spring(duration: \(duration), bounce: \(bounce))"
        case .bouncy:    return ".bouncy(duration: \(duration), extraBounce: \(bounce))"
        case .snappy:    return ".snappy(duration: \(duration), extraBounce: \(bounce))"
        case .smooth:    return ".smooth(duration: \(duration), extraBounce: \(bounce))"
        }
    }
}
