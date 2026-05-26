# Additional Configuration

## Haptic feedback

Configure the feedback style triggered when the selected item changes.
Requires iOS 17 or later; has no effect on earlier versions.

```swift
.init(hapticFeedback: .selection)
```

Available styles: `.selection`, `.impact`, `.success`, `.warning`, `.error`.

```swift
// Disable
.init(hapticFeedback: nil)
```

## Accessibility

Set a VoiceOver label for the entire bar:

```swift
.init(barAccessibilityLabel: "Main navigation")
```

When the bar and content share a `ZStack`, VoiceOver may reach the bar before the content.
Use `accessibilitySortPriority` to control the order — lower values are reached later:

```swift
.init(accessibilitySortPriority: -1)
```

Each item's accessibility label defaults to its `title`. 
Override via `accessibilityLabel` in your ``BarItemProtocol`` conformance:

```swift
struct MyItem: BarItemProtocol {
    var accessibilityLabel: String? { "Custom label" }
    ...
}
```
