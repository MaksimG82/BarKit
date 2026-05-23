//
//  BorderConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 02.05.26.
//

import SwiftUI

/// Defines the optional border drawn around the selection indicator.
public struct BorderConfiguration: Equatable, Sendable {
    /// The color of the border.
    public var color: Color
    /// The thickness of the border in points.
    public var lineWidth: CGFloat

    public init(color: Color = .white.opacity(0.3), lineWidth: CGFloat = 1) {
        self.color = color
        self.lineWidth = lineWidth
    }
}
