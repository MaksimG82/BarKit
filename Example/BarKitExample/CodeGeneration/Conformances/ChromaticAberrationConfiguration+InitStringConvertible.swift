//
//  ChromaticAberrationConfiguration+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 23.05.26.
//

import BarKit

extension ChromaticAberrationConfiguration: InitStringConvertible, DefaultRepresentable {

    /// Default instance used as a baseline for diff.
    static var `default` = ChromaticAberrationConfiguration()

    /// A Swift source string representing this configuration as an initializer.
    /// Only parameters differing from `Self.default` are included.
    var initString: String {
        var params: [String] = []

        if zoneWidth != Self.default.zoneWidth { params.append("zoneWidth: \(zoneWidth)") }
        if strength  != Self.default.strength  { params.append("strength: \(strength)") }

        return params.isEmpty
            ? ".init()"
            : ".init(\(params.joined(separator: ", ")))"
    }
}
