//
//  BarConfiguration.swift
//  BarKit
//
//  Created by Maksim Gaisin on 29.04.26.
//

import SwiftUI

/// A configuration object that defines the visual style, layout, and behavior of `BarView`.
public struct BarConfiguration {

    // MARK: - Axis

    /// Defines the layout direction of items within the bar.
    public enum Axis {
        /// Items are arranged in a horizontal row.
        case horizontal
        /// Items are arranged in a vertical column.
        case vertical
    }

    /// The layout axis of the bar.
    public var axis: Axis
    
    // MARK: - Shape

    /// Corner radius of the bar capsule.
    public var cornerRadius: CGFloat

    /// Shadow applied to the bar capsule.
    public var shadow: ShadowConfiguration?
    
    // MARK: - Bar Background

    /// The background appearance of the bar, including color, material blur, or custom blur.
    public var background: BarBackground
    
    // MARK: - Item
    
    /// The arrangement of icon and title within each bar item.
    /// When `nil`, the layout is inferred from the bar axis and current size class:
    /// horizontal bar uses `.vertical` in regular, `.horizontal` in compact;
    /// vertical bar always uses `.horizontal`.
    public var itemContentAxis: ItemContentAxis?

    /// Visual configuration per item style.
    /// Defines appearance for each `BarItemStyle` used in the bar.
    /// Falls back to `.regular` configuration if a style has no explicit entry.
    public var itemStyles: [BarItemStyle: ItemConfiguration]
    
    /// Spacing between items in the stack.
    public var itemSpacing: CGFloat
    
    /// The animation applied to the icon and title when an item changes between selected and unselected states.
    public var itemStateAnimation: Animation?
    
    /// The item style used as the baseline for bar height calculation.
    /// When non-nil, `BarView` fixes its height to match this style's metrics,
    /// allowing prominent items to overflow upward. Set to `nil` if no prominent items are used.
    public var baselineStyle: BarItemStyle? = .regular
    
    // MARK: - Accessibility

    /// Accessibility label for the entire bar.
    public var barAccessibilityLabel: String

    /// The sort priority used to order this bar relative to other accessibility elements.
    /// Set a lower value (e.g. `-1`) to ensure VoiceOver reaches content before the bar
    /// when both are placed in the same `ZStack`. Has no effect across different containers.
    public var accessibilitySortPriority: Double
    
    // MARK: - Haptic feedback
    
    /// The haptic feedback style triggered when the selected item changes.
    /// Requires iOS 17 or later. Pass `nil` to disable haptic feedback.
    public var hapticFeedback: HapticFeedback?
    
    /// Creates a new `BarConfiguration`.
    ///
    /// - Parameters:
    ///   - axis: The layout direction of items within the bar.
    ///   - cornerRadius: Corner radius of the bar capsule.
    ///   - shadow: Shadow applied to the bar capsule. Pass `nil` for no shadow.
    ///   - background: The background appearance of the bar.
    ///   - itemStyles: Visual configuration per item style.
    ///   - itemSpacing: Spacing between items in the stack.
    ///   - itemStateAnimation: Animation applied to icon and title during selection changes.
    ///   - baselineStyle: Item style used as the baseline for bar height calculation. Set when prominent items are present.
    ///   - barAccessibilityLabel: Accessibility label for the entire bar.
    ///   - hapticFeedback: The haptic feedback style triggered on selection change. Pass `nil` to disable.
    ///   - accessibilitySortPriority: Sort priority relative to other elements in the same container. Pass a lower value (e.g. `-1`) to ensure VoiceOver reaches content before the bar.
    public init(
        axis: Axis = .horizontal,
        cornerRadius: CGFloat = 28,
        shadow: ShadowConfiguration? = .init(),
        background: BarBackground = .material(.ultraThinMaterial),
        itemStyles: [BarItemStyle: ItemConfiguration] = [.regular: .init()],
        itemSpacing: CGFloat = 0,
        itemStateAnimation: Animation? = .easeInOut(duration: 0.2),
        baselineStyle: BarItemStyle? = nil,
        barAccessibilityLabel: String = "Tab Bar",
        hapticFeedback: HapticFeedback? = .selection,
        accessibilitySortPriority: Double = 0
    ) {
        self.axis = axis
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.background = background
        self.itemStyles = itemStyles
        self.itemSpacing = itemSpacing
        self.itemStateAnimation = itemStateAnimation
        self.baselineStyle = baselineStyle
        self.barAccessibilityLabel = barAccessibilityLabel
        self.hapticFeedback = hapticFeedback
        self.accessibilitySortPriority = accessibilitySortPriority
    }
}
