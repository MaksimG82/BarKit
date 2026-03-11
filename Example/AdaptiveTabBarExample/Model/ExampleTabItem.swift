//
//  ExampleTabItem.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import AdaptiveTabBar
import Foundation

/// A sample tab item implementation for the Example app.
enum ExampleTabItem: String, CaseIterable, TabBarItemProtocol {
    case home
    case camera
    case add
    case favorites
    case profile

    // MARK: - TabBarItemProtocol

    var title: String {
        rawValue.capitalized
    }

    var icon: TabBarIcon {
        switch self {
        case .home: .system("house.fill")
        case .camera: .custom("cameraIcon")
        case .add: .system("plus.circle.fill")
        case .favorites: .system("heart.fill")
        case .profile: .system("person.fill")
        }
    }

    var style: TabItemStyle {
        self == .add ? .prominent : .regular
    }
}

extension ExampleTabItem {
    static var threeItems: [ExampleTabItem] {
        [.home, .add, .camera]
    }

    static var fourItems: [ExampleTabItem] {
        [.home, .camera, .favorites, .profile]
    }
}
