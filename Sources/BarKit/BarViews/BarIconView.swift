//
//  BarIconView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

/// A helper view that renders a bar icon from either a system symbol or a custom asset.
struct BarIconView: View {
    /// The icon to render, either a system symbol or a custom image asset.
    let icon: BarIcon

    var body: some View {
        image
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    private var image: Image {
        switch icon {
        case let .system(name):  Image(systemName: name)
        case let .custom(name):  Image(name)
        }
    }
}
