//
//  View+settingsLink.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.05.26.
//

import SwiftUI
import BarKit

extension View {
    /// Returns a `NavigationLink` that pushes a `SettingsScreen` with the given content.
    /// - Parameters:
    ///   - title: The navigation link label and screen title.
    ///   - viewModel: The shared example view model.
    ///   - hideTabBar: When `true`, writes `.hidden` for the `"tabBar"` key into the
    ///     shared visibility binding while the destination is on screen.
    ///   - header: An optional view rendered above the settings content.
    ///   - content: The settings sections rendered inside the screen.
    func settingsLink<Header: View, Content: View>(
        _ title: String,
        viewModel: ExampleViewModel,
        hideTabBar: Bool = false,
        @ViewBuilder header: @escaping () -> Header = { EmptyView() },
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        NavigationLink(title) {
            let screen = SettingsScreen(
                title: title,
                viewModel: viewModel,
                header: header
            ) {
                content()
            }
            if hideTabBar {
                screen.hideBar(id: "tabBar")
            } else {
                screen
            }
        }
    }
}
