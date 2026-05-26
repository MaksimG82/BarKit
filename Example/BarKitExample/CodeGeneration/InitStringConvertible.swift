//
//  InitStringConvertible.swift
//  BarKit
//
//  Created by Maksim Gaisin on 21.05.26.
//

/// A type that can represent its own initializer as a Swift source string.
protocol InitStringConvertible {
    var initString: String { get }
}



