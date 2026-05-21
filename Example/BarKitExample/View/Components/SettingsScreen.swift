//
//  SettingsScreen.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.05.26.
//

import SwiftUI

struct SettingsScreen<Header: View, Content: View>: View {

    @Environment(\.verticalSizeClass) var sizeClass

    let title: String
    let viewModel: ExampleViewModel
    @ViewBuilder let header: () -> Header
    @ViewBuilder let content: () -> Content

    init(
        title: String,
        viewModel: ExampleViewModel,
        @ViewBuilder header: @escaping () -> Header = { EmptyView() },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.viewModel = viewModel
        self.header = header
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            header()
            List {
                content()
            }
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .navigationTitle(title)
    }
}
