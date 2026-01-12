//
//  View+Debug.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

#if DEBUG
    public extension View {
        /// Enables or disables visual layout debugging for the view hierarchy.
        /// Used to display frames, and borders interaction areas of the tab bar components.
        ///
        /// This modifier is only available in DEBUG builds. It sets the
        /// `debugLayoutEnabled` value in the environment.
        ///
        /// Example:
        /// ```swift
        /// TabBarView(...)
        ///     .debugLayout(true)
        /// ```
        ///
        /// - Parameter enabled: The state of the debug mode. Defaults to `true`.
        /// - Returns: A view with the updated environment value for debugging.
        func debugLayout(_ enabled: Bool = true) -> some View {
            environment(\.debugLayoutEnabled, enabled)
        }
    }
#endif

extension View {
    @ViewBuilder
    func applyDebugVisuals(color: Color) -> some View {
        #if DEBUG
            modifier(DebugVisualsModifier(color: color))
        #else
            self
        #endif
    }
}
