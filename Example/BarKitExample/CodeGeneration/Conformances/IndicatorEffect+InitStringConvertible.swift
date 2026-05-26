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
        case .lensDistortion(let configuration):
            return ".lensDistortion(\(configuration.initString))"
        case .chromaticAberration(let configuration):
            return ".chromaticAberration(\(configuration.initString))"
        }
    }
}


