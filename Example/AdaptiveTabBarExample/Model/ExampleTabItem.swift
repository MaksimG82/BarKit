//
//  ExampleTabItem.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 16.01.26.
//

import AdaptiveTabBar
import Foundation

/// A sample tab item implementation for the Example app.
struct ExampleTabItem: TabBarItemProtocol, Identifiable {
    enum TabType: String, CaseIterable {
        case home, camera, add, favorites, profile
    }

    let id = UUID()
    let type: TabType
    var style: TabItemStyle

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

    static var threeItems: [ExampleTabItem] {
        [.init(type: .home, style: .regular),
         .init(type: .add, style: .prominent),
         .init(type: .camera, style: .regular)]
    }

    static var fourItems: [ExampleTabItem] {
        [.init(type: .home, style: .regular),
         .init(type: .camera, style: .regular),
         .init(type: .favorites, style: .regular),
         .init(type: .profile, style: .regular)]
    }

    static var fiveItems: [ExampleTabItem] {
        TabType.allCases.map {
            ExampleTabItem(type: $0, style: $0 == .add ? .prominent : .regular)
        }
    }
}
