//
//  TabIconView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

struct TabIconView: View {
    
    let icon: TabBarIcon

    var body: some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .custom(let name):
            Image(name)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
