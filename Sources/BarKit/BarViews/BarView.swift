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
    
    /// Indicates whether the indicator is currently in motion (drag or animated transition).
    @State private var isIndicatorMoving: Bool = false

    /// A dictionary mapping each item's unique identifier to its frame in the local coordinate space.
    @State private var itemFrames: [AnyHashable: CGRect] = [:]
    
    /// A dictionary mapping each item's unique identifier to its icon frame.
    @State private var itemIconFrames: [AnyHashable: CGRect] = [:]

    /// The current position of the user's finger during a drag gesture.
    @State private var gestureLocation: CGPoint? = nil

    /// Indicates whether the drag gesture is currently active.
    @State private var isDragging: Bool = false
    
    /// A unique identifier for the local coordinate space, stable across view re-renders.
    @State private var coordinateSpaceID = UUID()

    // MARK: - Properties

    /// An array of data models conforming to ``BarItemProtocol``.
    private let items: [Item]

    /// The configuration object defining the visual style, layout, and behavior of the bar.
    private let configuration: BarConfiguration
    
    /// A dictionary mapping item identifiers to their badge values.
    private let badges: [AnyHashable: BadgeValue]

    /// An optional identifier used as a key in the bar visibility dictionary.
    private let id: String?
    
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
    
    /// The maximum item width across all items, used for vertical bar calculations.
    private var maxItemWidth: CGFloat {
        itemFrames.values.map(\.width).max() ?? selectedItemFrame.width
    }

    /// The maximum item height across all items, used for horizontal bar calculations.
    private var maxItemHeight: CGFloat {
        itemFrames.values.map(\.height).max() ?? selectedItemFrame.height
    }

    // MARK: - Init

    /// Initializes a new `BarView`.
    ///
    /// - Parameters:
    ///   - items: An array of data models conforming to ``BarItemProtocol``.
    ///   - selected: A binding to the currently selected item.
    ///   - configuration: A configuration object defining the visual style of the bar.
    ///   - badges: A dictionary mapping item identifiers to their badge values.
    ///   - id: An optional identifier used as a key in the bar visibility dictionary.
    ///   - action: An optional closure executed when an item is tapped.

    public init(
        items: [Item],
        selected: Binding<Item>,
        configuration: BarConfiguration = .init(),
        badges: [AnyHashable: BadgeValue] = [:],
        id: String? = nil,
        action: ((Item) -> Void)? = nil,
    ) {
        self.items = items
        _selected = selected
        self.configuration = configuration
        self.badges = badges
        self.id = id
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        let indicatorFrame = indicatorFrame()
        ZStack(alignment: configuration.axis == .horizontal ? .leading : .top) {
            itemsStack
                .indicatorLens(configuration.indicator, frame: indicatorFrame, isActive: isIndicatorMoving)
            
            overlayItemsStack(indicatorFrame: indicatorFrame)
                .indicatorLens(configuration.indicator, frame: indicatorFrame, isActive: isIndicatorMoving)
            
            badgesStack
                .indicatorLens(configuration.indicator, frame: indicatorFrame, isActive: isIndicatorMoving)
        }
        .frame(
            height: barHeight(),
            alignment: .bottom
        )
        .background {
            backgroundCapsule
                .applyDebugVisuals(color: .green)
        }
        .overlay(alignment: configuration.axis == .horizontal ? .leading : .top) {
            selectionIndicator(frame: indicatorFrame)
        }
        .hapticFeedback(configuration.hapticFeedback, trigger: selected)
        .modifier(
            BarContainerAccessibilityModifier(
                label: configuration.barAccessibilityLabel,
                sortPriority: configuration.accessibilitySortPriority
            )
        )
    }
}

// MARK: - Subviews

private extension BarView {
    
    
    /// A layer rendering badge overlays positioned over item icons.
    @ViewBuilder
    var badgesStack: some View {
        ForEach(items) { item in
            if
                let badge = badges[item.id],
                let frame = itemIconFrames[item.id] {
                BadgeView(value: badge, configuration: configuration.badge)
                    .position(
                        x: frame.maxX + configuration.badge.offsetX,
                        y: frame.minY + configuration.badge.offsetY
                    )
            }
        }
        .frame(
            maxWidth: configuration.axis == .horizontal ? .infinity : maxItemWidth,
            maxHeight: configuration.axis == .vertical ? .infinity : maxItemHeight
        )
    }

