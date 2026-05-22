//
//  BarAnimation+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//


import BarKit

extension BarAnimation: InitStringConvertible, DefaultRepresentable {
    
    /// Default instance used as a baseline for diff.
    public static var `default`: BarAnimation = .parameters(.default)

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// BarAnimation.parameters(.spring(duration: 0.4))
    /// ```
    public var initString: String {
        switch self {
        case .parameters(let params):
            return ".parameters(\(params.initString))"
        case .custom:
            return "/* custom animation — replace manually */"
        }
    }
}
