# Configuring Items

Control the appearance of individual bar items.

## Overview

Each bar item is styled via ``ItemConfiguration``, passed to ``BarConfiguration/itemStyles`` 
as a dictionary keyed by ``BarItemStyle``.

```swift
.init(itemStyles: [.regular: .init()])
```

Falls back to `.regular` configuration if a style has no explicit entry.

## Colors

```swift
.init(itemStyles: [.regular: .init(
    selectedColor: .primary,
    unselectedColor: .secondary
)])
```

## Icon size

```swift
.init(itemStyles: [.regular: .init(
    iconSideLength: 24,
    selectedIconScale: 1.1,
    compactIconScale: 0.8
)])
```

`selectedIconScale` applies when the item is selected. 
`compactIconScale` applies automatically in compact height (landscape).

## Title typography

```swift
.init(itemStyles: [.regular: .init(textStyle: .caption2)])
```

## Padding

```swift
.init(itemStyles: [.regular: .init(
    edgeInsets: .init(top: 8, leading: 8, bottom: 8, trailing: 8),
    edgeInsetsCompact: .init(top: 4, leading: 4, bottom: 4, trailing: 4)
)])
```

`edgeInsetsCompact` is used automatically in compact height (landscape).

## Item state animation

The animation applied to icon and title when selection changes:

```swift
.init(itemStateAnimation: .parameters(.init(type: .easeInOut, duration: 0.2)))

// Disable
.init(itemStateAnimation: nil)
```

## Multiple styles

Define appearance per style — useful for prominent items in `PinnedTabBarView`:

```swift
.init(itemStyles: [
    .regular:   .init(iconSideLength: 24),
    .prominent: .init(iconSideLength: 40),
])
```

## Example App

All item configuration options are available interactively in the Example App 
under the **Bar item** settings section.
