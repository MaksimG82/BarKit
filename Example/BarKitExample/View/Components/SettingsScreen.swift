//
//  SettingsScreen.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 16.05.26.
//

import SwiftUI

struct SettingsScreen<Content: View>: View {
    
    @Environment(\.verticalSizeClass) var sizeClass
    
    let title: String
    let viewModel: ExampleViewModel
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        List {
            content()
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .navigationTitle(title)
    }
}
