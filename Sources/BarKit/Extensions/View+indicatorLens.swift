//
//  View+indicatorLens.swift
//  BarKit
//
//  Created by Maksim Gaisin on 13.05.26.
//

import SwiftUI

extension View {
    /// Applies lens effect if indicator configuration is provided and the indicator is in motion.
    @ViewBuilder
    func indicatorLens(_ configuration: SelectionIndicatorConfiguration?, frame: CGRect, isActive: Bool) -> some View {
        if let configuration, isActive, !configuration.effects.isEmpty {
            indicatorLensEffect(
                frame: frame,
                cornerRadius: configuration.cornerRadius,
                aberrationZoneWidth: configuration.effects.aberrationZoneWidth,
                refractionZoneWidth: configuration.effects.refractionZoneWidth,
                aberrationStrength: configuration.effects.aberrationStrength,
                refractionStrength: configuration.effects.refractionStrength
            )
        } else {
            self
        }
    }
}

// MARK: - [IndicatorEffect] Helpers

private extension [IndicatorEffect] {

    /// Extracts `zoneWidth` from `.lensDistortion`, or returns `0` if the effect is absent.
    var refractionZoneWidth: CGFloat {
        lensDistortion?.zoneWidth ?? 0
    }

    /// Extracts `strength` from `.lensDistortion`, or returns `0` if the effect is absent.
    var refractionStrength: CGFloat {
        lensDistortion?.strength ?? 0
    }

    /// Extracts `zoneWidth` from `.chromaticAberration`, or returns `0` if the effect is absent.
    var aberrationZoneWidth: CGFloat {
        chromaticAberration?.zoneWidth ?? 0
    }

    /// Extracts `strength` from `.chromaticAberration`, or returns `0` if the effect is absent.
    var aberrationStrength: CGFloat {
        chromaticAberration?.strength ?? 0
    }

    // MARK: - Private

    private var lensDistortion: LensDistortionConfiguration? {
        for effect in self {
            if case .lensDistortion(let configuration) = effect { return configuration }
        }
        return nil
    }

    private var chromaticAberration: ChromaticAberrationConfiguration? {
        for effect in self {
            if case .chromaticAberration(let configuration) = effect { return configuration }
        }
        return nil
    }
}
