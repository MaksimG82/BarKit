//
//  PreferenceKeys.swift
//  BarKit
//
//  Created by Maksim Gaisin on 14.04.26.
//

import SwiftUI

/// A dictionary mapping item identifiers to their frames.
typealias BarItemFrames = [AnyHashable: CGRect]


/// A preference key for collecting and merging item frames.
struct BarItemFrameKey: PreferenceKey {
    
    /// Initial value containing item IDs and their frame.
    nonisolated(unsafe) static let defaultValue: BarItemFrames = [:]
    
    /// Merges coordinates from child views into a single dictionary.
    static func reduce(
        value: inout BarItemFrames,
        nextValue: () -> BarItemFrames
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
