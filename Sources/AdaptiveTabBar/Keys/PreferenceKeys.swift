//
//  PreferenceKeys.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 14.04.26.
//

import SwiftUI

/// A preference key to collect the horizontal center positions of tab items.
struct TabItemCenterXKey: @MainActor PreferenceKey {
    /// Initial value containing item IDs and their horizontal centers.
    @MainActor static var defaultValue: [AnyHashable: CGFloat] = [:]

    /// Merges coordinates from child views into a single dictionary.
    static func reduce(value: inout [AnyHashable: CGFloat], nextValue: () -> [AnyHashable: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
