//
//  View+Debug.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func applyDebugVisuals(color: Color) -> some View {
        #if DEBUG
            modifier(DebugVisualsModifier(color: color))
        #else
            self
        #endif
    }
}

#if DEBUG
    private struct DebugVisualsModifier: ViewModifier {
        @Environment(\.debugLayoutEnabled) var isDebugEnabled
        let color: Color

        func body(content: Content) -> some View {
            if isDebugEnabled {
                content
                    .background(color.opacity(0.2), ignoresSafeAreaEdges: [])
                    .border(color.opacity(0.5), width: 1)
            } else {
                content
            }
        }
    }
#endif
