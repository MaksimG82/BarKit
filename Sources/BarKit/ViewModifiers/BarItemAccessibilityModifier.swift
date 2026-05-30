//
//  BarItemAccessibilityModifier.swift
//  BarKit
//
//  Created by Maksim Gaisin on 12.01.26.
//

import SwiftUI

/// Applies accessibility configuration to a single bar item.
/// The item is presented as an atomic element — its icon and title
/// are hidden from VoiceOver and replaced by a single label.
struct BarItemAccessibilityModifier<Item: BarItemProtocol>: ViewModifier {

    /// The data model for this bar item.
    let item: Item

    /// Indicates whether this item is currently selected.
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(item.accessibilityLabel ?? item.title)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
