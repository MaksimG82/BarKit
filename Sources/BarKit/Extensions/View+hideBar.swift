//
//  View+hideBar.swift
//  BarKit
//
//  Created by Maksim Gaisin on 25.05.26.
//

import SwiftUI

public extension View {
    /// Writes `.hidden` for the given bar identifier into the shared visibility binding
    /// when this view appears, and restores `.visible` when it disappears.
    /// The actual rendering decision belongs to the container that owns the binding.
    func hideBar(id: String) -> some View {
        modifier(HideBarModifier(id: id))
    }
}

/// A modifier that updates the shared bar visibility dictionary
/// based on the appearance lifecycle of the modified view.
private struct HideBarModifier: ViewModifier {
    
    /// The bar identifier used as a key in the visibility dictionary.
    let id: String

    /// The shared visibility binding injected by the container via ``bkBarVisibility(_:)``.
    @Environment(\.bkBarVisibility) private var visibility

    /// Writes `.hidden` on appear and `.visible` on disappear for ``id``.
    func body(content: Content) -> some View {
        content
            .onAppear { visibility.wrappedValue[id] = .hidden }
            .onDisappear { visibility.wrappedValue[id] = .visible }
    }
}
