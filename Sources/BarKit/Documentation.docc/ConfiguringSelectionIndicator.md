# Configuring the Selection Indicator

Customize the animated highlight that tracks the selected item.

## Overview

The selection indicator is a rounded rectangle that moves between items when selection changes.
It is configured via ``SelectionIndicatorConfiguration``, passed to ``BarConfiguration/indicator``.
Pass `nil` to disable the indicator entirely.

## Color and border

```swift
.init(
    indicator: .init(
        color: .white.opacity(0.2),
        border: .init(color: .white.opacity(0.4), lineWidth: 1)
    )
)
```

## Insets

Control the gap between the indicator and the item frame:

```swift
.init(indicator: .init(inset: .init(top: 4, leading: 4, bottom: 4, trailing: 4)))
```

Positive values shrink the indicator, negative values expand it beyond the item bounds.

## Transition animation

The indicator moves between items with a configurable animation:

```swift
// Spring (default)
.init(indicator: .init(transitionAnimation: .parameters(.init(type: .spring, duration: 0.4))))

// Custom SwiftUI animation
.init(indicator: .init(transitionAnimation: .custom(.bouncy)))

// Instant snap
.init(indicator: .init(transitionAnimation: nil))
```

## Scale effect

Apply a brief scale pulse to the indicator during transition:

```swift
.init(indicator: .init(scaleEffect: .init(xScale: 1.3, yScale: 1.1, duration: 0.2)))
```

## Drag gesture

By default the user can drag the indicator between items. Disable if needed:

```swift
.init(indicator: .init(isDragGestureEnabled: false))
```

## Metal shader effects

Visual effects applied at the indicator boundary, inspired by lens distortion and chromatic aberration.

### Lens distortion

Displaces pixels near the indicator edge, creating a subtle warping effect.

- `zoneWidth` — width of the distortion zone in points (typical range 2.0–12.0)
- `strength` — maximum pixel displacement (typical range 1.5–5.0)

```swift
.init(indicator: .init(effects: [.lensDistortion(.init(zoneWidth: 12, strength: 2))]))
```

### Chromatic aberration

Separates RGB channels near the indicator edge, creating a color fringe effect.

- `zoneWidth` — width of the aberration zone in points (typical range 1.0–6.0)
- `strength` — RGB channel separation in pixels (typical range 1.0–4.0)

```swift
.init(indicator: .init(effects: [.chromaticAberration(.init(zoneWidth: 8, strength: 4))]))
```

Both effects can be combined:

```swift
.init(indicator: .init(effects: [.lensDistortion(), .chromaticAberration()]))
```

> Both effects are inspired by their physical counterparts and do not attempt to model them accurately.

All Selection indicator configuration options are available interactively in the Example App under the **Selection indicator** settings section.
