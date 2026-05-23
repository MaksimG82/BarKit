//
//  BarMaterial+Example.swift.swift
//  BarKit
//
//  Created by Maksim Gaisin on 23.05.26.
//



import BarKit

extension BarMaterial: @retroactive CaseIterable {
    public static var allCases: [BarMaterial] {
        [.bar, .ultraThin, .thin, .regular, .thick]
    }

    /// Display name for use in the settings UI.
    var displayName: String {
        switch self {
        case .bar:       return "Bar"
        case .ultraThin: return "Ultra Thin"
        case .thin:      return "Thin"
        case .regular:   return "Regular"
        case .thick:     return "Thick"
        }
    }
}
