//
//  TypographySettingsView.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 11.03.26.
//

import BarKit
import SwiftUI

struct TypographySettingsView: View {
    @Environment(\.tabBarHeight) var tabBarHeight

    var viewModel: OldExampleViewModel

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
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: tabBarHeight) }
        .navigationTitle("Typography")
    }
}

#Preview {
    @Previewable @State var viewModel = OldExampleViewModel()
    NavigationStack {
        ZStack(alignment: .bottom) {
            TypographySettingsView(viewModel: viewModel)

            TabBarView(
                items: viewModel.state.items,
                selected: .constant(viewModel.state.items[0]),
                config: viewModel.state.config
            )
            .overlay(Divider(), alignment: .top)
        }
    }
}
