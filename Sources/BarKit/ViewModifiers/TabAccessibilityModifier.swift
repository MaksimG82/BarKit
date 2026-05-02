//
//  TabAccessibilityModifier.swift
//  BarKit
//
//  Created by Maksim Gaisin on 12.01.26.
//

import SwiftUI

struct TabAccessibilityModifier<Item: TabBarItemProtocol>: ViewModifier {
    let item: Item
    let isSelected: Bool

    func body(content: Content) -> some View {
        #warning("Analize and test it (ATB-23)!")
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(item.accessibilityLabel ?? item.title)
            .accessibilityAddTraits(.isButton)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
            .accessibilityRemoveTraits(.isImage)
    }
}


struct BarAccessibilityModifier<Item: BarItemProtocol>: ViewModifier {
    let item: Item
    let isSelected: Bool

    func body(content: Content) -> some View {
        #warning("Analize and test it (ATB-23)!")
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(item.accessibilityLabel ?? item.title)
            .accessibilityAddTraits(.isButton)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
            .accessibilityRemoveTraits(.isImage)
    }
}
