//
//  FloatingLayoutView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 16.03.26.
//

import SwiftUI

/// A floating tab bar layout designed to replicate the "Liquid Glass" aesthetic.
///
/// It renders items within a detached, blurred capsule that adapts its content
/// to maintain a balanced, lightweight appearance.
struct FloatingLayoutView<Item: TabBarItemProtocol>: View {
    
    // MARK: - Property Wrappers

    /// Detects current vertical size class to toggle between compact and regular layouts.
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// The currently selected tab item.
    @Binding private var selected: Item

    /// Flag indicating whether the indicator is currently in its scaling animation state.
    @State private var isSelectionIndicatorScaling = false
    
    /// A dictionary mapping each tab item's unique identifier to its frame in the local coordinate space.
    @State private var itemFrames: [AnyHashable: CGRect] = [:]
    
    /// The current horizontal position of the user's finger during a drag gesture.
    @State private var gestureXLocation: CGFloat? = nil

    /// A Boolean value that indicates whether the drag gesture is currently active.
    @State private var isDragging: Bool = false

    // MARK: - Properties

    /// An array of data models conforming to ``TabBarItemProtocol``.
    private let items: [Item]

    /// A binding to the current selection.
    private let config: TabBarConfiguration

    /// An optional closure executed when a tab is tapped (even if already selected).
    private let action: ((Item) -> Void)?
    
    /// /// Unique identifier of view instance.
    private let layoutId = UUID()

    // MARK: - Computed Properties

    /// Layout settings specific to the floating bar style.
    private var floatingConfig: FloatingConfiguration {
        config.floatingConfig ?? .init()
    }

    /// Returns true if the layout is in a vertically constrained environment.
    private var isVerticalCompact: Bool {
        verticalSizeClass == .compact
    }
    
    /// The frame of the currently selected tab item in the local coordinate space.
    /// Guaranteed to be non-nil in practice, as `itemFrames` is populated before
    /// any gesture interaction is possible. Falls back to `.zero` as a safety net.
    private var selectedItemFrame: CGRect {
        itemFrames[selected.id] ?? .zero
    }
    
    /// The dynamic name for the coordinate space.
    private var coordinateSpaceName: String {
        "FloatingLayoutView"
    }

    // MARK: - Init

    // Initializes a new `FloatingLayoutView`.
    //
    // - Parameters:
    //   - selected: A binding to the current selection.
    //   - items: An array of data models conforming to ``TabBarItemProtocol``.
    //   - config: A configuration object defining the visual style.
    //   - shouldAdaptProminentItems: A flag that determines whether items with a `.prominent` style should be automatically converted to `.regular` for a more consistent look within the floating bar.
    //   - action: An optional closure executed when a tab is tapped (even if already selected).

    init(
        selected: Binding<Item>,
        items: [Item],
        config: TabBarConfiguration,
        shouldAdaptProminentItems: Bool = true,
        action: ((Item) -> Void)? = nil
    ) {
        _selected = selected
        self.config = config
        self.action = action

        if shouldAdaptProminentItems, items.contains(where: { $0.style == .prominent }) {
            #if DEBUG
                print("⚠️ TabBarView: Prominent items detected and adapted to .regular for FloatingLayout.")
            #endif
            self.items = items.map { item in
                item.style == .prominent ? item.withStyle(.regular) : item
            }
        } else {
            self.items = items
        }
    }

    // MARK: - Body

