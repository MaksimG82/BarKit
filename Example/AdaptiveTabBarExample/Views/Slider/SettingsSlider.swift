//
//  SettingsSlider.swift
//  AdaptiveTabBarExample
//
//  Created by Maksim Gaisin on 13.04.26.
//

import SwiftUI

import SwiftUI

struct SettingSlider<Value>: View
where Value: BinaryFloatingPoint, Value.Stride: BinaryFloatingPoint {
    enum ValueFormat: String {
        case integer = "%.0f"
        case fractionalTwo = "%.2f"
    }

    let title: String
    @Binding var value: Value
    let range: ClosedRange<Value>
    var step: Value.Stride = 1
    
    var format: ValueFormat = .integer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(title): \(String(format: format.rawValue, Double(value)))")
                .font(.subheadline)
            Slider(value: $value, in: range, step: step)
                .contentShape(Rectangle())
        }
    }
}
