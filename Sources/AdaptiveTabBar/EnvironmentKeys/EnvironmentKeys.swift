//
//  EnvironmentKeys.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 11.01.26.
//

import SwiftUI

#if DEBUG
    struct DebugLayoutKey: EnvironmentKey {
        public static let defaultValue = false
    }

    extension EnvironmentValues {
        var debugLayoutEnabled: Bool {
            get { self[DebugLayoutKey.self] }
            set { self[DebugLayoutKey.self] = newValue }
        }
    }

    extension View {
        public func debugLayout(_ enabled: Bool = true) -> some View {
            environment(\.debugLayoutEnabled, enabled)
        }
    }
#endif
