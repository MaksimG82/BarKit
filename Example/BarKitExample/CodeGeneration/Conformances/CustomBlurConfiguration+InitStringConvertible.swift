//
//  CustomBlurConfiguration+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//

import BarKit

extension CustomBlurConfiguration: InitStringConvertible, DefaultRepresentable {
    
    /// Default instance used as a baseline for diff.
    public static var `default` = CustomBlurConfiguration()

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// CustomBlurConfiguration(intensity: 0.8)
    /// ```
    public var initString: String {
        var params: [String] = []

        if intensity != Self.default.intensity {
            params.append("intensity: \(intensity)")
        }

        return params.isEmpty
            ? ".init()"
            : ".init(\(params.joined(separator: ", ")))"
    }
}
