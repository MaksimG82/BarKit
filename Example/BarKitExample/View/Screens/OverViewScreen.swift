//
//  OverViewScreen.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 23.05.26.
//

import SwiftUI

/// Overview screen presenting a high-level description of BarKit.
struct OverviewView: View {

    var body: some View {
        NavigationStack {
            List {
                headerSection
                    .listRowBackground(Color.clear)
            }
            .navigationTitle("BarKit")
        }
    }

    // MARK: - Sections

    /// A section presenting a concise description of the library.
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("A SwiftUI library for building versatile, customizable UI bars. Create navigation tab bars, floating control panels, or vertical menus anywhere on the screen.")
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text("Designed for iOS 16+ • Open Source")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Text("Select a component below, customize its parameters, and copy the generated initializer code directly into your project.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
