//
//  BarBackground.swift
//  BarKit
//
//  Created by Maksim Gaisin on 29.04.26.
//

import SwiftUI

/// Defines the background appearance of the bar.
public enum BarBackground {
    /// A solid color fill with no blur.
    case color(Color)
    /// A system material blur with an optional tint color layered on top.
    case material(Material, tint: Color = .clear)
    /// A custom shader-based blur with an optional tint color layered on top.
    case customBlur(CustomBlurConfiguration, tint: Color = .clear)
}
//
//// MARK: - Helpers
//
//public extension BarBackground {
//    /// The tint color applied on top of the blur effect, if any.
//    var tintColor: Color? {
//        switch self {
//        case .material(_, let tint): return tint
//        case .customBlur(_, let tint): return tint
//        default: return nil
//        }
//    }
//
//    /// Returns true if the background includes any blur effect.
//    var hasBlur: Bool {
//        switch self {
//        case .material, .customBlur: return true
//        default: return false
//        }
//    }
//}
