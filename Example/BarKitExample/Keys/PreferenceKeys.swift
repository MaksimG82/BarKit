//
//  PreferenceKeys.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 06.05.26.
//

import SwiftUI

/// Preference key for propagating the tab bar height up the view hierarchy.
struct TabBarHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
