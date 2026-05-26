//
//  ChromaticAberrationConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 23.05.26.
//

import SwiftUI

/// Parameters for the chromatic aberration effect at the indicator boundary.
public struct ChromaticAberrationConfiguration: Sendable {

    /// Width of the aberration zone. Typical range 1.0–6.0.
    public var zoneWidth: CGFloat

    /// RGB channel separation in pixels. Typical range 1.0–4.0.
    public var strength: CGFloat

    /// Creates a chromatic aberration configuration.
    ///
    /// - Parameters:
    ///   - zoneWidth: Width of the aberration zone at the indicator boundary. Typical range 1.0–6.0.
    ///   - strength: RGB channel separation in pixels. Typical range 1.0–4.0.
    public init(
        zoneWidth: CGFloat = 8.0,
        strength: CGFloat = 4.0
    ) {
        self.zoneWidth = zoneWidth
        self.strength = strength
    }
}
