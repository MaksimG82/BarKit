//
//  MaterialSelection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 15.05.26.
//

import SwiftUI

/// Represents the available system material options for a bar background,
/// used to populate the material picker in the Tab Bar settings screen.
enum MaterialSelection: String, CaseIterable {
    case bar = "bar"
    case ultraThin = "Ultra Thin"
    case thin = "Thin"
    case regular = "Regular"
    case thick = "Thick"

    var material: Material? {
        switch self {
        case .bar: .bar
        case .ultraThin: .ultraThinMaterial
        case .thin: .thinMaterial
        case .regular: .regularMaterial
        case .thick: .thickMaterial
        }
    }
}
