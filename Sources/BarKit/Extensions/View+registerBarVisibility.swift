//
//  View+registerBarVisibility.swift
//  BarKit
//
//  Created by Maksim Gaisin on 26.05.26.
//

import SwiftUI

public extension View {
    /// Injects a bar visibility binding into the environment.
    /// The binding maps bar identifiers to their ``Visibility`` state.
    /// Write `.hidden` for a given key to signal the parent to stop rendering that bar.
    func registerBarVisibility(_ binding: Binding<[String: Visibility]>) -> some View {
        environment(\.bkBarVisibility, binding)
    }
}
