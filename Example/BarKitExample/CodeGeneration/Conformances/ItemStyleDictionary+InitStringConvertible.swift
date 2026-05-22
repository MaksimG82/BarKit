//
//  ItemStyleDictionary+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//

import BarKit


extension Dictionary: InitStringConvertible, DefaultRepresentable where Key == BarItemStyle, Value == ItemConfiguration {
    
    /// Default instance used as a baseline for diff.
    public static var `default`: [BarItemStyle: ItemConfiguration] {
        [.regular: .default]
    }

    /// A Swift source string representing this instance's initializer.
    /// Only parameters differing from `Self.default` are included.
    ///
    /// Target output:
    /// ```swift
    /// [.regular: .init(), .prominent: .init(iconSideLength: 32)]
    /// ```
    public var initString: String {
        if self == Self.default {
            return "[:]"
        }
        
        let pairs = map { key, value in
            "\(key.initString): \(value.initString)"
        }.sorted()
        
        return "[\(pairs.joined(separator: ", "))]"
    }
}
