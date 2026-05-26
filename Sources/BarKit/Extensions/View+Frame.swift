//
//  View+Frame.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

extension View {
    /// Sets the view's frame to the given size.
    /// - Parameters:
    ///   - size: The width and height to apply.
    ///   - alignment: The alignment within the frame. Defaults to `.center`.
    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        frame(width: size.width, height: size.height, alignment: alignment)
    }
}
