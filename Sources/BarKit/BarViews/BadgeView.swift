//
//  BadgeView.swift
//  BarKit
//
//  Created by Maksim Gaisin on 28.05.26.
//

import SwiftUI

/// A badge overlay view displaying a dot, count, or label.
struct BadgeView: View {

    /// The content to display in the badge.
    let value: BadgeValue

    /// The visual configuration of the badge.
    let configuration: BadgeConfiguration

    var body: some View {
        content
            .offset(x: configuration.offsetX, y: configuration.offsetY)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var content: some View {
        switch value {
        case .dot:
            Circle()
                .fill(configuration.backgroundColor)
                .frame(width: configuration.dotDiameter, height: configuration.dotDiameter)
        case let .count(number):
            textBadge(Text("\(number)"))
        case let .label(value):
            textBadge(Text(value))
        }
    }

    // MARK: - Helpers

    /// Renders a styled text badge with background and padding.
    private func textBadge(_ text: Text) -> some View {
        text
            .font(.system(configuration.textStyle).bold())
            .foregroundStyle(configuration.foregroundColor)
            .padding(.horizontal, configuration.horizontalPadding)
            .padding(.vertical, configuration.verticalPadding)
            .fixedSize()
            .background(configuration.backgroundColor)
            .clipShape(Capsule())
    }
}
