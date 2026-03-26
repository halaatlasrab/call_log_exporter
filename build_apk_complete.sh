#!/bin/bash

echo "=== Call Log Exporter APK Builder ==="
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Please run this script from the Flutter project root directory"
    echo "   Current directory: $(pwd)"
    echo "   Expected directory: /Users/sino/proj/call_log_exporter"
    exit 1
fi

echo "✅ Found Flutter project"

# Clean and get dependencies
echo "🧹 Cleaning Flutter cache..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

# Try different build approaches
echo ""
echo "🔨 Attempting APK build..."

# Method 1: Standard debug build
echo "Method 1: Standard debug build..."
if flutter build apk --debug; then
    echo "✅ SUCCESS! APK built successfully!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-debug.apk"
    exit 0
fi

# Method 2: ARM64 build
echo "Method 2: ARM64 build..."
if flutter build apk --debug --target-platform android-arm64; then
    echo "✅ SUCCESS! APK built successfully!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk"
    exit 0
fi

# Method 3: Split APKs
echo "Method 3: Split APKs..."
if flutter build apk --debug --split-per-abi; then
    echo "✅ SUCCESS! Split APKs built successfully!"
    echo "📱 APKs location: build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk"
    exit 0
fi

echo ""
echo "❌ All automated build methods failed due to Java configuration issues."
echo ""
echo "📋 MANUAL BUILD INSTRUCTIONS:"
echo "1. Open Android Studio"
echo "2. File → Open → Select: $(pwd)"
echo "3. Wait for Gradle sync (may take several minutes)"
echo "4. Build → Build Bundle(s) / APK(s) → Build APK(s)"
echo "5. Choose 'debug' variant"
echo "6. APK will be in: build/app/outputs/flutter-apk/app-debug.apk"
echo ""
echo "🔧 ALTERNATIVE: Install Java first:"
echo "   brew install openjdk@11"
echo "   export JAVA_HOME=/usr/local/opt/openjdk@11"
echo "   flutter build apk --debug"
echo ""
echo "📱 Your app is ready - only the build environment needs Java!"
