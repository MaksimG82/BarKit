//
//  DebugVisualsModifier.swift
//  BarKit
//
//  Created by Maksim Gaisin on 12.01.26.
//

import SwiftUI

#if DEBUG
/// Overlays a colored border and background tint to visualize the view's frame.
/// Only active when `debugLayoutEnabled` is `true` in the environment.
struct DebugVisualsModifier: ViewModifier {
    /// Current debug layout state from the environment.
    @Environment(\.debugLayoutEnabled) var isDebugEnabled
    /// The color used for the border and background tint.
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
