//
//  DefaultRepresentable.swift
//  BarKit
//
//  Created by Maksim Gaisin on 21.05.26.
//

/// A type that provides a default instance for diff-based code generation.
protocol DefaultRepresentable {
    static var `default`: Self { get }
}
