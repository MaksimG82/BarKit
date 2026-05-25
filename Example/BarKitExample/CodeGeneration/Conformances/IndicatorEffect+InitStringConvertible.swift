//
//  IndicatorEffect+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//


import BarKit

extension IndicatorEffect: InitStringConvertible {

    /// A Swift source string representing this effect as an initializer.
    var initString: String {
        switch self {
        case .lensDistortion(let config):
            return ".lensDistortion(\(config.initString))"
        case .chromaticAberration(let config):
            return ".chromaticAberration(\(config.initString))"
        }
    }
}


