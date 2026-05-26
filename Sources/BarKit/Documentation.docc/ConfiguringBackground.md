# Configuring the Background

Control the bar's background appearance.

## Overview

The bar background is defined by ``BarBackground``, set via ``BarConfiguration/background``.
Three styles are available: solid color, system material blur, and custom shader blur.

## Solid color

```swift
.init(background: .color(.black.opacity(0.8)))
```

## System material

Uses SwiftUI `Material` with an optional tint color layered on top:

```swift
.init(background: .material(.ultraThin))

// With tint
.init(background: .material(.ultraThin, tint: .blue.opacity(0.2)))
```

Available materials: `.bar`, `.ultraThin`, `.thin`, `.regular`, `.thick`.

## Custom blur

A shader-based blur with configurable intensity and optional tint:

```swift
.init(background: .customBlur(.init(intensity: 0.7), tint: .clear))
```

> **Note:** Custom blur is reserved for future implementation. Parameters will expand as the shader is developed.

## Corner radius

The bar capsule corner radius is configured separately via ``BarConfiguration/cornerRadius``:

```swift
.init(cornerRadius: 16)
```

## Shadow

Add a drop shadow to the bar capsule via ``BarConfiguration/shadow``:

```swift
.init(shadow: .init(color: .black.opacity(0.3), radius: 12, x: 0, y: 4))

// Disable shadow
.init(shadow: nil)
```

All background configuration options are available interactively in the Example App 
under the **Background** settings section.
