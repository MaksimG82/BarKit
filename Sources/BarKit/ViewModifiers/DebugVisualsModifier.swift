//
//  DebugVisualsModifier.swift
//  BarKit
//
//  Created by Maksim Gaisin on 12.01.26.
//

import SwiftUI

#if DEBUG
    struct DebugVisualsModifier: ViewModifier {
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
