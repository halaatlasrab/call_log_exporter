#!/bin/bash

echo "Building Call Log Exporter APK..."

# Clean Flutter
flutter clean

# Get dependencies
flutter pub get

# Try building with specific platform
flutter build apk --debug --target-platform android-arm64

echo "Build completed. Check build/app/outputs/flutter-apk/app-debug.apk"
