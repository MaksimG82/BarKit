//
//  DescriptionSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 18.05.26.
//

import SwiftUI

/// A section displaying a short descriptive text, styled as secondary subheadline.
struct DescriptionSection: View {
    
    /// The text displayed inside the section.
    let text: String
    
    var body: some View {
        Section {
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
