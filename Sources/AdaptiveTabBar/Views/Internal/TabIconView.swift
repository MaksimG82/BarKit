//
//  TabIconView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

/// A helper view that renders a tab icon from either a system symbol or a custom asset.
struct TabIconView: View {
    let icon: TabBarIcon

    var body: some View {
        switch icon {
        case let .system(name):
            Image(systemName: name)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case let .custom(name):
            Image(name)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
