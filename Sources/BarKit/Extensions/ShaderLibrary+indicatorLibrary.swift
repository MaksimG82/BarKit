//
//  ShaderLibrary+indicatorLibrary.swift
//  BarKit
//
//  Created by Maksim Gaisin on 17.05.26.
//

import SwiftUI

@available(iOS 17.0, *)
extension ShaderLibrary {
    /// The precompiled Metal shader library for the indicator lens effect,
    /// selected based on the current runtime environment.
    static let indicatorLibrary: ShaderLibrary = {
#if targetEnvironment(simulator)
        let name = "IndicatorEffects-iphonesimulator"
#else
        let name = "IndicatorEffects-iphoneos"
#endif
        guard
            let url = Bundle.module.url(
                forResource: name,
                withExtension: "metallib")
        else {
            fatalError("BarKit: missing Metal library '\(name).metallib' in bundle.")
        }
        return ShaderLibrary(url: url)
    }()
}
