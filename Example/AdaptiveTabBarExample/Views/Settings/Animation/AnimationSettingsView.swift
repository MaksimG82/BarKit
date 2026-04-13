//
//  AnimationSettingsView.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 12.03.26.
//

import AdaptiveTabBar
import SwiftUI

struct AnimationSettingsView: View {
    @Environment(\.tabBarHeight) var tabBarHeight

    var viewModel: ExampleViewModel

    // MARK: - State

    @State private var itemAnimationParameters = AnimationParameters(type: .easeIn, duration: 0.3)
    @State private var indicatorTransitionAnimationParameters = AnimationParameters(type: .linear)
    @State private var indicatorScalingAnimationParameters = AnimationParameters.defaultWithScaleSettings()

    // MARK: - Body

    var body: some View {
        List {
            AnimationSettingsSectionView(
                parameters: $itemAnimationParameters,
                headerText: "Tab item animation",
                footerText: "The animation applied to internal elements (icon and title) during selection changes."
            )
            .onChange(of: itemAnimationParameters) { updateItemAnimation() }
            
            AnimationSettingsSectionView(
                parameters: $indicatorTransitionAnimationParameters,
                headerText: "Selection indicator transition animation",
                footerText: "Animation for moving the indicator between tabs."
            )
            .onChange(of: indicatorTransitionAnimationParameters) { updateIndicatorTransitionAnimation() }
            
            AnimationSettingsSectionView(
                parameters: $indicatorScalingAnimationParameters,
                headerText: "Selection indicator scaling animation",
                footerText: "Animation of the scaling effect for the selection indicator during tab transitions."
            )
            .onChange(of: indicatorScalingAnimationParameters) { updateScaleAnimation() }
            
            
        }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: tabBarHeight) }
        .navigationTitle("Animation")
        .toolbar { resetButton }
    }
}

// MARK: - View Components

private extension AnimationSettingsView {
    var resetButton: some View {
        Button("Reset animations") {
            let defaultState = TabBarConfiguration()
            viewModel.send(.updateTabItem(defaultState.tabItemAnimation))
            viewModel.send(.updateIndcatorTransition(defaultState.floatingConfig?.indicatorTransitionAnimation))
        }
    }
}

// MARK: - Actions

private extension AnimationSettingsView {
    func updateItemAnimation() {
        viewModel.send(
            .updateTabItem(
                itemAnimationParameters.makeAnimation()
            )
        )
    }
    
    func updateIndicatorTransitionAnimation() {
        viewModel.send(
            .updateIndcatorTransition(
                indicatorTransitionAnimationParameters.makeAnimation()
            )
        )
    }
    
    func updateScaleAnimation() {
        viewModel.send(.updateIndicator(indicatorScalingAnimationParameters.makeScaleEffect()))
    }
}

#Preview {
    @Previewable @State var viewModel = ExampleViewModel()
    NavigationStack {
        ZStack(alignment: .bottom) {
            AnimationSettingsView(viewModel: viewModel)

            TabBarView(
                items: viewModel.state.items,
                selected: .constant(viewModel.state.items[0]),
                config: viewModel.state.config
            )
            .overlay(Divider(), alignment: .top)
        }
    }
}
