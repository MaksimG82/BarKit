//
//  IndicatorEffect.swift
//  BarKit
//
//  Created by Maksim Gaisin on 02.05.26.
//

// MARK: - IndicatorEffect

/// A set of visual effects that can be applied at the indicator boundary.
public struct IndicatorEffect: OptionSet, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    /// Lens distortion effect at the indicator boundary.
    public static let lensDistortion = IndicatorEffect(rawValue: 1 << 0)

    /// Chromatic aberration (RGB channel separation) at the indicator boundary.
    public static let chromaticAberration = IndicatorEffect(rawValue: 1 << 1)

    /// Both lens distortion and chromatic aberration combined.
    public static let all: IndicatorEffect = [.lensDistortion, .chromaticAberration]
}
