//
//  View+barShadow.swift
//  BarKit
//
//  Created by Maksim Gaisin on 13.05.26.
//

import SwiftUI

extension View {
    /// Applies a `ShadowConfiguration` as a drop shadow, or does nothing if `nil`.
    func barShadow(_ shadow: ShadowConfiguration?) -> some View {
        self.shadow(
            color: shadow?.color ?? .clear,
            radius: shadow?.radius ?? 0,
            x: shadow?.x ?? 0,
            y: shadow?.y ?? 0
        )
    }
}
