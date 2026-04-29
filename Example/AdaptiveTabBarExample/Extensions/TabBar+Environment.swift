//
//  TabBar+Environment.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 13.03.26.
//

import SwiftUI

extension EnvironmentValues {
    #warning("why zero is default?")
    @Entry var tabBarHeight: CGFloat? = 0
}
