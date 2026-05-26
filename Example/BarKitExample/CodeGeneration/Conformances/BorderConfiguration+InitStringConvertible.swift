//
//  BorderConfiguration+InitStringConvertible.swift
//  BarKit
//
//  Created by Maksim Gaisin on 21.05.26.
//



import BarKit
import SwiftUI

extension BorderConfiguration: InitStringConvertible, DefaultRepresentable {
    
    /// Default instance used as a baseline for diff.
    static var `default` = BorderConfiguration()
    
    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// BorderConfiguration(
    ///     color: Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.3),
    ///     lineWidth: 1
    /// )
    /// ```
    var initString: String {
        var params: [String] = []
        
        if color.initString != Self.default.color.initString {
            params.append("color: \(color.initString)")
        }
        if lineWidth != Self.default.lineWidth {
            params.append("lineWidth: \(lineWidth)")
        }
        
        return params.isEmpty
            ? ".init()"
            : ".init(\(params.joined(separator: ", ")))"
    }
}
