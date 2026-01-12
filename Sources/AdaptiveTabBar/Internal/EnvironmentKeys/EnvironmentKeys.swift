//
//  EnvironmentKeys.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 11.01.26.
//

import SwiftUI

#if DEBUG
struct DebugLayoutKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var debugLayoutEnabled: Bool {
        get { self[DebugLayoutKey.self] }
        set { self[DebugLayoutKey.self] = newValue }
    }
}
#endif
