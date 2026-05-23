//
//  SelectionIndicatorConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 02.05.26.
//

import SwiftUI

/// Defines the visual appearance and behavior of the selection indicator.
public struct SelectionIndicatorConfiguration {

    // MARK: - Appearance

    /// The fill color of the indicator.
    public var color: Color

    /// Optional border applied to the indicator.
    public var border: BorderConfiguration?

    /// Inset between the indicator and the item frame.
    /// Positive values shrink the indicator, negative values expand it.
    public var inset: EdgeInsets

    /// Corner radius of the indicator.
    public var cornerRadius: CGFloat

    // MARK: - Animation

    /// Animation for moving the indicator between items.
    /// Pass `nil` for an instant snap.
    public var transitionAnimation: BarAnimation?

    /// Scaling effect applied to the indicator during transition.
    public var scaleEffect: SelectionScaleEffect?

    // MARK: - Interaction

    /// Whether the user can drag the indicator between items.
    public var isDragGestureEnabled: Bool

    // MARK: - Visual Effects

    /// Active visual effects applied at the indicator boundary.
    public var effects: [IndicatorEffect]

    // MARK: - Init

    /// Creates a new selection indicator configuration.
    ///
    /// - Parameters:
    ///   - color: The fill color of the indicator.
    ///   - border: Optional border drawn around the indicator. Pass `nil` for no border.
    ///   - inset: Inset between the indicator and the item frame.
    ///   - cornerRadius: Corner radius of the indicator shape.
    ///   - transitionAnimation: Animation for moving the indicator between items. Pass `nil` for an instant snap.
    ///   - scaleEffect: Scaling effect applied during transition. Pass `nil` to keep size constant.
    ///   - isDragGestureEnabled: Whether the user can drag the indicator between items.
    ///   - effects: Active visual effects at the indicator boundary.
    public init(
        color: Color = .secondary.opacity(0.2),
        border: BorderConfiguration? = nil,
        inset: EdgeInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2),
        cornerRadius: CGFloat = 24,
        transitionAnimation: BarAnimation? = .parameters(.init()),
        scaleEffect: SelectionScaleEffect? = nil,
        isDragGestureEnabled: Bool = true,
        effects: [IndicatorEffect] = []
    ) {
        self.color = color
        self.border = border
        self.inset = inset
        self.cornerRadius = cornerRadius
        self.transitionAnimation = transitionAnimation
        self.scaleEffect = scaleEffect
        self.isDragGestureEnabled = isDragGestureEnabled
        self.effects = effects
    }

    // MARK: - Helpers

    /// Resolves the transition animation for use in view modifiers.
    public var resolvedTransitionAnimation: Animation? {
        transitionAnimation?.animation
    }
}
