//
//  View+Debug.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

extension View {
    
    func debugBorder(_ color: Color) -> some View {
        #if DEBUG
        return self.border(color.opacity(0.5), width: 1)
        #else
        return self
        #endif
    }

    func debugArea(_ color: Color) -> some View {
        #if DEBUG
        return self.background(color.opacity(0.2), ignoresSafeAreaEdges: [])
        #else
        return self
        #endif
    }
}
