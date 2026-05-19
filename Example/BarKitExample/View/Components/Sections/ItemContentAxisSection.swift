//
//  ItemContentAxisSection.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 19.05.26.
//

import SwiftUI
import BarKit

/// A reusable settings section for configuring the item content layout axis.
struct ItemContentAxisSection: View {
    
    /// Binding to the optional item content layout axis arrangement.
    @Binding var axis: ItemContentAxis?
    
    var body: some View {
        Section {
            Picker("Content Axis", selection: $axis) {
                Text("System").tag(ItemContentAxis?.none)
                Text("Horizontal").tag(ItemContentAxis?.some(.horizontal))
                Text("Vertical").tag(ItemContentAxis?.some(.vertical))
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Item Content Axis")
        } footer: {
            Text("System mode infers axis from the bar orientation and screen size class.")
        }
    }
}
