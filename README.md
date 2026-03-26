# 📱 Call Log Exporter

A Flutter app that exports your device call logs to clean CSV format for easy sharing via Telegram, WhatsApp, or other apps.

## ✨ Features

- 📞 **Read Call Logs** - Access device call history with proper permissions
- 🧹 **Data Cleaning** - Normalize phone numbers (+964 → 0) and remove duplicates
- 📊 **CSV Export** - Clean format: phone, name, type, date
- 📤 **Easy Sharing** - Share via Android intent (Telegram, WhatsApp, etc.)
- 🔍 **Filter Option** - Export last 30 days or all logs
- ⚡ **Fast Processing** - Handles 1000+ entries efficiently
- 🎨 **Clean UI** - Simple, minimal interface

## 📋 CSV Output Format

```csv
phone,name,type,date
07801234567,John Doe,incoming,26-03-2026 14:30:25
07801234568,Jane Smith,outgoing,26-03-2026 13:15:10
07801234569,,missed,26-03-2026 12:45:33
```

## 🚀 Quick Start

1. **Install APK** on your Android device
2. **Grant permissions** for call log and contacts access
3. **Tap "Load Call Logs"** to fetch data
4. **Tap "Export & Share"** to create and share CSV
5. **Choose Telegram** or other app to share

## 🛠️ Tech Stack

- **Flutter** - Cross-platform mobile development
- **Provider** - State management
- **CSV** - Data export
- **Share Plus** - File sharing
- **Permission Handler** - Android permissions

## 📱 Permissions Required

- `READ_CALL_LOG` - Access call history
- `READ_CONTACTS` - Resolve contact names
- Storage access - Save and share CSV files

## 🔧 Build Instructions

### Using Codemagic (Recommended)
1. Connect this repository to [Codemagic](https://codemagic.io)
2. Click "Build" to generate APK automatically

### Manual Build
```bash
flutter pub get
flutter build apk --debug
```

## 📄 License

MIT License - feel free to use and modify

---

**🎯 Perfect for backing up call logs, analyzing call patterns, or migrating to new devices!**
