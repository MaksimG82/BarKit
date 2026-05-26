# Configuring the Layout

Control the bar's size, axis, and item arrangement.

## Overview

`BarView` sizes itself from its content — no explicit frame needed.
The bar dimensions are determined by item content (icon, title, font size) plus `edgeInsets` 
defined in ``ItemConfiguration``.

> **Note:** When using `.prominent` style with `baselineStyle` set, the bar height is fixed 
> to the baseline style metrics — allowing prominent items to overflow upward beyond the bar bounds.


## Axis

Switch between horizontal and vertical layout via ``BarConfiguration/axis``:

```swift
// Horizontal (default)
BarView(items: items, selected: $selected)

// Vertical
BarView(items: items, selected: $selected, configuration: .init(axis: .vertical))
```

## Controlling size through padding

The bar has no explicit size parameter. Control its dimensions via `edgeInsets` in ``ItemConfiguration``:

```swift
BarView(
    items: items,
    selected: $selected,
    configuration: .init(
        itemStyles: [.regular: .init(
            iconSideLength: 24,
            edgeInsets: .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        )]
    )
)
```

Both `edgeInsets` (regular height) and `edgeInsetsCompact` (compact height, e.g. landscape) 
can be configured independently. `BarView` switches between them automatically based on the 
current vertical size class.

## Item content axis

Icon and title can be stacked vertically or arranged horizontally via `itemContentAxis`.
When `nil`, the arrangement is inferred automatically from bar axis and size class:

- Horizontal bar, regular height → vertical (icon above title)
- Horizontal bar, compact height → horizontal (icon beside title)  
- Vertical bar → always horizontal

```swift
.init(itemContentAxis: .horizontal)
```

## Alignment

Two independent alignment controls are available:

- `itemAlignment` — aligns items along the cross-axis of the bar
- `itemContentAlignment` — aligns icon and title within each item

```swift
.init(
    itemAlignment: .end,
    itemContentAlignment: .start
)
```
## Item spacing

By default items are evenly distributed with no explicit spacing. 
Set `itemSpacing` to add fixed gaps between items:

```swift
.init(itemSpacing: 8)
```
All layout configuration options are available interactively in the Example App.
