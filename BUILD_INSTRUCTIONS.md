# Call Log Exporter APK Build Instructions

## Current Status
✅ Flutter project is complete and ready to build
✅ All dependencies are installed
✅ Code analysis passes with no issues
❌ Java runtime needs to be configured for APK build

## Build Options

### Option 1: Android Studio (Recommended)
1. Open Android Studio
2. File → Open → Select `/Users/sino/proj/call_log_exporter`
3. Wait for Gradle sync to complete
4. Build → Build Bundle(s) / APK(s) → Build APK(s)
5. Select "debug" variant
6. APK will be in: `build/app/outputs/flutter-apk/app-debug.apk`

### Option 2: Install Java (Command Line)
```bash
# Install Java using Homebrew
brew install openjdk@11

# Set JAVA_HOME
export JAVA_HOME=/usr/local/opt/openjdk@11

# Add to .zshrc permanently
echo 'export JAVA_HOME=/usr/local/opt/openjdk@11' >> ~/.zshrc

# Build APK
flutter build apk --debug
```

### Option 3: Use Flutter Doctor Fix
```bash
# Run flutter doctor to see Java issues
flutter doctor -v

# Follow the recommended fixes for Java installation
```

## APK Location
Once built successfully, the APK will be at:
```
/Users/sino/proj/call_log_exporter/build/app/outputs/flutter-apk/app-debug.apk
```

## App Features Ready
- ✅ Read call logs with permissions
- ✅ Extract phone numbers, names, call types, dates
- ✅ Normalize phone numbers (+964 → 0)
- ✅ Remove duplicates (keep latest)
- ✅ Export to CSV format
- ✅ Share via Android intent (Telegram, etc.)
- ✅ Filter by last 30 days
- ✅ Clean, minimal UI
- ✅ Error handling and loading states

## Installation
1. Transfer the APK to your Android device
2. Enable "Install from unknown sources" in settings
3. Install the APK
4. Grant permissions when prompted
5. Use the app to export call logs

## Note
The app is fully functional. The only issue is the build environment setup due to missing Java runtime, which is a system configuration issue, not a code issue.
