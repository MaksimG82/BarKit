# Configuring Badges

Display badge overlays on bar items to communicate status or counts.

## Overview

Badges are rendered as overlays on bar item icons. Each badge is identified by the item's `id`
and configured globally via ``BadgeConfiguration`` in ``BarConfiguration/badge``.

```swift
BarView(
    items: items,
    selected: $selected,
    badges: [
        "home": .count(3),
        "search": .dot,
        "profile": .label("New")
    ]
)
```

## Badge types

Three content types are available via ``BadgeValue``:

```swift
// A small dot with no text
.dot

// A numeric counter
.count(42)

// An arbitrary string
.label("New")
```

## Appearance

Badge appearance is configured via ``BadgeConfiguration`` inside ``BarConfiguration``:

```swift
.init(
    badge: .init(
        backgroundColor: .red,
        foregroundColor: .white,
        textStyle: .caption2,
        horizontalPadding: 4,
        verticalPadding: 2,
        dotDiameter: 8
    )
)
```

## Position

By default badges are anchored to the top-trailing corner of the icon.
Use `offsetX` and `offsetY` to fine-tune placement:

```swift
.init(
    badge: .init(
        offsetX: 4,
        offsetY: -4
    )
)
```

## Removing a badge

Pass `nil` for a given item identifier to hide its badge:

```swift
var badges: [AnyHashable: BadgeValue] = ["home": .count(3)]
badges["home"] = nil // badge removed
```

## Lens effects

Badges are rendered within the same layer stack as bar items and participate
in the selection indicator lens effects automatically.

## Example App

Badge configuration is available interactively in the Example App
under the **Badges** settings section on both the Tab Bar and Standalone screens.
