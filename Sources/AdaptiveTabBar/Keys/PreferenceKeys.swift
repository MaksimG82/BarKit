//
//  PreferenceKeys.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 14.04.26.
//

import SwiftUI

/// A dictionary mapping tab item identifiers to their frames.
typealias TabItemFrames = [AnyHashable: CGRect]


/// A preference key for collecting and merging tab item frames.
struct TabItemFrameKey: @MainActor PreferenceKey {
    
    /// Initial value containing item IDs and their frame.
    @MainActor static var defaultValue: TabItemFrames = [:]
    
    /// Merges coordinates from child views into a single dictionary.
    static func reduce(value: inout TabItemFrames, nextValue: () -> TabItemFrames) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
