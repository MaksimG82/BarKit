//
//  View+indicatorLens.swift
//  BarKit
//
//  Created by Maksim Gaisin on 13.05.26.
//

import SwiftUI

extension View {
    /// Applies lens effect if indicator configuration is provided.
    @ViewBuilder
    func indicatorLens(_ config: SelectionIndicatorConfiguration?, frame: CGRect) -> some View {
        if let config, !config.effects.isEmpty {
            indicatorLensEffect(
                frame: frame,
                cornerRadius: config.cornerRadius,
                refractionZoneWidth: config.effects.contains(.lensDistortion) ? config.refractionZoneWidth : 0,
                aberrationZoneWidth: config.effects.contains(.chromaticAberration) ? config.aberrationZoneWidth : 0,
                aberrationStrength: config.effects.contains(.chromaticAberration) ? config.aberrationStrength : 0,
                refractionStrength: config.effects.contains(.lensDistortion) ? config.refractionStrength : 0
            )
        } else {
            self
        }
    }
}
