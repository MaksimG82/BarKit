//
//  PreferenceKeys.swift
//  BarKit
//
//  Created by Maksim Gaisin on 14.04.26.
//

import SwiftUI

/// A dictionary mapping item identifiers to their frames.
typealias BarItemFrames = [AnyHashable: CGRect]

/// A dictionary mapping item identifiers to their icon frames.
typealias BarIconFrames = [AnyHashable: CGRect]

/// A preference key for collecting and merging item frames.
struct BarItemFrameKey: PreferenceKey {
    
    /// An empty dictionary; populated as item frames are reported by child views.
    nonisolated(unsafe) static let defaultValue: BarItemFrames = [:]
    
    /// Merges coordinates from child views into a single dictionary.
    static func reduce(
        value: inout BarItemFrames,
        nextValue: () -> BarItemFrames
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

/// A preference key for collecting and merging icon frames.
struct BarIconFrameKey: PreferenceKey {

    /// An empty dictionary; populated as icon frames are reported by child views.
    nonisolated(unsafe) static let defaultValue: BarIconFrames = [:]

    /// Merges coordinates from child views into a single dictionary.
    static func reduce(
        value: inout BarIconFrames,
        nextValue: () -> BarIconFrames
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
