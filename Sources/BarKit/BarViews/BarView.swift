//
//  BarView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 29.04.26.
//

import SwiftUI

/// The core bar view that renders a background, an items stack, a selection indicator,
/// and an overlay items stack. Does not position itself on screen — layout is the
/// responsibility of the calling code.
public struct BarView<Item: BarItemProtocol>: View {

    // MARK: - Environment

    /// Detects current vertical size class to toggle between compact and regular layouts.
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    // MARK: - Bindings

    /// The currently selected bar item.
    @Binding private var selected: Item

    // MARK: - State

    /// Flag indicating whether the indicator is currently in its scaling animation state.
    @State private var isSelectionIndicatorScaling = false

    /// A dictionary mapping each item's unique identifier to its frame in the local coordinate space.
    @State private var itemFrames: [AnyHashable: CGRect] = [:]

    /// The current horizontal position of the user's finger during a drag gesture.
    @State private var gestureXLocation: CGFloat? = nil

    /// Indicates whether the drag gesture is currently active.
    @State private var isDragging: Bool = false
    
    /// A unique identifier for the local coordinate space, stable across view re-renders.
    @State private var coordinateSpaceID = UUID()

    // MARK: - Properties

    /// An array of data models conforming to ``BarItemProtocol``.
    private let items: [Item]

    /// The configuration object defining the visual style, layout, and behavior of the bar.
    private let config: BarConfiguration

    /// The configuration object defining the appearance and behavior of the selection indicator.
    private let indicatorConfig: SelectionIndicatorConfiguration?

    /// An optional closure executed when an item is tapped, even if already selected.
    private let action: ((Item) -> Void)?

    // MARK: - Computed Properties

    /// Returns true if the layout is in a vertically constrained environment.
    private var isVerticalCompact: Bool {
        verticalSizeClass == .compact
    }

    /// The frame of the currently selected item in the local coordinate space.
    /// Falls back to `.zero` as a safety net before frames are populated.
    private var selectedItemFrame: CGRect {
        itemFrames[selected.id] ?? .zero
    }

    /// The stable name for the local coordinate space, unique per `BarView` instance.
    private var coordinateSpaceName: String { coordinateSpaceID.uuidString }

    // MARK: - Init

    /// Initializes a new `BarView`.
    ///
    /// - Parameters:
    ///   - items: An array of data models conforming to ``BarItemProtocol``.
    ///   - selected: A binding to the currently selected item.
    ///   - config: A configuration object defining the visual style of the bar.
    ///   - indicatorConfig: A configuration object defining the selection indicator appearance.
    ///   - action: An optional closure executed when an item is tapped.
    public init(
        items: [Item],
        selected: Binding<Item>,
        config: BarConfiguration,
        indicatorConfig: SelectionIndicatorConfiguration? = .init(),
        action: ((Item) -> Void)? = nil
    ) {
        self.items = items
        _selected = selected
        self.config = config
        self.indicatorConfig = indicatorConfig
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .leading) {
            itemsStack.indicatorLens(indicatorConfig, frame: indicatorFrame())
            
            overlayItemsStack.indicatorLens(indicatorConfig, frame: indicatorFrame())
        }
        .frame(
            height: barHeight(),
            alignment: .bottom
        )
        .background {
            backgroundCapsule
                .applyDebugVisuals(color: .green)
        }
        .overlay(alignment: .leading) {
            selectionIndicator
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(config.barAccessibilityLabel)
    }
}

// MARK: - Subviews

private extension BarView {

    /// A stack of interactive bar items.
    var itemsStack: some View {
        itemStack() { item in
            BarItemView(
                item: item,
                isSelected: item.id == selected.id,
                isVerticalCompact: isVerticalCompact,
                config: config
            ) {
                handleSelection(item)
            }
        }
        .adaptiveCoordinateSpace(name: coordinateSpaceName)
        .environment(\.barSpaceName, coordinateSpaceName)
        .onPreferenceChange(BarItemFrameKey.self) { frames in
            itemFrames = frames
        }
        .defersSystemGestures(on: .all)
    }

