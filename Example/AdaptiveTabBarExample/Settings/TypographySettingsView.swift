//
//  TypographySettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 11.03.26.
//

import AdaptiveTabBar
import SwiftUI

struct TypographySettingsView: View {
    @Bindable var viewModel: ExampleViewModel

    var body: some View {
        List {
            Section(header: Text("Title Text Style")) {
                Picker("Text Style", selection: Binding(
                    get: { viewModel.state.config.textStyle },
                    set: { viewModel.send(.updateTextStyle($0)) }
                )) {
                    ForEach(Font.TextStyle.allCases, id: \.self) { style in
                        Text(String(describing: style).capitalized)
                            .tag(style)
                    }
                }
                .pickerStyle(.inline)
            }
        }
        .navigationTitle("Typography")
    }
}
