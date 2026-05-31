//
//  CGRect+scaled.swift
//  BarKit
//
//  Created by Maksim Gaisin on 31.05.26.
//

import CoreGraphics

extension CGRect {
    /// Scales the rectangle from its center point by the given factors.
    ///
    /// - Parameters:
    ///   - xScale: Horizontal scale factor.
    ///   - yScale: Vertical scale factor.
    /// - Returns: A new rectangle scaled from the center of the receiver.
    func scaled(x xScale: CGFloat, y yScale: CGFloat) -> CGRect {
        let newWidth = width * xScale
        let newHeight = height * yScale
        return CGRect(
            x: midX - newWidth / 2,
            y: midY - newHeight / 2,
            width: newWidth,
            height: newHeight
        )
    }
}
