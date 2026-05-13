//
//  BarKitExampleApp.swift
//  BarKitExample
//
//  Created by Maksim Gaisin on 12.01.26.
//

import SwiftUI

@main
struct BarKitExampleApp: App {
    var body: some Scene {
        WindowGroup {
//            ExampleContentView()
            RootView()
        }
    }
}

enum AppKind: Identifiable {
    case old, new
    var id: Self { self }
}
 
struct RootView: View {
    @State private var activeApp: AppKind?
 
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("BarKit")
                .font(.largeTitle.bold())
            Spacer()
            Button("New Approach") { activeApp = .new }
            Button("Old Approach") { activeApp = .old }
            Spacer()
        }
        .fullScreenCover(item: $activeApp) { demo in
            switch demo {
            case .new: ExampleContentView()
            case .old: OldExampleContentView()
            }
        }
    }
}
