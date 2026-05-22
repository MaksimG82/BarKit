//
//  Color+InitStringConvertible.swift
//  BarKit
//
//  Created by Maksim Gaisin on 21.05.26.
//


import SwiftUI

extension Color: InitStringConvertible {
    
    /// A Swift source string representing this color as an initializer.
    var initString: String {
    #if canImport(UIKit)
        let platformColor = UIColor(self)
    #elseif canImport(AppKit)
        let platformColor = NSColor(self).usingColorSpace(.sRGB)!
    #endif
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        platformColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = (red   * 100).rounded() / 100
        let g = (green * 100).rounded() / 100
        let b = (blue  * 100).rounded() / 100
        let a = (alpha * 100).rounded() / 100
        
        if a == 1.0 {
            return "Color(red: \(r), green: \(g), blue: \(b))"
        } else {
            return "Color(red: \(r), green: \(g), blue: \(b), opacity: \(a))"
        }
    }
}
