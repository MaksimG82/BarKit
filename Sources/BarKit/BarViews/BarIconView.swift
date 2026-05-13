//
//  BarIconView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

/// A helper view that renders a bar icon from either a system symbol or a custom asset.
struct BarIconView: View {
    let icon: BarIcon

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
