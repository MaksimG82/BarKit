//
//  BadgeValue.swift
//  BarKit
//
//  Created by Maksim Gaisin on 28.05.26.
//


/// Represents the content displayed in a badge overlay on a bar item.
public enum BadgeValue: Sendable, Equatable {
 
    /// A small dot with no text content.
    case dot
 
    /// A numeric counter badge.
    case count(Int)
 
    /// A badge displaying an arbitrary string (e.g. `"New"`).
    case label(String)
}