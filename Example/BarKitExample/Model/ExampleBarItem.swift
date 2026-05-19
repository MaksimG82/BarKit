//
//  ExampleBarItem.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 19.05.26.
//

import BarKit
import Foundation

/// A bar item used to demonstrate standalone `BarView` layouts in the example app.

struct ExampleBarItem: BarItemProtocol {

    /// The type of drink represented by this item.
    enum DrinkType: String, CaseIterable {
        case whiskey  = "Whiskey"
        case beer     = "Beer"
        case coffee   = "Coffee"
        case water    = "Water"
        case cocktail = "Cocktail"
    }

    // MARK: - Properties

    /// The drink type, used as a stable identifier.
    var type: DrinkType

    /// The visual style of the bar item.
    var style: BarItemStyle

    /// A stable unique identifier derived from the drink type.
    var id: AnyHashable { type }

    /// The display title shown below the icon.
    var title: String { type.rawValue }

    /// The icon displayed in the bar for this item.
    var icon: BarIcon {
        switch type {
        case .whiskey:  .system("wineglass.fill")
        case .beer:     .system("mug.fill")
        case .coffee:   .system("cup.and.saucer.fill")
        case .water:    .system("waterbottle.fill")
        case .cocktail: .system("bubbles.and.sparkles")
        }
    }
}

// MARK: - Default Set

extension ExampleBarItem {
    /// The default set of items covering all available drinks.
    static var allItems: [ExampleBarItem] {
        DrinkType.allCases.map { .init(type: $0, style: .regular) }
    }
}
