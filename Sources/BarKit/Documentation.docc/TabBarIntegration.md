# Tab Bar Integration

Use BarKit as a floating or pinned tab bar.

## Overview

BarKit provides two ready-to-use tab bar wrappers built on top of ``BarView``:
- ``FloatingTabBarView`` — a detached capsule positioned above the content
- ``PinnedTabBarView`` — a full-width bar pinned to the bottom edge

## Floating tab bar

Place ``FloatingTabBarView`` in a `ZStack` above your content. 
Safe area handling is the responsibility of the calling code:

```swift
ZStack(alignment: .bottom) {
    ContentView()
    FloatingTabBarView(items: items, selected: $selected)
}
.ignoresSafeArea(.all, edges: .bottom)
```

Position the capsule using `floatingInsets`:

```swift
FloatingTabBarView(
    items: items,
    selected: $selected,
    floatingInsets: .init(top: 0, leading: 16, bottom: 20, trailing: 16)
)
```

For landscape (compact height), provide `floatingInsetsCompact`:

```swift
FloatingTabBarView(
    items: items,
    selected: $selected,
    floatingInsets: .init(top: 0, leading: 16, bottom: 20, trailing: 16),
    floatingInsetsCompact: .init(top: 0, leading: 64, bottom: 8, trailing: 64)
)
```

## Pinned tab bar

Place ``PinnedTabBarView`` in a `VStack` below your content:

```swift
VStack(spacing: 0) {
    ContentView()
    PinnedTabBarView(items: items, selected: $selected)
}
```

> **Note:** `PinnedTabBarView` ignores `axis`, `cornerRadius`, `shadow`, and `baselineStyle` 
> from the configuration — these are overridden internally.

## Content inset

To prevent content from being obscured by the floating bar, add a bottom inset 
equal to the bar height. The Example App demonstrates this via `floatingTabBarOffset(_:barID:)` — 
a `safeAreaInset` modifier that collapses automatically when the bar is hidden.

## Hiding the bar

Bar visibility is controlled through a shared environment value `bkBarVisibility` — 
a dictionary that maps bar identifiers to their `Visibility` state.

Inject the binding at the container level with `registerBarVisibility(_:)`:

```swift
@State private var barVisibility: [String: Visibility] = [:]

ZStack(alignment: .bottom) {
    ContentView()
    if barVisibility["tabBar"] != .hidden {
        FloatingTabBarView(items: items, selected: $selected, id: "tabBar")
    }
}
.registerBarVisibility($barVisibility)
```

Any child view can then write `.hidden` into the environment via `hideBar(id:)`:

```swift
SomeDetailView()
    .hideBar(id: "tabBar")
```

`hideBar(id:)` writes `.hidden` on appear and restores `.visible` on disappear automatically.
The rendering decision — whether to show or remove the bar — belongs to the container.

## Prominent items

`PinnedTabBarView` supports a `.prominent` item style for items that overflow 
beyond the bar bounds — useful for a raised center action button:

```swift
let items: [MyItem] = [
    MyItem(title: "Home",   icon: .system("house.fill"),   style: .regular),
    MyItem(title: "Camera", icon: .system("camera.fill"),  style: .prominent),
    MyItem(title: "Profile",icon: .system("person.fill"),  style: .regular),
]

PinnedTabBarView(
    items: items,
    selected: $selected,
    configuration: .init(
        itemStyles: [
            .regular:   .init(iconSideLength: 24),
            .prominent: .init(iconSideLength: 40),
        ],
        baselineStyle: .regular
    )
)
```

> The bar height is fixed to the `baselineStyle` metrics, allowing prominent items to overflow upward.

## Example App

All tab bar features — floating and pinned layouts, insets, item styles, indicator, 
and hide behavior — are demonstrated interactively in the included Example App.
