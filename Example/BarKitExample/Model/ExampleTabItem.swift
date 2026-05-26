//
//  ExampleTabItem.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import BarKit
import Foundation

/// An `ExampleTabItem` demonstrates the tab bar navigation within the example app.
/// Each tab represents a distinct `BarView` layout or feature of the BarKit library.
struct ExampleTabItem: BarItemProtocol {
 
    /// Internal types for the example app tabs.
    enum TabType: String, CaseIterable {
        case overview       = "Overview"
        case tabBar         = "Tab Bar"
        case standalone     = "Standalone"
        case codegeneration = "Generator"
    }
 
    // MARK: - Properties
 
    /// The logical type of this tab, used as a stable identifier.
    var type: TabType
 
    /// The visual style of the tab item (regular or prominent).
    var style: BarItemStyle
 
    /// A stable unique identifier derived from the tab type.
    var id: AnyHashable { type }
 
    /// The display title shown below the icon.
    var title: String { type.rawValue }
 
    /// The icon displayed in the tab bar for this tab.
    var icon: BarIcon {
        switch type {
        case .overview:       .system("sparkles")
        case .tabBar:         .system("dock.rectangle")
        case .standalone:     .system("rectangle.inset.filled")
        case .codegeneration: .system("doc.badge.gearshape")
        }
    }
}
 
// MARK: - Default Set
 
extension ExampleTabItem {
    /// The default set of items covering all available example tabs.
    static var allItems: [ExampleTabItem] {
        TabType.allCases.map { .init(type: $0, style: .regular) }
    }
}
