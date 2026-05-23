//
//  BarMaterial.swift
//  BarKit
//
//  Created by Maksim Gaisin on 15.05.26.
//

import SwiftUI

/// The available system material styles for a bar background.
public enum BarMaterial {
    case bar
    case ultraThin
    case thin
    case regular
    case thick
    
    /// The corresponding SwiftUI `Material` value.
    var resolved: Material {
        switch self {
        case .bar:      .bar
        case .ultraThin: .ultraThinMaterial
        case .thin:      .thinMaterial
        case .regular:   .regularMaterial
        case .thick:     .thickMaterial
        }
    }
}
