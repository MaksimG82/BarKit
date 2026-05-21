//
//  ShadowConfiguration+InitStringConvertible.swift
//  BarKit
//
//  Created by Maksim Gaisin on 21.05.26.
//



import BarKit
import SwiftUI

extension ShadowConfiguration: InitStringConvertible, DefaultRepresentable {
    
    /// Default instance used as a baseline for diff.
    static var `default` = ShadowConfiguration()
    
    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// ShadowConfiguration(
    ///     color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.2),
    ///     radius: 8,
    ///     x: 0,
    ///     y: 0
    /// )
    /// ```
    var initString: String {
        var params: [String] = []
        
        if color.initString != Self.default.color.initString {
            params.append("color: \(color.initString)")
        }
        if radius != Self.default.radius {
            params.append("radius: \(radius)")
        }
        if x != Self.default.x {
            params.append("x: \(x)")
        }
        if y != Self.default.y {
            params.append("y: \(y)")
        }
        
        return params.isEmpty
            ? ".init()"
            : ".init(\(params.joined(separator: ", ")))"
    }
}
