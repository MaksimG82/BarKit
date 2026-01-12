//
//  TabAccessibilityModifier.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 12.01.26.
//

import SwiftUI

struct TabAccessibilityModifier<Item: TabBarItemProtocol>: ViewModifier {
    let item: Item
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(item.accessibilityLabel ?? item.title)
            .accessibilityAddTraits(.isButton)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
            .accessibilityRemoveTraits(.isImage)
    }
}
