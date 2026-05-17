#!/bin/bash

# compileShader.sh
# Compiles a Metal shader from Shaders/ into two .metallib files:
#   - <Name>-iphoneos.metallib        (device)
#   - <Name>-iphonesimulator.metallib (simulator)
#
# Usage:   ./Scripts/compileShader.sh <ShaderName>
# Example: ./Scripts/compileShader.sh IndicatorEffects

set -e

# ── Validate argument ──────────────────────────────────────────────────────────
if [ -z "$1" ]; then
    echo "Error: shader name required."
    echo "Usage: ./Scripts/compileShader.sh <ShaderName>"
    exit 1
fi

SHADER_NAME="$1"

# ── Paths ──────────────────────────────────────────────────────────────────────

## Root of the package (directory containing this script's parent)
PACKAGE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

## Input .metal source file
METAL_SRC="$PACKAGE_ROOT/Shaders/${SHADER_NAME}.metal"

## Output directory
OUTPUT_DIR="$PACKAGE_ROOT/Sources/BarKit/Metal"

## Temporary .air intermediate files
TMP_AIR_DEVICE="/tmp/${SHADER_NAME}-iphoneos.air"
TMP_AIR_SIM="/tmp/${SHADER_NAME}-iphonesimulator.air"

# ── Validate source ────────────────────────────────────────────────────────────
if [ ! -f "$METAL_SRC" ]; then
    echo "Error: '$METAL_SRC' not found."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# ── Compile: device ───────────────────────────────────────────────────────────
echo "[$SHADER_NAME] Compiling for iphoneos ..."
xcrun -sdk iphoneos metal \
    -target air64-apple-ios16.0 \
    -fmetal-math-mode=fast \
    -fmetal-math-fp32-functions=fast \
    -c "$METAL_SRC" \
    -o "$TMP_AIR_DEVICE"

xcrun -sdk iphoneos metallib \
    "$TMP_AIR_DEVICE" \
    -o "$OUTPUT_DIR/${SHADER_NAME}-iphoneos.metallib"

echo "[$SHADER_NAME] Done: ${SHADER_NAME}-iphoneos.metallib"

# ── Compile: simulator ────────────────────────────────────────────────────────
echo "[$SHADER_NAME] Compiling for iphonesimulator ..."
xcrun -sdk iphonesimulator metal \
    -target air64-apple-ios16.0-simulator \
    -fmetal-math-mode=fast \
    -fmetal-math-fp32-functions=fast \
    -c "$METAL_SRC" \
    -o "$TMP_AIR_SIM"

xcrun -sdk iphonesimulator metallib \
    "$TMP_AIR_SIM" \
    -o "$OUTPUT_DIR/${SHADER_NAME}-iphonesimulator.metallib"

echo "[$SHADER_NAME] Done: ${SHADER_NAME}-iphonesimulator.metallib"

# ── Cleanup ────────────────────────────────────────────────────────────────────
rm -f "$TMP_AIR_DEVICE" "$TMP_AIR_SIM"

echo "[$SHADER_NAME] All done."