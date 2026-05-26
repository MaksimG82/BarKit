//
//  BarConfiguration+ItmStringConverible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//

import SwiftUI
import BarKit

extension BarConfiguration: InitStringConvertible, DefaultRepresentable {
    
    /// Default instance used as a baseline for diff.
    public static var `default` = BarConfiguration()

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// BarConfiguration(
    ///     axis: .horizontal,
    ///     cornerRadius: 28,
    ///     shadow: .init(color: .black.opacity(0.15), radius: 10, x: 0, y: 4),
    ///     background: .material(.ultraThin),
    ///     itemStyles: [.regular: .init()],
    ///     itemContentAxis: .vertical,
    ///     itemContentAlignment: .center,
    ///     itemAlignment: .center,
    ///     itemSpacing: 0,
    ///     itemStateAnimation: .parameters(.init(type: .easeInOut, duration: 0.2)),
    ///     baselineStyle: .regular,
    ///     indicator: .init(),
    ///     barAccessibilityLabel: "Tab Bar",
    ///     hapticFeedback: .selection,
    ///     accessibilitySortPriority: 0
    /// )
    /// ```
    public var initString: String {
        var params: [String] = []

        if axis != Self.default.axis {
            params.append("axis: .\(axis)")
        }
        if cornerRadius != Self.default.cornerRadius {
            params.append("cornerRadius: \(cornerRadius)")
        }
        if shadow?.initString != Self.default.shadow?.initString {
            params.append("shadow: \(shadow?.initString ?? "nil")")
        }
        if background.initString != Self.default.background.initString {
            params.append("background: \(background.initString)")
        }
        if itemStyles.initString != Self.default.itemStyles.initString {
            params.append("itemStyles: \(itemStyles.initString)")
        }
        if itemContentAxis != Self.default.itemContentAxis {
            params.append("itemContentAxis: \(itemContentAxis.map { ".\($0)" } ?? "nil")")
        }
        if itemContentAlignment != Self.default.itemContentAlignment {
            params.append("itemContentAlignment: .\(itemContentAlignment)")
        }
        if itemAlignment != Self.default.itemAlignment {
            params.append("itemAlignment: .\(itemAlignment)")
        }
        if itemSpacing != Self.default.itemSpacing {
            params.append("itemSpacing: \(itemSpacing)")
        }
        if itemStateAnimation?.initString != Self.default.itemStateAnimation?.initString {
            params.append("itemStateAnimation: \(itemStateAnimation?.initString ?? "nil")")
        }
        if baselineStyle != Self.default.baselineStyle {
            params.append("baselineStyle: \(baselineStyle.map { $0.initString } ?? "nil")")
        }
        if indicator?.initString != Self.default.indicator?.initString {
            params.append("indicator: \(indicator?.initString ?? "nil")")
        }
        if barAccessibilityLabel != Self.default.barAccessibilityLabel {
            params.append("barAccessibilityLabel: \"\(barAccessibilityLabel)\"")
        }
        if hapticFeedback != Self.default.hapticFeedback {
            params.append("hapticFeedback: \(hapticFeedback.map { ".\($0)" } ?? "nil")")
        }
        if accessibilitySortPriority != Self.default.accessibilitySortPriority {
            params.append("accessibilitySortPriority: \(accessibilitySortPriority)")
        }

        return params.isEmpty
            ? ".init()"
            : ".init(\(params.joined(separator: ", ")))"
    }
}
