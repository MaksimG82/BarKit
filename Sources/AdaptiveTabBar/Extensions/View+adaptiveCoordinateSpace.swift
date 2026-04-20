//
//  View+AdaptiveCoordinateSpace.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 14.04.26.
//

import SwiftUI

extension View {
    /// Applies a named coordinate space using the appropriate API for the current OS version.
    @ViewBuilder
    func adaptiveCoordinateSpace(name: String) -> some View {
        if #available(iOS 17.0, *) {
            self.coordinateSpace(.named(name))
        } else {
            self.coordinateSpace(name: name)
        }
    }
}
