//
//  BarAccecibilityModifier.swift
//  BarKit
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

import SwiftUI

/// Applies accessibility configuration to the bar container.
/// On iOS 17+, adds the `.isTabBar` trait so VoiceOver announces
/// items as tabs and automatically provides "X of Y" position hints.
struct BarContainerAccessibilityModifier: ViewModifier {

    /// Accessibility label for the entire bar container.
    let label: String

    /// Sort priority relative to other elements in the same container.
    let sortPriority: Double

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .accessibilityElement(children: .contain)
                .accessibilityLabel(label)
                .accessibilityAddTraits(.isTabBar)
                .accessibilitySortPriority(sortPriority)
        } else {
            content
                .accessibilityElement(children: .contain)
                .accessibilityLabel(label)
                .accessibilitySortPriority(sortPriority)
        }
    }
}
