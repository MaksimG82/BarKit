//
//  View+floatingTabBarOffset.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 06.05.26.
//

import SwiftUI
import BarKit

extension View {
    /// Adds a transparent bottom content inset to prevent content from being obscured by the floating tab bar.
    /// If `barID` is provided, collapses the inset when that bar is hidden.
    func floatingTabBarOffset(_ offset: CGFloat, barID: String? = nil) -> some View {
        modifier(FloatingTabBarOffsetModifier(offset: offset, barID: barID))
    }
}

/// Applies a bottom safe area inset, optionally collapsing it based on bar visibility.
private struct FloatingTabBarOffsetModifier: ViewModifier {

    /// The inset height when the bar is visible.
    let offset: CGFloat

    /// The bar identifier to check in the visibility dictionary. `nil` disables the check.
    let barID: String?

    /// The shared visibility binding injected by the container.
    @Environment(\.bkBarVisibility) private var visibility

    /// Returns `0` when the bar is hidden, otherwise returns ``offset``.
    private var resolvedOffset: CGFloat {
        guard let barID else { return offset }
        return visibility.wrappedValue[barID] == .hidden ? 0 : offset
    }

    func body(content: Content) -> some View {
        content.safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: resolvedOffset)
        }
    }
}
