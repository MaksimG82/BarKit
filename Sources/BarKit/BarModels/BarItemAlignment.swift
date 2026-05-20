//
//  BarItemAlignment.swift
//  BarKit
//
//  Created by Maksim Gaisin on 20.05.26.
//

import SwiftUI

/// Defines the alignment of items along the cross-axis of the bar.
/// For a horizontal bar, this controls vertical alignment.
/// For a vertical bar, this controls horizontal alignment.
public enum BarItemAlignment {
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
