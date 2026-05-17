//
//  IndicatorShader.swift
//  BarKit
//
//  Created by Maksim Gaisin on 21.04.26.
//

//
//  IndicatorShader.swift
//  BarKit
//

import SwiftUI

/// Applies the Metal lens distortion and chromatic aberration shader
/// to a view using the selection indicator's current frame as the effect bounds.
extension View {

    /// Applies the indicator lens effect to the view if the platform supports it (iOS 17+).
    ///
    /// - Parameters:
    ///   - frame: The current frame of the selection indicator in the view's coordinate space.
    ///   - cornerRadius: The corner radius of the indicator shape.
    ///   - refractionZoneWidth: Width in points of the zone near the boundary where lens distortion is applied. Typical range 2.0–12.0.
    ///   - aberrationZoneWidth: Width in points of the zone near the boundary where chromatic aberration is applied. Typical range 1.0–6.0.
    ///   - refractionStrength: Maximum pixel displacement at the indicator boundary. Typical range 1.5–5.0.
    ///   - aberrationStrength: RGB channel separation in pixels at the indicator boundary. Typical range 1.0–4.0.
    @ViewBuilder
    func indicatorLensEffect(
        frame: CGRect,
        cornerRadius: CGFloat,
        refractionZoneWidth: CGFloat,
        aberrationZoneWidth: CGFloat,
        aberrationStrength: CGFloat,
        refractionStrength: CGFloat
    ) -> some View {
        if #available(iOS 17.0, *) {
            let library = ShaderLibrary.indicatorLibrary
            self.layerEffect(
                library.indicatorLensEffect(
                    .float2(frame.midX, frame.midY),
                    .float2(frame.width / 2, frame.height / 2),
                    .float(Float(cornerRadius)),
                    .float(Float(refractionZoneWidth)),
                    .float(Float(aberrationZoneWidth)),
                    .float(Float(refractionStrength)),
                    .float(Float(aberrationStrength))
                ),
                maxSampleOffset: CGSize(
                    width:  refractionStrength + aberrationStrength,
                    height:  refractionStrength + aberrationStrength
                )
            )
        } else {
            self
        }
    }
}
