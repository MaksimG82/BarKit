//
//  BarKitExampleTests.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 23.05.26.
//

import Testing
import SwiftUI
import BarKit
import BarKitExample

@Suite("BarConfiguration initString")
struct BarConfigurationInitStringTests {

    
    @Test func testDefault() {
        let configuration = BarConfiguration()
        #expect(configuration.initString == ".init()")
    }
    
    @Test func testNilParams() {
        let configuration = BarConfiguration(shadow: nil, indicator: nil)
        #expect(configuration.initString == ".init(shadow: nil, indicator: nil)")
    }
    
    @Test func testShadowBlackColor() {
        let configuration = BarConfiguration(shadow: .init(color: Color.black))
        #expect(configuration.initString == ".init(shadow: .init(color: Color(red: 0.0, green: 0.0, blue: 0.0)))")
    }
    
    @Test func testShadowBlackColorWithOpacity() {
        let configuration = BarConfiguration(shadow: .init(color: .black.opacity(0.5)))
        #expect(configuration.initString == ".init(shadow: .init(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.5)))")
    }
    
    @Test func testItemStateAnimationSpring() {
        let configuration = BarConfiguration(itemStateAnimation: .parameters(.init(type: .spring, duration: 0.4)))
        #expect(configuration.initString == ".init(itemStateAnimation: .parameters(.spring(duration: 0.4, bounce: 0.0)))")
    }

    @Test func testBackgroundMaterialThin() {
        let configuration = BarConfiguration(background: .material(.thin))
        #expect(configuration.initString == ".init(background: .material(.thin))")
    }
    
    @Test func testItemStylesCustom() {
        let custom = BarItemStyle(identifier: "custom")
        let configuration = BarConfiguration(itemStyles: [custom: .init(iconSideLength: 32)])
        #expect(configuration.initString == ".init(itemStyles: [BarItemStyle(identifier: \"custom\"): .init(iconSideLength: 32.0)])")
    }
    
    @Test func testFullConfiguration() {
        let custom = BarItemStyle(identifier: "custom")
        let configuration = BarConfiguration(
            axis: .vertical,
            cornerRadius: 16,
            shadow: .init(
                color: .black,
                radius: 4,
                x: 2,
                y: 2
            ),
            background: .color(.black),
            itemStyles: [custom: .init(
                selectedColor: Color(red: 1, green: 0, blue: 0),
                unselectedColor: Color(red: 0, green: 1, blue: 0),
                textStyle: .headline,
                iconSideLength: 32,
                selectedIconScale: 1.3,
                compactIconScale: 0.9,
                iconTitleSpacing: 8,
                edgeInsets: .init(top: 12, leading: 12, bottom: 12, trailing: 12),
                edgeInsetsCompact: .init(top: 6, leading: 6, bottom: 6, trailing: 6)
            )],
            itemContentAxis: .horizontal,
            itemContentAlignment: .start,
            itemAlignment: .start,
            itemSpacing: 8,
            itemStateAnimation: .parameters(.init(type: .linear, duration: 0.3)),
            baselineStyle: .prominent,
            indicator: .init(
                color: Color(red: 1, green: 0, blue: 0, opacity: 0.5),
                border: .init(
                    color: Color(red: 1, green: 1, blue: 0),
                    lineWidth: 2
                ),
                inset: .init(top: 4, leading: 4, bottom: 4, trailing: 4),
                cornerRadius: 12,
                transitionAnimation: .parameters(.init(type: .spring, duration: 0.4, bounce: 0.2)),
                scaleEffect: .init(
                    scalingAnimation: .parameters(.init(type: .easeOut, duration: 0.2)),
                    xScale: 1.4,
                    yScale: 1.3,
                    duration: 0.3
                ),
                isDragGestureEnabled: false,
                effects: [
                    .lensDistortion(.init(zoneWidth: 8, strength: 3)),
                    .chromaticAberration(.init(zoneWidth: 6, strength: 2))
                ]
            ),
            barAccessibilityLabel: "Custom Bar",
            hapticFeedback: .impact,
            accessibilitySortPriority: -1
        )

        #expect(configuration.initString == ".init(axis: .vertical, cornerRadius: 16.0, shadow: .init(color: Color(red: 0.0, green: 0.0, blue: 0.0), radius: 4.0, x: 2.0, y: 2.0), background: .color(Color(red: 0.0, green: 0.0, blue: 0.0)), itemStyles: [BarItemStyle(identifier: \"custom\"): .init(selectedColor: Color(red: 1.0, green: 0.0, blue: 0.0), unselectedColor: Color(red: 0.0, green: 1.0, blue: 0.0), textStyle: .headline, iconSideLength: 32.0, selectedIconScale: 1.3, compactIconScale: 0.9, iconTitleSpacing: 8.0, edgeInsets: .init(top: 12.0, leading: 12.0, bottom: 12.0, trailing: 12.0), edgeInsetsCompact: .init(top: 6.0, leading: 6.0, bottom: 6.0, trailing: 6.0))], itemContentAxis: .horizontal, itemContentAlignment: .start, itemAlignment: .start, itemSpacing: 8.0, itemStateAnimation: .parameters(.linear(duration: 0.3)), baselineStyle: .prominent, indicator: .init(color: Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.5), border: .init(color: Color(red: 1.0, green: 1.0, blue: 0.0), lineWidth: 2.0), inset: .init(top: 4.0, leading: 4.0, bottom: 4.0, trailing: 4.0), cornerRadius: 12.0, transitionAnimation: .spring(duration: 0.4, bounce: 0.2), scaleEffect: .init(scalingAnimation: .easeOut(duration: 0.2), xScale: 1.4, yScale: 1.3, duration: 0.3), isDragGestureEnabled: false, effects: [.lensDistortion(.init(zoneWidth: 8.0, strength: 3.0)), .chromaticAberration(.init(zoneWidth: 6.0, strength: 2.0))]), barAccessibilityLabel: \"Custom Bar\", hapticFeedback: .impact, accessibilitySortPriority: -1.0)")    }
}
