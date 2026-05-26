//
//  BarItemProtocol.swift
//  BarKit
//
//  Created by Maksim Gaisin on 10.01.26.
//

/// Defines the properties and behavior for a single item view.
///
/// Conform to this protocol to define the content and appearance of your item views.
///
/// ### Example
/// ```swift
/// struct MyTab: BarItemProtocol {
///     let title: String
///     let icon: BarIcon
///     var style: BarItemStyle = .regular
///     var id: AnyHashable { title }
/// }
/// ```
public protocol BarItemProtocol: Hashable, Identifiable {

    /// Icon to display in the item view.
    var icon: BarIcon { get }

    /// Title to display in the item view.
    var title: String { get }

    /// Visual style of the item view.
    var style: BarItemStyle { get set }

    /// Custom accessibility label (defaults to title if nil).
    var accessibilityLabel: String? { get }

    /// Returns a copy of the item with a different style.
    func withStyle(_ newStyle: BarItemStyle) -> Self
}

public extension BarItemProtocol {
    /// Default implementation that returns `nil`, falling back to the `title`.
    var accessibilityLabel: String? {
        nil
    }

    func withStyle(_ newStyle: BarItemStyle) -> Self {
        var copy = self
        copy.style = newStyle
        return copy
    }
}
