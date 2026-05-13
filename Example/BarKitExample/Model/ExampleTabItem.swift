//
//  ExampleTabItem.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import BarKit
import Foundation

/// A sample implementation of `TabBarItemProtocol` for demonstration purposes.
struct OldExampleTabItem: TabBarItemProtocol {
    /// Internal types for the example app tabs.
    enum TabType: String, CaseIterable {
        case home, camera, add, favorites, profile
    }

    // MARK: - Properties

    var type: TabType
    var style: TabItemStyle

    var id: AnyHashable {
        type
    }

    var title: String {
        type.rawValue.capitalized
    }

    var icon: TabBarIcon {
        switch type {
        case .home: .system("house.fill")
        case .camera: .custom("cameraIcon")
        case .add: .system("plus.circle.fill")
        case .favorites: .system("heart.fill")
        case .profile: .system("person.fill")
        }
    }
}

// MARK: - Mock Data

extension OldExampleTabItem {
    static var threeItems: [OldExampleTabItem] {
        [
            .init(type: .home, style: .regular),
            .init(type: .add, style: .prominent),
            .init(type: .camera, style: .regular)
        ]
    }

    static var fourItems: [OldExampleTabItem] {
        [.home, .camera, .favorites, .profile].map {
            .init(type: $0, style: .regular)
        }
    }

    static var fiveItems: [OldExampleTabItem] {
        TabType.allCases.map {
            OldExampleTabItem(type: $0, style: $0 == .add ? .prominent : .regular)
        }
    }
}

/// An `ExampleTabItem` demonstrates the tab bar navigation within the example app.
/// Each tab represents a distinct `BarView` layout or feature of the BarKit library.
struct ExampleTabItem: BarItemProtocol {
 
    /// Internal types for the example app tabs.
    enum TabType: String, CaseIterable {
        case overview   = "Overview"
        case tabBar     = "Tab Bar"
        case standalone = "Standalone"
        case indicator  = "Indicator"
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
        case .overview:   .system("info.circle")
        case .tabBar:     .system("rectangle.roundedtop")
        case .standalone: .system("rectangle.split.3x1")
        case .indicator:  .system("circlebadge.fill")
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
