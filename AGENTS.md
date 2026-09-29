# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## What this is

BarKit is a Swift Package (iOS 16+, Swift 6 language mode) providing a customizable SwiftUI bar
with selectable items — usable standalone, as a floating tab bar, or as a pinned system-style
tab bar. Ships as a library target (`Sources/BarKit`) plus an example iOS app
(`Example/BarKitExample`) that consumes the package locally. Optional Metal shader effects
(lens distortion, chromatic aberration) run at the selection indicator boundary via SwiftUI's
`.layerEffect` on iOS 17+ — see `IndicatorEffect` for the list.

## Architecture

Understanding the library requires following data through four cooperating pieces:

1. **`BarView`** (`BarViews/BarView.swift`) — the core renderer, and the only place that owns
   state. Items report their frames through `BarItemFrameKey` / `BarIconFrameKey` into a
   per-instance named coordinate space (`coordinateSpaceID`, passed down via
   `\.bkBarSpaceName`); everything else — indicator position and size, bar height, drag
   resolution, badge placement — is derived from those frames. `BarView` does not position
   itself on screen; layout is the caller's job.

2. **`BarConfiguration`** (`BarConfiguration/`) — one value type carrying the entire visual
   style, passed down by value. Per-item appearance lives in `itemStyles: [BarItemStyle:
   ItemConfiguration]`, keyed by the item's own `style`, falling back to `.regular` when a
   style has no entry. Sub-configurations (`SelectionIndicatorConfiguration`, `BarBackground`,
   `BadgeConfiguration`, `ShadowConfiguration`, `HapticFeedbackConfiguration`, `BarAnimation`)
   are separate types under the same folder. `nil` consistently means "off" — no indicator,
   no shadow, no haptics, no animation.

3. **The dual-render stack** — selected items are not recolored in place. `BarView` renders
   `BarItemView` (interactive, unselected colors) and a second non-interactive
   `BarItemOverlayView` stack in selected colors, masked to the indicator's rounded rectangle.
   The color change is the mask moving. Both stacks — plus the badge stack — are built from the
   same `itemStack(content:)` builder, so their layouts must stay identical.

4. **Tab bar wrappers** (`FloatingTabBarView`, `PinnedTabBarView`) — thin views over `BarView`
   that only add positioning. `PinnedTabBarView` overrides parts of the configuration it is
   given (`axis`, `cornerRadius`, `shadow`, `background`, `itemAlignment`, `baselineStyle`) and
   forwards the rest. Hiding is cooperative, not built in: the container injects a binding with
   `registerBarVisibility(_:)` and a pushed screen writes into it with `hideBar(id:)` — the
   decision to stop rendering belongs to the container that owns the binding.

Metal effects sit on top of this: `indicatorLens(_:frame:isActive:)` wraps each stack and only
engages while the indicator is actually moving (`isIndicatorMoving`), then resolves to
`indicatorLensEffect` and the precompiled `ShaderLibrary.indicatorLibrary`.

## Typical usage shape

See `Example/BarKitExample/View/ExampleContentView.swift` and
`Example/BarKitExample/View/Components/TabBarContainer.swift` for a working reference, and the
README Quick Start for the minimal form. Items are supplied by the caller as a `[Item]` of any
type conforming to `BarItemProtocol` plus a `Binding` to the selected one — BarKit holds no
selection state of its own.

## Naming

Use full-length words in identifiers, not abbreviations — `configuration`, not `config`.

## Documentation

All public and internal types, properties, and functions must have DocC-style doc comments
(`///`). Use `- Parameters:` and `- Returns:` where applicable. No exceptions for "obvious"
declarations — every declaration gets a doc comment. Keep comments concise.

Avoid inline comments in code bodies unless something is genuinely non-obvious — the result of
trial and error, a non-trivial rationale, or a gotcha a reader can't derive from the code itself.
Otherwise, prefer making the code self-explanatory over commenting it.

Adding, removing, or renaming a public symbol? Update `Sources/BarKit/Documentation.docc/BarKit.md`'s
Topics list to match, and the article in the same folder that covers that area
(`ConfiguringLayout.md`, `ConfiguringSelectionIndicator.md`, `ConfiguringBadges.md`, and so on).

## Example app code generation

The example app renders a live initializer string for the current settings
(`CodeGeneration/`, surfaced in `View/Screens/CodegenerationScreen.swift`). Each configuration
type has an `InitStringConvertible` conformance in
`Example/BarKitExample/CodeGeneration/Conformances/`, emitting only the parameters that differ
from `Self.default`.

Adding or renaming a public configuration property? Update that type's conformance too,
otherwise the generated code silently omits it. `Example/BarKitExampleTests/` asserts the
generated strings, so expected output there has to move with it.

## Metal shaders

Changed a `.metal` file (in `/Shaders`)? Run `Scripts/compileShader.sh <ShaderName>` — regenerates
its `iphoneos`/`iphonesimulator` `.metallib` pair into `Sources/BarKit/Metal/`. Run once per
shader; commit the regenerated `.metallib`s with the change.

`Sources/BarKit/Metal/` holds only compiled `.metallib`s, bundled as package resources, so
consumers don't need the Metal toolchain to build the package.

Shader effects are gated on iOS 17+ and fall back to no effect below that — the library itself
supports iOS 16. Haptic feedback is iOS 17+ as well.

## Build policy

NEVER run `swift build`, `swift test`, or `xcodebuild` — building and testing is the user's
responsibility, done manually in Xcode. CI (`.github/workflows/`) builds the package on pull
requests to `main` and `develop`, and builds and deploys the DocC site on pushes to those
branches.

Don't suggest judging the indicator's shader effects on a simulator — verify them on a real
device. Haptic feedback doesn't fire on a simulator at all.
