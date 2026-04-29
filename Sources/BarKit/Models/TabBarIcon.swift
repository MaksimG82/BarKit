//
//  TabBarIcon.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

/// Icon representation for tab bar items
///
/// ```swift
/// TabBarIcon.system("heart.fill")
/// TabBarIcon.custom("myCustomIcon")
/// ```
public enum TabBarIcon: Hashable {
    /// Custom image asset name.
    case custom(String)

    /// SF Symbols name.
    case system(String)
}
