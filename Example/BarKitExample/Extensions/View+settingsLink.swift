//
//  View+settingsLink.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.05.26.
//

import SwiftUI

extension View {
    /// Returns a `NavigationLink` that pushes a `SettingsScreen` with the given content.
    func settingsLink<Header: View, Content: View>(
        _ title: String,
        viewModel: ExampleViewModel,
        @ViewBuilder header: @escaping () -> Header = { EmptyView() },
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        NavigationLink(title) {
            SettingsScreen(
                title: title,
                viewModel: viewModel,
                header: header
            ) {
                content()
            }
        }
    }
}
