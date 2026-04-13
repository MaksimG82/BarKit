//
//  TabBarView.swift
//  AdaptiveTabBar
//
//  Created by Maksim Gaisin on 10.01.26.
//

import SwiftUI

/// A customizable, adaptive tab bar view that supports regular and prominent items.
///
/// `TabBarView` automatically switches between vertical and horizontal layouts
/// based on the device orientation (size class) and applies styles defined in `TabBarConfiguration`.
///
/// - Note: The view expects an array of items conforming to ``TabBarItemProtocol``.
public struct TabBarView<Item: TabBarItemProtocol>: View {
    // MARK: - Property Wrappers

    /// Detects current vertical size class to toggle between compact and regular layouts.
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// The currently selected tab item.
    @Binding private var selected: Item

    // MARK: - Properties

    /// An array of data models conforming to ``TabBarItemProtocol``.
    private let items: [Item]

    /// A binding to the current selection.
    private let config: TabBarConfiguration

    /// An optional closure executed when a tab is tapped (even if already selected).
    private let action: ((Item) -> Void)?

    // MARK: - Init

    /// Initializes a new `TabBarView`.
    ///
    /// - Parameters:
    ///   - items: An array of data models conforming to ``TabBarItemProtocol``.
    ///   - selected: A binding to the current selection.
    ///   - action: An optional closure executed when a tab is tapped (even if already selected).
    ///   - config: A configuration object defining the visual style.
    public init(
        items: [Item],
        selected: Binding<Item>,
        action: ((Item) -> Void)? = nil,
        config: TabBarConfiguration = .init()
    ) {
        self.items = items
        _selected = selected
        self.action = action
        self.config = config
    }

    // MARK: - Body

    public var body: some View {
        switch config.style {
        case .pinned:
            PinnedLayoutView(selected: $selected, items: items, config: config, action: action)
        case let .floating(floatingConfig):
            FloatingLayoutView(selected: $selected, items: items, config: config, action: action)
        }
    }
}

#if DEBUG
    /// Data model used for Xcode Previews.
    private struct PreviewTabItem: TabBarItemProtocol {
        let title: String
        var icon: TabBarIcon
        var style: TabItemStyle
        var id: AnyHashable {
            title.hashValue
        }

        func withStyle(_ newStyle: TabItemStyle) -> PreviewTabItem {
            .init(title: title, icon: icon, style: newStyle)
        }
    }

    @available(iOS 17.0, *)
    #Preview("Pinned style") {
        @Previewable @State var selected: PreviewTabItem = .init(
            title: "Camera",
            icon: .system("camera.viewfinder"),
            style: .prominent
        )

        let mockItems: [PreviewTabItem] = [
            .init(title: "Settings", icon: .system("gearshape"), style: .regular),
            .init(title: "Camera", icon: .system("camera.viewfinder"), style: .prominent),
            .init(title: "Photos", icon: .system("photo.on.rectangle"), style: .regular)
        ]

        VStack {
            Spacer()
            TabBarView(items: mockItems, selected: $selected)
                .environment(\.debugLayoutEnabled, true)
        }
    }

    @available(iOS 17.0, *)
    #Preview("Floating style") {
        @Previewable @State var selected: PreviewTabItem = .init(
            title: "Camera",
            icon: .system("camera.viewfinder"),
            style: .prominent
        )

        let mockItems: [PreviewTabItem] = [
            .init(title: "Settings", icon: .system("gearshape.fill"), style: .regular),
            .init(title: "Camera", icon: .system("camera.fill"), style: .prominent),
            .init(title: "Photos", icon: .system("photo.on.rectangle.fill"), style: .regular)
        ]

        VStack {
            Spacer()
            TabBarView(
                items: mockItems,
                selected: $selected,
                config: .init(style: .floating(.init()))
            )
            .environment(\.debugLayoutEnabled, false)
        }
    }

#endif
