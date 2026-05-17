//
//  IndicatorEffects.metal
//  BarKit
//
//  Created by Maksim Gaisin on 21.04.26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

/// Returns the signed distance from a point to a rounded rectangle boundary.
/// Negative values indicate the point is inside, positive — outside, zero — on the boundary.
///
/// - Parameters:
///   - point: The point to measure from.
///   - indicatorCenter: The center of the rounded rectangle.
///   - indicatorHalfSize: Half the width and height of the rectangle.
///   - cornerRadius: The corner radius of the rectangle.
float roundedRectSDF(float2 point, float2 indicatorCenter, float2 indicatorHalfSize, float cornerRadius) {
    float2 p = abs(point - indicatorCenter);
    float2 shrunkSize = indicatorHalfSize - cornerRadius;
    float2 cornerDist = p - shrunkSize;
    float outsideDist = length(max(cornerDist, 0.0));
    float insideDist = min(max(cornerDist.x, cornerDist.y), 0.0);
    return outsideDist + insideDist - cornerRadius;
}

/// Applies lens distortion and chromatic aberration effects within the selection indicator bounds.
///
/// - Parameters:
///   - position: The position of the current pixel in the layer's coordinate space.
///   - layer: The SwiftUI layer being rendered.
///   - indicatorCenter: The center of the indicator in the view's coordinate space.
///   - indicatorHalfSize: Half the width and height of the indicator.
///   - cornerRadius: The corner radius of the indicator shape.
///   - refractionZoneWidth: Width in points of the zone near the boundary where lens distortion is applied. Typical range 2.0–12.0.
///   - aberrationZoneWidth: Width in points of the zone near the boundary where chromatic aberration is applied. Typical range 1.0–6.0.
///   - refractionStrength: Maximum pixel displacement at the indicator boundary. Typical range 1.5–5.0.
///   - aberrationStrength: RGB channel separation in pixels at the indicator boundary. Typical range 1.0–4.0.

[[stitchable]] half4 indicatorLensEffect(
    float2 position,
    SwiftUI::Layer layer,
    float2 indicatorCenter,
    float2 indicatorHalfSize,
    float cornerRadius,
    float refractionZoneWidth,
    float aberrationZoneWidth,
    float refractionStrength,
    float aberrationStrength
) {
    float sdf = roundedRectSDF(position, indicatorCenter, indicatorHalfSize, cornerRadius);

    if (sdf > 0.0) {
        return layer.sample(position);
    }

    float refractionEffect = smoothstep(-refractionZoneWidth, 0.0, sdf);

    float2 raw = float2(
        roundedRectSDF(position + float2(1.0, 0.0), indicatorCenter, indicatorHalfSize, cornerRadius) -
        roundedRectSDF(position - float2(1.0, 0.0), indicatorCenter, indicatorHalfSize, cornerRadius),
        roundedRectSDF(position + float2(0.0, 1.0), indicatorCenter, indicatorHalfSize, cornerRadius) -
        roundedRectSDF(position - float2(0.0, 1.0), indicatorCenter, indicatorHalfSize, cornerRadius)
    );
    float2 gradient = length(raw) > 0.0001 ? normalize(raw) : float2(0.0, 1.0);

    float2 sampledPosition = position - gradient * refractionEffect * refractionStrength;

    half4 color = layer.sample(sampledPosition);

    float aberrationEffect = smoothstep(-aberrationZoneWidth, 0.0, sdf);

    if (aberrationEffect > 0.0) {
        float shift = aberrationEffect * aberrationStrength;
        color.r = layer.sample(sampledPosition + gradient * shift).r;
        color.g = layer.sample(sampledPosition).g;
        color.b = layer.sample(sampledPosition - gradient * shift).b;
    }

    return color;
}
