//
//  ExampleTabItem.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import AdaptiveTabBar
import Foundation

/// A sample implementation of `TabBarItemProtocol` for demonstration purposes.
struct ExampleTabItem: TabBarItemProtocol {
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

extension ExampleTabItem {
    static var threeItems: [ExampleTabItem] {
        [
            .init(type: .home, style: .regular),
            .init(type: .add, style: .prominent),
            .init(type: .camera, style: .regular)
        ]
    }

    static var fourItems: [ExampleTabItem] {
        [.home, .camera, .favorites, .profile].map {
            .init(type: $0, style: .regular)
        }
    }

    static var fiveItems: [ExampleTabItem] {
        TabType.allCases.map {
            ExampleTabItem(type: $0, style: $0 == .add ? .prominent : .regular)
        }
    }
}
