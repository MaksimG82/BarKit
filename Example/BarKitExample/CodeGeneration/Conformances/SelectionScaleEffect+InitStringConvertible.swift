//
//  SelectionScaleEffect+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//


import BarKit
import SwiftUI

extension SelectionScaleEffect: InitStringConvertible, DefaultRepresentable {

    /// Default instance used as a baseline for diff.
    static var `default` = SelectionScaleEffect()

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// SelectionScaleEffect(
    ///     scalingAnimation: .easeInOut(duration: 0.15),
    ///     xScale: 1.2,
    ///     yScale: 1.2,
    ///     duration: 0.2
    /// )
    /// ```
    var initString: String {
        var params: [String] = []

        if let scalingAnimation, case let .parameters(animParams) = scalingAnimation,
           animParams != AnimationParameters(type: .easeInOut, duration: 0.15) {
            params.append("scalingAnimation: \(animParams.initString)")
        }
        if xScale != Self.default.xScale {
            params.append("xScale: \(xScale)")
        }
        if yScale != Self.default.yScale {
            params.append("yScale: \(yScale)")
        }
        if duration != Self.default.duration {
            params.append("duration: \(duration)")
        }

        return params.isEmpty
            ? ".init()"
            : ".init(\(params.joined(separator: ", ")))"
    }
}
