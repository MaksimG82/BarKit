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
    @Entry var bkDebugLayoutEnabled: Bool = false
#endif
        
    /// The unique coordinate space name for the current bar instance.
    @Entry var bkBarSpaceName: String = ""
    
    /// A binding to a dictionary that controls bar visibility by string identifier.
    /// Write `.hidden` for a given key to signal the associated bar should not be rendered.
    @Entry var bkBarVisibility: Binding<[String: Visibility]> = .constant([:])
}

import SwiftUI

public extension View {
    /// Injects a bar visibility binding into the environment.
    /// The binding maps bar identifiers to their ``Visibility`` state.
    /// Write `.hidden` for a given key to signal the parent to stop rendering that bar.
    func registerBarVisibility(_ binding: Binding<[String: Visibility]>) -> some View {
        environment(\.bkBarVisibility, binding)
    }
}