    /// A stack of interactive bar items.
    var itemsStack: some View {
        itemStack() { item in
            BarItemView(
                item: item,
                isSelected: item.id == selected.id,
                isVerticalCompact: isVerticalCompact,
                configuration: configuration
            ) {
                handleSelection(item)
            }
        }
        .adaptiveCoordinateSpace(name: coordinateSpaceName)
        .environment(\.bkBarSpaceName, coordinateSpaceName)
        .onPreferenceChange(BarItemFrameKey.self) { itemFrames = $0 }
        .onPreferenceChange(BarIconFrameKey.self) { itemIconFrames = $0 }
        .defersSystemGestures(on: .all)
    }

    /// The bar background rendered behind the items stack.
    @ViewBuilder
    var backgroundCapsule: some View {
        switch configuration.background {
        case let .color(color):
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(color)
                .barShadow(configuration.shadow)
        case let .material(material, tint):
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(material.resolved)
                .overlay { RoundedRectangle(cornerRadius: configuration.cornerRadius).fill(tint) }
                .barShadow(configuration.shadow)
        case let .customBlur(_, tint):
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(.clear)
                .overlay { RoundedRectangle(cornerRadius: configuration.cornerRadius).fill(tint) }
                .barShadow(configuration.shadow)
        }
    }
    
    /// A non-interactive overlay stack, masked to the selection indicator shape.
    /// Renders items in their selected color only within the indicator bounds.
    /// Rendered only when `indicatorConfig` is provided.
    @ViewBuilder
    func overlayItemsStack(indicatorFrame: CGRect) -> some View {
        if let indicatorConfiguration = configuration.indicator {
            itemStack { item in
                BarItemOverlayView(
                    item: item,
                    isSelected: item.id == selected.id,
                    isVerticalCompact: isVerticalCompact,
                    configuration: configuration
                )
            }
            .adaptiveCoordinateSpace(name: coordinateSpaceName)
            .accessibilityHidden(true)
            .mask(alignment: configuration.axis == .horizontal ? .leading : .top) {
                RoundedRectangle(cornerRadius: indicatorConfiguration.cornerRadius)
                    .frame(
                        width: max(0, indicatorFrame.width),
                        height: max(0, indicatorFrame.height)
                    )
                    .offset(
                        x: configuration.axis == .horizontal ? indicatorFrame.minX : 0,
                        y: configuration.axis == .vertical ? indicatorFrame.minY : 0
                    )
            }
        }
    }

    /// A visual highlight that identifies the currently selected item.
    /// Rendered only when `indicatorConfig` is provided.
    @ViewBuilder
    func selectionIndicator(frame: CGRect) -> some View {
        if let indicatorConfiguration = configuration.indicator {
            RoundedRectangle(cornerRadius: indicatorConfiguration.cornerRadius)
                .fill(indicatorConfiguration.color)
                .overlay {
                    if let border = indicatorConfiguration.border {
                        RoundedRectangle(cornerRadius: indicatorConfiguration.cornerRadius)
                            .strokeBorder(border.color, lineWidth: border.lineWidth)
                    }
                }
                .frame(
                    width: max(0, frame.width),
                    height: max(0, frame.height)
                )
                .scaleEffect(
                    x: isSelectionIndicatorScaling ? indicatorConfiguration.scaleEffect?.xScale ?? 1.0 : 1.0,
                    y: isSelectionIndicatorScaling ? indicatorConfiguration.scaleEffect?.yScale ?? 1.0 : 1.0,
                    anchor: .center
                )
                .offset(
                    x: configuration.axis == .horizontal ? frame.minX : 0,
                    y: configuration.axis == .vertical ? frame.minY : 0
                )
                .gesture(indicatorConfiguration.isDragGestureEnabled ? dragGesture : nil)
        }
    }

    /// Builds a horizontal or vertical stack of items based on the bar axis.
    @ViewBuilder
    func itemStack<Content: View>(
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        switch configuration.axis {
        case .horizontal:
            HStack(alignment: configuration.itemAlignment.vertical, spacing: configuration.itemSpacing) {
                ForEach(items) { content($0) }
            }
        case .vertical:
            VStack(alignment: configuration.itemAlignment.horizontal, spacing: configuration.itemSpacing) {
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
                isIndicatorMoving = true
                isDragging = true
                gestureLocation = value.location
            }
            .onEnded { _ in
                handleSelection(nearestItem(to: indicatorFrame()))
                isDragging = false
                gestureLocation = nil
            }
    }
}

// MARK: - Actions

private extension BarView {

