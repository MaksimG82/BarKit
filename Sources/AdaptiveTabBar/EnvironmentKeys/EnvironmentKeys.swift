//
//  EnvironmentKeys.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 11.01.26.
//

import SwiftUI

#if DEBUG
    extension EnvironmentValues {
        @Entry var debugLayoutEnabled: Bool = false
    }
#endif
