//
//  EnvironmentKeys.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 11.01.26.
//

import SwiftUI

#if DEBUG
public struct DebugLayoutKey: EnvironmentKey {
    public static let defaultValue = false
}

public extension EnvironmentValues {
    var debugLayoutEnabled: Bool {
        get { self[DebugLayoutKey.self] }
        set { self[DebugLayoutKey.self] = newValue }
    }
}

extension View {
    func debugLayout(_ enabled: Bool = true) -> some View {
        self.environment(\.debugLayoutEnabled, enabled)
    }
}
#endif
