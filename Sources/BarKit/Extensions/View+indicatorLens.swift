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
        if let config {
            indicatorLensEffect(
                frame: frame,
                cornerRadius: config.cornerRadius,
                refractionZoneWidth: config.refractionZoneWidth,
                aberrationZoneWidth: config.aberrationZoneWidth,
                aberrationStrength: config.aberrationStrength,
                refractionStrength: config.refractionStrength
            )
        } else {
            self
        }
    }
}
