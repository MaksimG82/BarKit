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

    /// Namespace used for synchronized matched geometry transitions of the selection indicator.
    @Namespace private var tabBarNamespace

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
            Spacer()

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
                    .matchedGeometryEffect(id: item.id, in: tabBarNamespace)
                }
            }
            .adaptiveCoordinateSpace(name: coordinateSpaceName)
            .environment(\.tabBarSpaceName, coordinateSpaceName)
            .onPreferenceChange(TabItemFrameKey.self) { frames in
                itemFrames = frames
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(config.barAccessibilityLabel)
            .background {
                ZStack {
                    backgroundCapsule
                    selectionIndicator
                }
            }
            .simultaneousGesture(dragGesture)
            .padding(.leading, floatingConfig.leadingInset)
            .padding(.trailing, floatingConfig.trailingInset)
            .padding(.bottom, floatingConfig.bottomInset)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Subviews

private extension FloatingLayoutView {
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

    /// A visual highlight that identifies the currently selected tab, synchronized via matched geometry.
    var selectionIndicator: some View {
        RoundedRectangle(cornerRadius: floatingConfig.cornerRadius - 4)
            .fill(Color.secondary.opacity(0.2))
            .padding(2)
            .matchedGeometryEffect(id: selected.id, in: tabBarNamespace, isSource: false)
            .scaleEffect(
                x: isSelectionIndicatorScaling ? config.floatingConfig?.tabSelectionScaleEffect?.xScale ?? 1.0 : 1.0,
                y: isSelectionIndicatorScaling ? config.floatingConfig?.tabSelectionScaleEffect?.yScale ?? 1.0 : 1.0,
                anchor: .center
            )
    }
    
    /// A gesture that tracks finger movement to update the selection indicator position.
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isDragging = true
                gestureXLocation = value.location.x
            }
            .onEnded { _ in
                isDragging = false
                gestureXLocation = nil
            }
    }

    // MARK: - Actions
    
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

extension FloatingLayoutView {
    /// The dynamic name for the coordinate space.
    private var coordinateSpaceName: String {
        "FloatingLayoutView.\(layoutId.uuidString)"
    }
}