    /// Updates the selected item and triggers indicator transition and scale animations.
    func handleSelection(_ item: Item) {
        guard let indicatorConfiguration = configuration.indicator else {
            selected = item
            action?(item)
            return
        }
        
        let transitionAnimation = indicatorConfiguration.resolvedTransitionAnimation
        let scaleEffect = indicatorConfiguration.scaleEffect

        let performSelection = {
            selected = item
            action?(item)
        }

        let stopMoving = {
            withAnimation(nil) { isIndicatorMoving = false }
        }

        switch (transitionAnimation, scaleEffect) {
        case let (transition?, scaleEffect?):
            isSelectionIndicatorScaling = true
            isIndicatorMoving = true
            withAnimation(transition) { performSelection() }
            scheduleIndicatorReset(
                after: scaleEffect.duration,
                scaleEffect: scaleEffect
            )

        case (let transition?, nil):
            isIndicatorMoving = true
            withAnimation(transition) { performSelection() }
            let duration: Double
            if case .parameters(let params) = indicatorConfiguration.transitionAnimation {
                duration = params.duration
            } else {
                duration = 0
            }
            scheduleIndicatorReset(after: duration, scaleEffect: nil)
        
        case (nil, let scaleEffect?):
            isSelectionIndicatorScaling = true
            isIndicatorMoving = true
            performSelection()
            scheduleIndicatorReset(
                after: scaleEffect.duration,
                scaleEffect: scaleEffect
            )
            
        default:
            performSelection()
        }
    }
}

// MARK: - Helpers

private extension BarView {
    
    /// Computes the current offset of the selection indicator, accounting for drag position and layout axis.
    func indicatorOffset() -> CGPoint {
        guard let indicatorConfiguration = configuration.indicator else { return .zero }

        let inset = indicatorConfiguration.inset

        switch configuration.axis {
        case .horizontal:
            let minX: CGFloat
            if isDragging, let gestureLocation {
                let raw = gestureLocation.x - selectedItemFrame.width / 2 + inset.leading
                let minAllowed = inset.leading
                let maxAllowed = (selectedItemFrame.width + configuration.itemSpacing) * CGFloat(itemFrames.count - 1) + inset.leading
                minX = max(minAllowed, min(maxAllowed, raw))
            } else {
                minX = selectedItemFrame.minX + inset.leading
            }
            return CGPoint(x: minX, y: 0)

        case .vertical:
            let minY: CGFloat
            if isDragging, let gestureLocation {
                let raw = gestureLocation.y - selectedItemFrame.height / 2 + inset.top
                let minAllowed = inset.top
                let maxAllowed = (selectedItemFrame.height + configuration.itemSpacing) * CGFloat(itemFrames.count - 1) + inset.top
                minY = max(minAllowed, min(maxAllowed, raw))
            } else {
                minY = selectedItemFrame.minY + inset.top
            }
            return CGPoint(x: 0, y: minY)
        }
    }

    /// Computes the current frame of the selection indicator.
    func indicatorFrame() -> CGRect {
        guard let indicatorConfiguration = configuration.indicator else { return .zero }

        let inset = indicatorConfiguration.inset
        let offset = indicatorOffset()

        let width: CGFloat
        let height: CGFloat

        switch configuration.axis {
        case .horizontal:
            width = selectedItemFrame.width - inset.leading - inset.trailing
            height = selectedItemFrame.height - inset.top - inset.bottom
        case .vertical:
            width = maxItemWidth - inset.leading - inset.trailing
            height = selectedItemFrame.height - inset.top - inset.bottom
        }

        return CGRect(x: offset.x, y: offset.y, width: width, height: height)
    }
    
    /// Returns the item whose center is closest to the indicator's current center.
    /// Falls back to the current selection if `items` is empty.
    func nearestItem(to frame: CGRect) -> Item {
        items.min(by: {
            switch configuration.axis {
            case .horizontal:
                abs((itemFrames[$0.id]?.midX ?? 0) - frame.midX) <
                abs((itemFrames[$1.id]?.midX ?? 0) - frame.midX)
            case .vertical:
                abs((itemFrames[$0.id]?.midY ?? 0) - frame.midY) <
                abs((itemFrames[$1.id]?.midY ?? 0) - frame.midY)
            }
        }) ?? selected
    }
    
