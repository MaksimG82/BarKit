//
//  BarIconView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

/// A helper view that renders a bar icon from either a system symbol or a custom asset.
struct BarIconView: View {
    
    // MARK: - Environment

    /// The unique coordinate space name passed from the parent layout.
    @Environment(\.bkBarSpaceName) private var coordinateSpaceName
    
    /// The icon to render, either a system symbol or a custom image asset.
    let icon: BarIcon
    
    /// The identifier of the associated bar item, used to capture the icon frame.
    let itemID: AnyHashable

    var body: some View {
        image
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .capturePreference(
                key: BarIconFrameKey.self,
                in: .named(coordinateSpaceName)
            ) {
                [itemID: $0.frame(in: .named(coordinateSpaceName))]
            }
    }

    private var image: Image {
        switch icon {
        case let .system(name):  Image(systemName: name)
        case let .custom(name):  Image(name)
        }
    }
}