    var body: some View {
        VStack {
            
            ZStack(alignment: .leading) {
                tabItemsStack
                    .indicatorLensEffect(
                    frame: indicatorFrame(),
                    cornerRadius: floatingConfig.indicatorCornerRadius,
                    refractionZoneWidth: 12.0,
                    aberrationZoneWidth: 8.0,
                    aberrationStrength: 4.0,
                    refractionStrength: 2.0
                )
                
                overlayItemsStack
                    .indicatorLensEffect(
                        frame: indicatorFrame(),
                        cornerRadius: floatingConfig.indicatorCornerRadius,
                        refractionZoneWidth: 12.0,
                        aberrationZoneWidth: 8.0,
                        aberrationStrength: 4.0,
                        refractionStrength: 2.0
                    )
                
                selectionIndicator
            }
            .background { backgroundCapsule }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(config.barAccessibilityLabel)
            .padding(.leading, floatingConfig.leadingInset)
            .padding(.trailing, floatingConfig.trailingInset)
            .padding(.bottom, floatingConfig.bottomInset)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Subviews

private extension FloatingLayoutView {
    
    /// A horizontal stack of interactive tab items.
    private var tabItemsStack: some View {
        HStack(alignment: .bottom, spacing: config.tabSpacing) {
            ForEach(items) { item in
                TabItemView(
                    item: item,
                    isSelected: item.id == selected.id,
                    isVerticalCompact: isVerticalCompact,
                    config: config
                ) {
                    handleSelection(item)
                }
            }
        }
        .adaptiveCoordinateSpace(name: coordinateSpaceName)
        .environment(\.tabBarSpaceName, coordinateSpaceName)
        .onPreferenceChange(TabItemFrameKey.self) { frames in
            itemFrames = frames
        }
        .defersSystemGestures(on: .all)
    }
    
    
    /// A background view consisting of a solid color and an optional blur material, styled with a shadow.
    var backgroundCapsule: some View {
        RoundedRectangle(cornerRadius: floatingConfig.cornerRadius)
            .fill(config.backgroundColor)
            .background {
                if let material = config.backgroundMaterial {
                    RoundedRectangle(cornerRadius: floatingConfig.cornerRadius)
                        .fill(material)
                }
            }
            .shadow(radius: floatingConfig.shadowRadius)
    }
    
    /// A visual highlight that identifies the currently selected tab.
    var selectionIndicator: some View {
        RoundedRectangle(cornerRadius: floatingConfig.indicatorCornerRadius)
            .fill(Color.secondary.opacity(0.2))
            .frame(
                width: max(0, selectedItemFrame.width - floatingConfig.indicatorPadding * 2),
                height: max(0, selectedItemFrame.height - floatingConfig.indicatorPadding * 2)
            )
            .scaleEffect(
                x: isSelectionIndicatorScaling ? config.floatingConfig?.tabSelectionScaleEffect?.xScale ?? 1.0 : 1.0,
                y: isSelectionIndicatorScaling ? config.floatingConfig?.tabSelectionScaleEffect?.yScale ?? 1.0 : 1.0,
                anchor: .center
            )
            .offset(x: indicatorFrame().minX)
            .gesture(dragGesture)
    }
    
    /// A horizontal stack of non-interactive overlay items, clipped to the indicator shape.
    /// Renders tab icons and titles in the active color only within the selection indicator bounds.
    private var overlayItemsStack: some View {
        HStack(alignment: .bottom, spacing: config.tabSpacing) {
            ForEach(items) { item in
                TabItemOverlayView(
                    item: item,
                    isSelected: item.id == selected.id,
                    isVerticalCompact: isVerticalCompact,
                    itemColor: config.floatingConfig?.activeItemColor ?? .blue,
                    config: config
                )
            }
        }
        .adaptiveCoordinateSpace(name: coordinateSpaceName)
        .mask(alignment: .leading) {
            RoundedRectangle(cornerRadius: floatingConfig.indicatorCornerRadius)
                .frame(
                    width: max(0, indicatorFrame().width),
                    height: max(0, indicatorFrame().height)
                )
                .offset(x: indicatorFrame().minX)
        }
    }
}

// MARK: - Gesture

private extension FloatingLayoutView {
    /// A gesture that tracks finger movement to update the selection indicator position.
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance:  0, coordinateSpace: .named(coordinateSpaceName))
            .onChanged { value in
                isSelectionIndicatorScaling = true
                isDragging = true
                gestureXLocation = value.location.x
            }
            .onEnded { value in
                isSelectionIndicatorScaling = true
                handleSelection(nearestItem(to: indicatorFrame()))
                isDragging = false
                gestureXLocation = nil
            }
    }
}

    // MARK: - Actions

private extension FloatingLayoutView {
    
    /// Updates the selected tab and triggers the associated haptic feedback and animations.
    func handleSelection(_ item: Item) {
        let transitionAnimation = config.floatingConfig?.indicatorTransitionAnimation
        let scaleEffect = config.floatingConfig?.tabSelectionScaleEffect
        
        let performSelectionBlock = {
            selected = item
            action?(item)
        }
        
        switch (transitionAnimation, scaleEffect) {
        case let (transitionAnimation?, scaleEffect?):
            isSelectionIndicatorScaling = true
            withAnimation(transitionAnimation) { performSelectionBlock() }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + scaleEffect.duration) {
                withAnimation(scaleEffect.animation) { isSelectionIndicatorScaling = false }
            }
            
        case (let transitionAnimation?, nil):
            withAnimation(transitionAnimation) { performSelectionBlock() }
            
        case (nil, let scaleEffect?):
            isSelectionIndicatorScaling = true
            performSelectionBlock()
            DispatchQueue.main.asyncAfter(deadline: .now() + scaleEffect.duration) {
                withAnimation(scaleEffect.animation) { isSelectionIndicatorScaling = false }
            }
            
        default:
            performSelectionBlock()
        }
    }
}
    // MARK: - Helpers

private extension FloatingLayoutView {
    
    /// Computes the frame of the selection indicator.
    /// - Returns: The frame for the indicator, clamped to the tab bar bounds.
    private func indicatorFrame() -> CGRect {
        let padding = floatingConfig.indicatorPadding
        let width = selectedItemFrame.width - padding * 2
        let height = selectedItemFrame.height - padding * 2
        let minX: CGFloat
        
        if isDragging, let gestureXLocation {
            let raw = gestureXLocation - selectedItemFrame.width / 2 + padding
            let minAllowed = padding
            let maxAllowed = (selectedItemFrame.width + config.tabSpacing) * CGFloat(itemFrames.count - 1) + padding
            minX = max(minAllowed, min(maxAllowed, raw))
        } else {
            minX = selectedItemFrame.minX + padding
        }
        
        return CGRect(x: minX, y: selectedItemFrame.minY + padding, width: width, height: height)
    }
    
    /// Returns the item whose center is closest to the indicator's center.
    /// Falls back to the current selection if `items` is empty, which is not expected in practice.
    /// - Parameter indicatorFrame: The current frame of the selection indicator.
    private func nearestItem(to indicatorFrame: CGRect) -> Item {
        items.min(by: {
            abs((itemFrames[$0.id]?.midX ?? 0) - indicatorFrame.midX) <
                abs((itemFrames[$1.id]?.midX ?? 0) - indicatorFrame.midX)
        }) ?? selected
    }
}

    // MARK: - Effects
private extension FloatingLayoutView {
    
    /// Returns the configured lens distortion and chromatic aberration effect for the current indicator frame.
    private func lensEffect() -> some View {
        indicatorLensEffect(
            frame: indicatorFrame(),
            cornerRadius: floatingConfig.indicatorCornerRadius,
            refractionZoneWidth: floatingConfig.refractionZoneWidth,
            aberrationZoneWidth: floatingConfig.aberrationZoneWidth,
            aberrationStrength: floatingConfig.aberrationStrength,
            refractionStrength: floatingConfig.refractionStrength
        )
    }
}

