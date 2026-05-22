//
//  IndicatorEffect+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//


import BarKit

extension IndicatorEffect: InitStringConvertible {

    /// A Swift source string representing this option set as an initializer.
    var initString: String {
        if self == [] { return "[]" }
        if self == .all { return ".all" }

        var parts: [String] = []
        if contains(.lensDistortion)    { parts.append(".lensDistortion") }
        if contains(.chromaticAberration) { parts.append(".chromaticAberration") }
        return "[\(parts.joined(separator: ", "))]"
    }
}