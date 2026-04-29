//
//  Font+UITextStyle.swift
//  BarKit
//
//  Created by Maksim Gaisin on 11.01.26.
//

import SwiftUI

extension Font.TextStyle {
    /// UIKit text style for calculating tab title height
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle, .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .caption2
        }
    }
}
