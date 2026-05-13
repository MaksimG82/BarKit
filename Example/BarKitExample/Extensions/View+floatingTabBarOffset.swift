//
//  View+floatingTabBarOffset.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 06.05.26.
//

import SwiftUI

extension View {
    /// Adds a transparent bottom content inset to prevent content from being obscured by the floating tab bar.
    func floatingTabBarOffset(_ offset: CGFloat) -> some View {
        safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: offset)
        }
    }
}
