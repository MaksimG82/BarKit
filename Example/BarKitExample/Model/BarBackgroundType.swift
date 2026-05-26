//
//  BarBackgroundType.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 15.05.26.
//

/// Represents the available background style options for a bar,
/// used to populate the background type picker in the Tab Bar settings screen.
enum BarBackgroundType: String, CaseIterable {
    case color      = "Color"
    case material   = "Material"
    case customBlur = "Custom Blur"
}
