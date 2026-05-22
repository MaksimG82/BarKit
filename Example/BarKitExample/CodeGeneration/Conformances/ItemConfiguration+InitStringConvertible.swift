//
//  ItemConfiguration+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//



import BarKit
import SwiftUI

extension ItemConfiguration: InitStringConvertible, DefaultRepresentable {

    /// Default instance used as a baseline for diff.
    static var `default` = ItemConfiguration()

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// ItemConfiguration(
    ///     selectedColor: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0),
    ///     unselectedColor: Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 1.0),
    ///     textStyle: .caption2,
    ///     iconSideLength: 24,
    ///     selectedIconScale: 1.1,
    ///     compactIconScale: 0.8,
    ///     iconTitleSpacing: 4,
    ///     edgeInsets: .init(top: 8, leading: 8, bottom: 8, trailing: 8),
    ///     edgeInsetsCompact: .init(top: 4, leading: 4, bottom: 4, trailing: 4)
    /// )
    /// ```
    var initString: String {
        var params: [String] = []

        if selectedColor.initString != Self.default.selectedColor.initString {
            params.append("selectedColor: \(selectedColor.initString)")
        }
        if unselectedColor.initString != Self.default.unselectedColor.initString {
            params.append("unselectedColor: \(unselectedColor.initString)")
        }
        if textStyle != Self.default.textStyle {
            params.append("textStyle: \(textStyle.initString)")
        }
        if iconSideLength != Self.default.iconSideLength {
            params.append("iconSideLength: \(iconSideLength)")
        }
        if selectedIconScale != Self.default.selectedIconScale {
            params.append("selectedIconScale: \(selectedIconScale)")
        }
        if compactIconScale != Self.default.compactIconScale {
            params.append("compactIconScale: \(compactIconScale)")
        }
        if iconTitleSpacing != Self.default.iconTitleSpacing {
            params.append("iconTitleSpacing: \(iconTitleSpacing)")
        }
        if edgeInsets.top != Self.default.edgeInsets.top ||
           edgeInsets.bottom != Self.default.edgeInsets.bottom ||
           edgeInsets.leading != Self.default.edgeInsets.leading ||
           edgeInsets.trailing != Self.default.edgeInsets.trailing {
            params.append("edgeInsets: .init(top: \(edgeInsets.top), leading: \(edgeInsets.leading), bottom: \(edgeInsets.bottom), trailing: \(edgeInsets.trailing))")
        }
        if edgeInsetsCompact.top != Self.default.edgeInsetsCompact.top ||
           edgeInsetsCompact.bottom != Self.default.edgeInsetsCompact.bottom ||
           edgeInsetsCompact.leading != Self.default.edgeInsetsCompact.leading ||
           edgeInsetsCompact.trailing != Self.default.edgeInsetsCompact.trailing {
            params.append("edgeInsetsCompact: .init(top: \(edgeInsetsCompact.top), leading: \(edgeInsetsCompact.leading), bottom: \(edgeInsetsCompact.bottom), trailing: \(edgeInsetsCompact.trailing))")
        }

        return params.isEmpty
            ? ".init()"
            : ".init(\(params.joined(separator: ", ")))"
    }
}
