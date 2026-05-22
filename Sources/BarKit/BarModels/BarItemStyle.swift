//
//  BarItemStyle.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

/// Defines the visual style and emphasis of a bar item
public struct BarItemStyle: Hashable, Sendable {
    
    /// The unique identifier of style
    public let identifier: String
    
    /// Standard bar item appearance.
    public static let regular = BarItemStyle(identifier: "regular")

    /// Visually emphasized tab bar item.
    /// May use a larger icon or extended layout.
    public static let prominent = BarItemStyle(identifier: "prominent")
    
    /// Creates a new `BarItemStyle` with the given identifier.
    /// - Parameter identifier: The unique identifier of the style.
    public init(identifier: String) {
        self.identifier = identifier
    }
}

