//
//  LensDistortionConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 23.05.26.
//

import SwiftUI

/// Parameters for the lens distortion effect at the indicator boundary.
public struct LensDistortionConfiguration: Sendable {

    /// Width of the distortion zone. Typical range 2.0–12.0.
    public var zoneWidth: CGFloat

    /// Maximum pixel displacement. Typical range 1.5–5.0.
    public var strength: CGFloat

    /// Creates a lens distortion configuration.
    ///
    /// - Parameters:
    ///   - zoneWidth: Width of the distortion zone at the indicator boundary. Typical range 2.0–12.0.
    ///   - strength: Maximum pixel displacement at the indicator boundary. Typical range 1.5–5.0.
    public init(
        zoneWidth: CGFloat = 12.0,
        strength: CGFloat = 2.0
    ) {
        self.zoneWidth = zoneWidth
        self.strength = strength
    }
}
