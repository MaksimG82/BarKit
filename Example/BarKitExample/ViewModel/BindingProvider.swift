//
//  BindingProvider.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 13.05.26.
//

import SwiftUI

// MARK: - Protocol

/// Provides a shared `binding` factory to all binding provider implementations.
protocol BindingProvider {
    var viewModel: ExampleViewModel { get }
}

extension BindingProvider {
    
    /// Creates a `Binding` by reading and patching a value at `keyPath` within `Root`,
    /// then dispatching the result as an `ExampleIntent`.
    func binding<Root, Value>(
        get: @escaping () -> Root,
        keyPath: WritableKeyPath<Root, Value>,
        send: @escaping (Root) -> ExampleIntent
    ) -> Binding<Value> {
        Binding(
            get: { get()[keyPath: keyPath] },
            set: {
                var root = get()
                root[keyPath: keyPath] = $0
                self.viewModel.send(send(root))
            }
        )
    }
}
