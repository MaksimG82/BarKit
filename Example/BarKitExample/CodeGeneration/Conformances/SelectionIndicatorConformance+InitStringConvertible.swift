//
//  SelectionIndicatorConformance+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//

import BarKit
import SwiftUI

extension SelectionIndicatorConfiguration: InitStringConvertible, DefaultRepresentable {

    /// Default instance used as a baseline for diff.
    static var `default` = SelectionIndicatorConfiguration()

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// SelectionIndicatorConfiguration(
    ///     color: Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.2),
    ///     border: .init(color: Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.3), lineWidth: 1),
    ///     inset: .init(top: 2, leading: 2, bottom: 2, trailing: 2),
    ///     cornerRadius: 24,
    ///     transitionAnimation: .spring(duration: 0.5, bounce: 0.0),
    ///     scaleEffect: .init(xScale: 1.2, yScale: 1.2, duration: 0.2),
    ///     isDragGestureEnabled: false,
    ///     effects: [.lensDistortion(.init()), .chromaticAberration(.init(zoneWidth: 6.0))]
    /// )
    /// ```
    var initString: String {
        var params: [String] = []

        if color.initString != Self.default.color.initString {
            params.append("color: \(color.initString)")
        }
        if let border {
            params.append("border: \(border.initString)")
        }
        if inset.top != Self.default.inset.top ||
           inset.bottom != Self.default.inset.bottom ||
           inset.leading != Self.default.inset.leading ||
           inset.trailing != Self.default.inset.trailing {
            params.append("inset: .init(top: \(inset.top), leading: \(inset.leading), bottom: \(inset.bottom), trailing: \(inset.trailing))")
        }
        if cornerRadius != Self.default.cornerRadius {
            params.append("cornerRadius: \(cornerRadius)")
        }
        if let transitionAnimation, case let .parameters(animParams) = transitionAnimation {
            params.append("transitionAnimation: \(animParams.initString)")
        }
        if let scaleEffect {
            params.append("scaleEffect: \(scaleEffect.initString)")
        }
        if isDragGestureEnabled != Self.default.isDragGestureEnabled {
            params.append("isDragGestureEnabled: \(isDragGestureEnabled)")
        }
        if !effects.isEmpty {
            let effectsString = effects.map(\.initString).joined(separator: ", ")
            params.append("effects: [\(effectsString)]")
        }

        return params.isEmpty
            ? ".init()"
            : ".init(\(params.joined(separator: ", ")))"
    }
}
