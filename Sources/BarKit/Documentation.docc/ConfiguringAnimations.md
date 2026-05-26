# Configuring Animations

## Overview

``BarAnimation`` is a serializable alternative to SwiftUI `Animation`, used throughout BarKit.
It wraps either a named ``AnimationParameters`` preset or any arbitrary SwiftUI `Animation`:

```swift
// Named preset
.parameters(.init(type: .spring, duration: 0.5))

// Any SwiftUI animation
.custom(.interpolatingSpring(stiffness: 200, damping: 20))
```

Three aspects of the bar are animatable:

- **Item state** — icon and title transition on selection change (`itemStateAnimation`)
- **Indicator movement** — indicator sliding between items (`indicator.transitionAnimation`)
- **Indicator scale** — brief scale pulse during transition (`indicator.scaleEffect`)

## Lens effects and custom animations

When using `.custom` with lens effects, provide an explicit duration hint —
otherwise lens effects remain active indefinitely:

```swift
.custom(.easeInOut(duration: 0.3), duration: 0.3)
```

All animation options are available interactively in the Example App 
under the **Transiotion Animation** and **Scale Effect** subsections in **Selection Indicator Section**.
