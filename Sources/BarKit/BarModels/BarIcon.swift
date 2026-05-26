//
//  BarIcon.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

/// Icon representation for bar items
///
/// ```swift
/// BarIcon.system("heart.fill")
/// BarIcon.custom("myCustomIcon")
/// ```
public enum BarIcon: Hashable, Sendable {
    /// Custom image asset name.
    case custom(String)

    /// SF Symbols name.
    case system(String)
}
