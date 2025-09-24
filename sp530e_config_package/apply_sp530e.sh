#!/bin/bash

# SP530E Configuration Applier
# Applies SP530E modifications to any WLED repository

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(pwd)"

echo "🎯 SP530E Configuration Applier"
echo "==============================="
echo "Applying to: $TARGET_DIR"
echo ""

# Check if we're in a WLED repository
if [ ! -f "platformio.ini" ]; then
    echo "❌ Error: platformio.ini not found. Are you in a WLED repository?"
    exit 1
fi

if ! grep -q "WLED" platformio.ini; then
    echo "❌ Error: This doesn't appear to be a WLED repository."
    exit 1
fi

echo "✅ WLED repository detected"
echo ""

# 1. Add SP530E environment to platformio.ini
echo "📝 Adding SP530E environment to platformio.ini..."
if grep -q "\[env:sp530e\]" platformio.ini; then
    echo "   ⚠️  SP530E environment already exists, skipping..."
else
    echo "" >> platformio.ini
    echo "# SP530E Configuration (Auto-added)" >> platformio.ini
    cat "$SCRIPT_DIR/platformio_sp530e.ini" >> platformio.ini
    echo "   ✅ Added SP530E environment"
fi

# 2. Copy tools directory
echo "🔧 Copying ESP32-C3 tools and partition tables..."
if [ -d "$SCRIPT_DIR/tools" ]; then
    cp -r "$SCRIPT_DIR/tools"/* ./tools/ 2>/dev/null || true
    echo "   ✅ Tools copied"
else
    echo "   ⚠️  No tools directory found in package"
fi

# 3. Copy GitHub Actions (optional)
echo "🚀 Setting up GitHub Actions..."
if [ -d "$SCRIPT_DIR/.github" ]; then
    mkdir -p .github
    cp -r "$SCRIPT_DIR/.github"/* ./.github/
    echo "   ✅ GitHub Actions configured"
else
    echo "   ⚠️  No GitHub Actions found in package"
fi

# 4. Create builds directory structure
echo "📁 Creating builds directory structure..."
mkdir -p builds/latest
echo "   ✅ Build directories created"

# 5. Test SP530E environment
echo "🔨 Testing SP530E build configuration..."
if command -v pio >/dev/null 2>&1; then
    if pio run -e sp530e --dry-run >/dev/null 2>&1; then
        echo "   ✅ SP530E environment configured correctly"
    else
        echo "   ⚠️  SP530E build test failed - may need manual adjustment"
    fi
else
    echo "   ⚠️  PlatformIO not found - install with: pip install platformio"
fi

echo ""
echo "🎉 SP530E Configuration Applied Successfully!"
echo ""
echo "🔧 Next steps:"
echo "   pio run -e sp530e                    # Build SP530E firmware"
echo "   pio run -e sp530e -t upload          # Upload to device"
echo ""
echo "📋 SP530E Hardware Configuration:"
echo "   • Board: ESP32-C3-DevKitM-1"
echo "   • LED Pin: GPIO 19"
echo "   • Microphone Pin: GPIO 3 (Audio Reactive)"
echo "   • Button Pin: GPIO 8"
echo "   • Status LEDs: GPIO 0, GPIO 1"
echo ""
echo "🌐 GitHub Actions:"
echo "   Push to trigger automatic builds and releases"
echo "   Binaries will be available in builds/ directory"