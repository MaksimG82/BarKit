
//
//  CodeGenerationScreen.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//

import SwiftUI
import BarKit

struct CodeGenerationScreen: View {

    @Environment(\.verticalSizeClass) var sizeClass

    let viewModel: ExampleViewModel

    var body: some View {
        List {
            descriptionSection
            generationSection
        }
        .floatingTabBarOffset(viewModel.contentOffset(sizeClass == .compact))
        .navigationTitle("Generator")
    }
}

// MARK: - View Components

private extension CodeGenerationScreen {

    var descriptionSection: some View {
        Section {
            Text("Generate Swift initializer code for your configured bar. Configure a bar on the Tab Bar or Standalone screen, then share the generated code directly into your project.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    var generationSection: some View {
        Section {
            floatingBarButton
            pinnedBarButton
            standaloneBarButton
        } header: {
            Text("Export")
        } footer: {
            Text("Only configurations that differ from defaults are included in the output.")
        }
    }

    var floatingBarButton: some View {
        ShareLink(
            item: viewModel.floatingTabBarConfig.initString,
            subject: Text("FloatingTabBarView configuration"),
            message: Text("Generated BarKit configuration")
        ) {
            Label("FloatingTabBarView", systemImage: "square.bottomhalf.filled")
        }
    }

    var pinnedBarButton: some View {
        ShareLink(
            item: viewModel.pinnedTabBarConfig.initString,
            subject: Text("PinnedTabBarView configuration"),
            message: Text("Generated BarKit configuration")
        ) {
            Label("PinnedTabBarView", systemImage: "dock.rectangle")
        }
    }

    var standaloneBarButton: some View {
        ShareLink(
            item: viewModel.standaloneBarConfig.initString,
            subject: Text("BarView configuration"),
            message: Text("Generated BarKit configuration")
        ) {
            Label("BarView (Standalone)", systemImage: "rectangle.inset.filled")
        }
    }
}
