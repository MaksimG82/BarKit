//
//  BarItemStyle+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//

import BarKit

extension BarItemStyle: InitStringConvertible, DefaultRepresentable {
    
    /// Default instance used as a baseline for diff.
    public static var `default` = BarItemStyle.regular

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// BarItemStyle(identifier: "custom_style")
    /// ```
    var initString: String {
        switch identifier {
        case "regular":  
            return ".regular"
        case "prominent": 
            return ".prominent"
        default: 
            return "BarItemStyle(identifier: \"\(identifier)\")"
        }
    }
}