    /// A non-interactive overlay stack, masked to the selection indicator shape.
    /// Renders items in their selected color only within the indicator bounds.
    /// Rendered only when `indicatorConfig` is provided.
    @ViewBuilder
    var overlayItemsStack: some View {
        if let indicatorConfig {
            itemStack { item in
                BarItemOverlayView(
                    item: item,
                    isSelected: item.id == selected.id,
                    isVerticalCompact: isVerticalCompact,
                    config: config
                )
            }
            .adaptiveCoordinateSpace(name: coordinateSpaceName)
            .mask(alignment: .leading) {
                RoundedRectangle(cornerRadius: indicatorConfig.cornerRadius)
                    .frame(
                        width: max(0, indicatorFrame().width),
                        height: max(0, indicatorFrame().height)
                    )
                    .offset(x: indicatorFrame().minX)
            }
        }
    }

    /// A visual highlight that identifies the currently selected item.
    /// Rendered only when `indicatorConfig` is provided.
    @ViewBuilder
    var selectionIndicator: some View {
        if let indicatorConfig {
            RoundedRectangle(cornerRadius: indicatorConfig.cornerRadius)
                .fill(indicatorConfig.color)
                .overlay {
                    if let border = indicatorConfig.border {
                        RoundedRectangle(cornerRadius: indicatorConfig.cornerRadius)
                            .strokeBorder(border.color, lineWidth: border.lineWidth)
                    }
                }
                .frame(
                    width: max(0, selectedItemFrame.width - indicatorConfig.inset.leading - indicatorConfig.inset.trailing),
                    height: max(0, selectedItemFrame.height - indicatorConfig.inset.top - indicatorConfig.inset.bottom)
                )
                .scaleEffect(
                    x: isSelectionIndicatorScaling ? indicatorConfig.scaleEffect?.xScale ?? 1.0 : 1.0,
                    y: isSelectionIndicatorScaling ? indicatorConfig.scaleEffect?.yScale ?? 1.0 : 1.0,
                    anchor: .center
                )
                .offset(x: indicatorFrame().minX)
                .gesture(indicatorConfig.isDragGestureEnabled ? dragGesture : nil)
        }
    }
    
    /// The bar background rendered behind the items stack.
    @ViewBuilder
    var backgroundCapsule: some View {
        switch config.background {
        case let .color(color):
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .fill(color)
                .barShadow(config.shadow)
        case let .material(material, tint):
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .fill(material)
                .overlay { RoundedRectangle(cornerRadius: config.cornerRadius).fill(tint) }
                .barShadow(config.shadow)
        case let .customBlur(_, tint):
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .fill(.clear)
                .overlay { RoundedRectangle(cornerRadius: config.cornerRadius).fill(tint) }
                .barShadow(config.shadow)
        }
    }

    /// Builds a horizontal or vertical stack of items based on the bar axis.
    @ViewBuilder
    func itemStack<Content: View>(
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        switch config.axis {
        case .horizontal:
            HStack(alignment: .bottom, spacing: config.itemSpacing) {
                ForEach(items) { content($0) }
            }
        case .vertical:
            VStack(alignment: .center, spacing: config.itemSpacing) {
                ForEach(items) { content($0) }
            }
        }
    }
}

// MARK: - Gesture

private extension BarView {

    /// A gesture that tracks finger movement to reposition the selection indicator.
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named(coordinateSpaceName))
            .onChanged { value in
                isSelectionIndicatorScaling = true
                isDragging = true
                gestureXLocation = value.location.x
            }
            .onEnded { _ in
                isSelectionIndicatorScaling = true
                handleSelection(nearestItem(to: indicatorFrame()))
                isDragging = false
                gestureXLocation = nil
            }
    }
}

// MARK: - Actions

private extension BarView {

