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
    case material(BarMaterial, tint: Color = .clear)
    /// A custom shader-based blur with an optional tint color layered on top.
    case customBlur(CustomBlurConfiguration, tint: Color = .clear)
}
