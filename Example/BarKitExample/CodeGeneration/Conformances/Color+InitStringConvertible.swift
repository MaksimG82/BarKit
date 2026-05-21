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
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
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
