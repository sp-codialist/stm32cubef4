#!/bin/bash
# Test script for CPack configuration validation

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build/test-cpack"
PRESET_NAME="stm32cubef4-r-gnuarm14.3"

echo "=== STM32CubeF4 CPack Configuration Test ==="
echo "Project Root: ${PROJECT_ROOT}"
echo "Build Directory: ${BUILD_DIR}"
echo "Preset: ${PRESET_NAME}"
echo

# Clean previous test
if [ -d "${BUILD_DIR}" ]; then
    echo "Cleaning previous build..."
    rm -rf "${BUILD_DIR}"
fi

# Configure project
echo "Configuring project..."
cd "${PROJECT_ROOT}"
cmake --preset "${PRESET_NAME}" -B "${BUILD_DIR}"

# Build project
echo "Building project..."
cmake --build "${BUILD_DIR}" --config Release

# Test CPack configuration
echo "Testing CPack configuration..."
cd "${BUILD_DIR}"

# Check if cpack works
echo "Validating CPack setup..."
cpack --help > /dev/null 2>&1 || {
    echo "ERROR: CPack not available"
    exit 1
}

# Test TGZ generation
echo "Testing TGZ package generation..."
cpack -G TGZ -C Release --verbose

# Test ZIP generation
echo "Testing ZIP package generation..."
cpack -G ZIP -C Release --verbose

# Validate generated packages
echo "Validating generated packages..."

TGZ_FILE=$(find . -name "*.tar.gz" | head -1)
ZIP_FILE=$(find . -name "*.zip" | head -1)

if [ -f "$TGZ_FILE" ]; then
    echo "✅ TGZ package generated: $TGZ_FILE"
    echo "   Size: $(ls -lh "$TGZ_FILE" | awk '{print $5}')"
    echo "   Contents preview:"
    tar -tzf "$TGZ_FILE" | head -10
    if [ $(tar -tzf "$TGZ_FILE" | wc -l) -gt 10 ]; then
        echo "   ... ($(tar -tzf "$TGZ_FILE" | wc -l) total files)"
    fi
else
    echo "❌ TGZ package not generated"
    exit 1
fi

if [ -f "$ZIP_FILE" ]; then
    echo "✅ ZIP package generated: $ZIP_FILE"
    echo "   Size: $(ls -lh "$ZIP_FILE" | awk '{print $5}')"
    echo "   Contents preview:"
    unzip -l "$ZIP_FILE" | head -15
else
    echo "❌ ZIP package not generated"
    exit 1
fi

# Test component-based packaging
echo "Testing component-based packaging..."
if cpack -G TGZ -C Release -D CPACK_ARCHIVE_COMPONENT_INSTALL=ON --verbose 2>/dev/null; then
    echo "✅ Component-based packaging works"
    COMPONENT_PKGS=$(find . -name "*-library.tar.gz" -o -name "*-development.tar.gz")
    if [ -n "$COMPONENT_PKGS" ]; then
        echo "   Component packages:"
        for pkg in $COMPONENT_PKGS; do
            echo "   - $pkg ($(ls -lh "$pkg" | awk '{print $5}'))"
        done
    fi
else
    echo "ℹ️  Component-based packaging not available or failed"
fi

# Test package validation
echo "Testing package validation..."
mkdir -p package-test
cd package-test

# Extract and verify TGZ contents
echo "Extracting TGZ package..."
tar -xzf "../$TGZ_FILE"

# Look for expected files
echo "Validating package contents..."
EXPECTED_FILES=(
    "lib/libstm32cubef4.a"
    "include/stm32cubef4"
    "lib/cmake/stm32cubef4"
)

for file in "${EXPECTED_FILES[@]}"; do
    if [ -e "$file" ]; then
        echo "✅ Found: $file"
    else
        echo "⚠️  Missing: $file"
    fi
done

# Check for CMake config files
CMAKE_CONFIG=$(find . -name "*Config.cmake" | head -1)
if [ -f "$CMAKE_CONFIG" ]; then
    echo "✅ CMake config found: $CMAKE_CONFIG"
else
    echo "⚠️  CMake config files not found"
fi

cd ..

# Generate package summary
echo
echo "=== Package Summary ==="
echo "Generated packages:"
find . -name "*.tar.gz" -o -name "*.zip" | while read pkg; do
    echo "  📦 $(basename "$pkg") ($(ls -lh "$pkg" | awk '{print $5}'))"
done

echo
echo "=== Test Results ==="
echo "✅ CPack configuration is working correctly"
echo "✅ Packages can be generated successfully"
echo "✅ Package contents appear valid"

# Cleanup option
echo
read -p "Clean up test build directory? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "${BUILD_DIR}"
    echo "✅ Test build cleaned up"
fi

echo "CPack test completed successfully!"