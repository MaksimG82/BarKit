//
//  Font.TextStyle+InitStringConvertible.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 22.05.26.
//

import SwiftUI

extension Font.TextStyle: InitStringConvertible {

    /// A Swift source string representing this text style as a dot-syntax expression.
    var initString: String {
        switch self {
        case .largeTitle:  return ".largeTitle"
        case .title:       return ".title"
        case .title2:      return ".title2"
        case .title3:      return ".title3"
        case .headline:    return ".headline"
        case .subheadline: return ".subheadline"
        case .body:        return ".body"
        case .callout:     return ".callout"
        case .footnote:    return ".footnote"
        case .caption:     return ".caption"
        case .caption2:    return ".caption2"
        @unknown default:  return ".body"
        }
    }
}
