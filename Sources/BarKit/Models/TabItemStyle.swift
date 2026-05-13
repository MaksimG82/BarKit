//
//  TabItemStyle.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

/// Defines the visual style and emphasis of a tab bar item
public struct TabItemStyle: Hashable, Sendable {
    
    /// The unique identifier of style
    public let identifier: String
    
    /// Standard tab bar item appearance.
    public static let regular = TabItemStyle(identifier: "regular")

    /// Visually emphasized tab bar item.
    /// May use a larger icon or extended layout.
    public static let prominent = TabItemStyle(identifier: "prominent")
}
