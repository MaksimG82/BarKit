//
//  BarItemAlignment.swift
//  BarKit
//
//  Created by Maksim Gaisin on 20.05.26.
//

import SwiftUI

/// Defines the alignment of content along an axis — either items within the bar or icon and title within an item.
public enum BarItemAlignment: Sendable {
    case start
    case center
    case end
}

extension BarItemAlignment {
    var vertical: VerticalAlignment {
        switch self {
        case .start:  .top
        case .center: .center
        case .end:    .bottom
        }
    }

    var horizontal: HorizontalAlignment {
        switch self {
        case .start:  .leading
        case .center: .center
        case .end:    .trailing
        }
    }
}
