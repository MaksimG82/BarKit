//
//  View+capturePreference.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 14.04.26.
//

import SwiftUI

extension View {
    /// Captures a frame-related value and sends it to a specified PreferenceKey.
    /// - Parameters:
    ///   - key: The PreferenceKey type to update.
    ///   - space: The coordinate space for measurement.
    ///   - transform: A closure that converts GeometryProxy into the desired value.
    func capturePreference<K: PreferenceKey>(
        key: K.Type,
        in space: CoordinateSpace,
        transform: @escaping (GeometryProxy) -> K.Value
    ) -> some View {
        self.background {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: key, value: transform(geometry))
            }
        }
    }
}