    /// Constrains the bar's primary-axis dimension when items of mixed styles are present
    /// and the bar height should be based on a specific baseline style — not the tallest item.
    /// This allows prominent items (e.g. a raised center tab) to overflow beyond the bar bounds.
    ///
    /// Returns `nil` in the common case where all items share the same style,
    /// letting SwiftUI size the bar naturally from its content.
    ///
    /// - Note: Currently only meaningful for horizontal bars with a prominent center item.
    ///   For vertical bars, width is determined by item content — no equivalent is needed.
    func barHeight() -> CGFloat? {
        guard let baselineStyle = configuration.baselineStyle,
              let itemconfiguration = configuration.itemStyles[baselineStyle] else { return nil }
        let insets = isVerticalCompact ? itemconfiguration.edgeInsetsCompact : itemconfiguration.edgeInsets
        return itemconfiguration.itemContentHeight(isVerticalCompact: isVerticalCompact) + insets.top + insets.bottom
    }
    
    /// Schedules a reset of indicator animation states after a given duration.
    private func scheduleIndicatorReset(
        after duration: Double,
        scaleEffect: SelectionScaleEffect?
    ) {
        Task {
            try? await Task.sleep(for: .seconds(duration))
            await MainActor.run {
                if let scaleEffect {
                    withAnimation(scaleEffect.resolvedAnimation) { isSelectionIndicatorScaling = false }
                }
                withAnimation(nil) { isIndicatorMoving = false }
            }
        }
    }
}

#if DEBUG

@available(iOS 17.0, *)
#Preview("BarView - Horizontal") {
    @Previewable @State var selected: PreviewBarItem = .init(title: "Home", icon: .system("house.fill"))
    @Previewable @State var selectedTab: Int = 0
    @Previewable @State var badges: [AnyHashable: BadgeValue] = [
        "Home": .count(333),
        "Search": .dot,
        "Profile": .label("New")
    ]

    let items: [PreviewBarItem] = [
        .init(title: "Home",    icon: .system("house.fill")),
        .init(title: "Search",  icon: .system("magnifyingglass")),
        .init(title: "Profile", icon: .system("person.fill")),
    ]

    VStack(spacing: 0) {
        ZStack(alignment: .bottom) {
            Color.indigo.ignoresSafeArea()
            BarView(
                items: items,
                selected: $selected,
                configuration: .init(
                    axis: .horizontal,
                    cornerRadius: 28,
                    shadow: .init(),
                    background: .material(.ultraThin),
                    itemStyles: [.regular: .init()],
                    itemSpacing: 0,
                    itemStateAnimation: .custom(.easeInOut(duration: 0.2)),
                    barAccessibilityLabel: "Bar"
                ),
                badges: badges
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }
}

@available(iOS 17.0, *)
#Preview("BarView - Vertical") {
    @Previewable @State var selected: PreviewBarItem = .init(title: "Home", icon: .system("house.fill"))
    @Previewable @State var badges: [AnyHashable: BadgeValue] = [
        "Home": .count(333),
        "Search": .dot,
        "Profile": .label("New")
    ]

    let items: [PreviewBarItem] = [
        .init(title: "Home",    icon: .system("house.fill")),
        .init(title: "Search",  icon: .system("magnifyingglass")),
        .init(title: "Profile", icon: .system("person.fill")),
    ]

    ZStack(alignment: .topLeading) {
        Color.indigo.ignoresSafeArea()
        BarView(
            items: items,
            selected: $selected,
            configuration: .init(
                axis: .vertical,
                cornerRadius: 28,
                shadow: .init(),
                background: .material(.ultraThin),
                itemStyles: [.regular: .init()],
                itemSpacing: 0,
                itemStateAnimation: .custom(.easeInOut(duration: 0.2)),
                barAccessibilityLabel: "Bar"
            ),
            badges: badges
        )
        .fixedSize(horizontal: false, vertical: true)
        .padding(.leading, 16)
        
    }
}

private struct PreviewBarItem: BarItemProtocol {
    let title: String
    let icon: BarIcon
    var style: BarItemStyle = .regular
    var id: String { title }
}

#endif