    /// Updates the selected item and triggers indicator transition and scale animations.
    func handleSelection(_ item: Item) {
        guard let indicatorConfig else {
            selected = item
            action?(item)
            return
        }
        
        let transitionAnimation = indicatorConfig.transitionAnimation
        let scaleEffect = indicatorConfig.scaleEffect

        let performSelection = {
            selected = item
            action?(item)
        }

        switch (transitionAnimation, scaleEffect) {
        case let (transition?, scale?):
            isSelectionIndicatorScaling = true
            withAnimation(transition) { performSelection() }
            DispatchQueue.main.asyncAfter(deadline: .now() + scale.duration) {
                withAnimation(scale.animation) { isSelectionIndicatorScaling = false }
            }

        case (let transition?, nil):
            withAnimation(transition) { performSelection() }

        case (nil, let scale?):
            isSelectionIndicatorScaling = true
            performSelection()
            DispatchQueue.main.asyncAfter(deadline: .now() + scale.duration) {
                withAnimation(scale.animation) { isSelectionIndicatorScaling = false }
            }

        default:
            performSelection()
        }
    }
}

// MARK: - Helpers

private extension BarView {
    
    /// Computes the current frame of the selection indicator, accounting for drag position.
    func indicatorFrame() -> CGRect {
        guard let indicatorConfig else { return .zero }
        
        let inset = indicatorConfig.inset
        let width = selectedItemFrame.width - inset.leading - inset.trailing
        let height = selectedItemFrame.height - inset.top - inset.bottom
        let minX: CGFloat

        if isDragging, let gestureXLocation {
            let raw = gestureXLocation - selectedItemFrame.width / 2 + inset.leading
            let minAllowed = inset.leading
            let maxAllowed = (selectedItemFrame.width + config.itemSpacing) * CGFloat(itemFrames.count - 1) + inset.leading
            minX = max(minAllowed, min(maxAllowed, raw))
        } else {
            minX = selectedItemFrame.minX + inset.leading
        }

        return CGRect(x: minX, y: selectedItemFrame.minY + inset.top, width: width, height: height)
    }

    /// Returns the item whose center is closest to the indicator's current center.
    /// Falls back to the current selection if `items` is empty.
    func nearestItem(to frame: CGRect) -> Item {
        items.min(by: {
            abs((itemFrames[$0.id]?.midX ?? 0) - frame.midX) <
            abs((itemFrames[$1.id]?.midX ?? 0) - frame.midX)
        }) ?? selected
    }
    
    /// Calculates the fixed bar height based on the baseline item style metrics and current size class.
    /// Returns `nil` if `baselineStyle` is not set, leaving height unconstrained.
    func barHeight() -> CGFloat? {
        guard let baselineStyle = config.baselineStyle,
              let itemConfig = config.itemStyles[baselineStyle] else { return nil }
        let insets = isVerticalCompact ? itemConfig.edgeInsetsCompact : itemConfig.edgeInsets
        return itemConfig.itemContentHeight(isVerticalCompact: isVerticalCompact) + insets.top + insets.bottom
    }
}

#if DEBUG

@available(iOS 17.0, *)
#Preview("Horizontal") {
    @Previewable @State var selected: PreviewBarItem = .init(title: "Home", icon: .system("house.fill"))

    let items: [PreviewBarItem] = [
        .init(title: "Home",    icon: .system("house.fill")),
        .init(title: "Search",  icon: .system("magnifyingglass")),
        .init(title: "Profile", icon: .system("person.fill")),
    ]

    ZStack(alignment: .bottom) {
        Color.indigo.ignoresSafeArea()
        BarView(items: items, selected: $selected, config: .init(
            axis: .horizontal,
            cornerRadius: 28,
            shadow: .init(),
            background: .material(.ultraThinMaterial),
            itemStyles: [.regular: .init()],
            itemSpacing: 0,
            itemStateAnimation: .easeInOut(duration: 0.2),
            barAccessibilityLabel: "Bar"
        ))
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
}

private struct PreviewBarItem: BarItemProtocol {
    let title: String
    let icon: BarIcon
    var style: BarItemStyle = .regular
    var id: AnyHashable { title }
}

#endif
