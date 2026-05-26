//
//  IndicatorEffect.swift
//  BarKit
//
//  Created by Maksim Gaisin on 02.05.26.
//

/// A visual effect applied at the indicator boundary.
public enum IndicatorEffect: Sendable {

    /// Lens distortion at the indicator boundary.
    case lensDistortion(LensDistortionConfiguration = .init())

    /// Chromatic aberration (RGB channel separation) at the indicator boundary.
    case chromaticAberration(ChromaticAberrationConfiguration = .init())
}
