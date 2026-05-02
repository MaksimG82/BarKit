//
//  EnvironmentKeys.swift
//  BarKit
//
//  Created by Maksim Gaisin on 11.01.26.
//

import SwiftUI


extension EnvironmentValues {
#if DEBUG
    /// Toggles supplementary visual guides and outlines to assist with layout debugging.
    @Entry var debugLayoutEnabled: Bool = false
#endif
    
    /// The unique coordinate space name for the current tab bar instance.
    @Entry var tabBarSpaceName: String = ""
    
    /// The unique coordinate space name for the current bar instance.
    @Entry var barSpaceName: String = ""
}
