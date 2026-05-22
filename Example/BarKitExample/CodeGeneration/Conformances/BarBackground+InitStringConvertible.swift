//
//  BarBackground+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//

import SwiftUI
import BarKit


extension BarBackground: InitStringConvertible, DefaultRepresentable {
    
    /// Default instance used as a baseline for diff.
    public static var `default`: BarBackground = .material(.ultraThin)

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// BarBackground.material(.thin, tint: Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.1))
    /// ```
    public var initString: String {
        switch self {
        case .color(let color):
            return ".color(\(color.initString))"
            
        case .material(let material, let tint):
            if tint == .clear {
                return ".material(.\(material))"
            }
            return ".material(.\(material), tint: \(tint.initString))"
            
        case .customBlur(let config, let tint):
            if tint == .clear {
                return ".customBlur(\(config.initString))"
            }
            return ".customBlur(\(config.initString), tint: \(tint.initString))"
        }
    }
}


