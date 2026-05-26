# Getting Started

Add a customizable bar to your SwiftUI app in minutes.

## Overview

BarKit is built around ``BarView`` — a flexible bar that renders selectable items 
with a fully customizable appearance. Use it standalone or as a tab bar.

## Define your items

Conform to ``BarItemProtocol`` to describe your items:

```swift
struct MyItem: BarItemProtocol {
    let title: String
    let icon: BarIcon
    var style: BarItemStyle = .regular
    var id: AnyHashable { title }
}
```

## Standalone BarView

```swift
@State private var selected = items[0]

let items: [MyItem] = [
    MyItem(title: "Wine",     icon: .system("wineglass.fill")),
    MyItem(title: "Beer",     icon: .system("mug.fill")),
    MyItem(title: "Tea",      icon: .system("cup.and.saucer.fill")),
    MyItem(title: "Cocktail", icon: .system("bubbles.and.sparkles")),
]

BarView(items: items, selected: $selected)
```

## Floating tab bar

```swift
ZStack(alignment: .bottom) {
    ContentView()
    FloatingTabBarView(items: items, selected: $selected)
}
.ignoresSafeArea(.all, edges: .bottom)
```

## Pinned tab bar

```swift
VStack(spacing: 0) {
    ContentView()
    PinnedTabBarView(items: items, selected: $selected)
}
```
