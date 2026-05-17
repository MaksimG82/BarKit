#!/bin/bash

# compile_shader.sh
# Compiles a Metal shader from Shaders/ into a .metallib in Sources/BarKit/Metal/
#
# Usage: ./Scripts/compile_shader.sh <ShaderName>
# Example: ./Scripts/compile_shader.sh IndicatorEffects

set -e

# ── Validate argument ──────────────────────────────────────────────────────────
if [ -z "$1" ]; then
    echo "Error: shader name required."
    echo "Usage: ./Scripts/compile_shader.sh <ShaderName>"
    exit 1
fi

SHADER_NAME="$1"

# ── Paths ──────────────────────────────────────────────────────────────────────

## Root of the package (directory containing this script's parent)
PACKAGE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

## Input .metal source file
METAL_SRC="$PACKAGE_ROOT/Shaders/${SHADER_NAME}.metal"

## Output .metallib destination
OUTPUT_DIR="$PACKAGE_ROOT/Sources/BarKit/Metal"
OUTPUT_LIB="$OUTPUT_DIR/${SHADER_NAME}.metallib"

## Temporary .air intermediate file
TMP_AIR="/tmp/${SHADER_NAME}.air"

# ── Validate source ────────────────────────────────────────────────────────────
if [ ! -f "$METAL_SRC" ]; then
    echo "Error: '$METAL_SRC' not found."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# ── Compile ────────────────────────────────────────────────────────────────────
echo "Compiling $SHADER_NAME.metal → .air ..."
xcrun -sdk iphoneos metal \
    -target air64-apple-ios16.0 \
    -c "$METAL_SRC" \
    -o "$TMP_AIR"

echo "Linking .air → .metallib ..."
xcrun -sdk iphoneos metallib \
    "$TMP_AIR" \
    -o "$OUTPUT_LIB"

# ── Cleanup ────────────────────────────────────────────────────────────────────
rm -f "$TMP_AIR"

echo "Done: $OUTPUT_LIB"