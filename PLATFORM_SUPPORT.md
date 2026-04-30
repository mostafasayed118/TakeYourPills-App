# Platform Support Policy

## Supported Platforms

This application is a **mobile-only** application built with Flutter.

| Platform | Status | Notes |
|----------|--------|-------|
| **Android** | ✅ Supported | Minimum SDK 21 (Android 5.0+) |
| **iOS** | ✅ Supported | Requires iOS 13.0+ |
| **Web** | ❌ Not Supported | Incompatible with SQLite/FFI and local notifications |
| **Windows** | ❌ Not Supported | Requires FFI-compatible database implementation |
| **macOS** | ❌ Not Supported | Requires FFI-compatible database implementation |
| **Linux** | ❌ Not Supported | Requires FFI-compatible database implementation |

## Why Web Is Not Supported

The application depends on several Flutter packages that are **not compatible with web**:

1. **`sqlite3_flutter_libs` + `drift`**: Uses `dart:ffi` for native SQLite bindings — unavailable in browsers
2. **`flutter_local_notifications`**: Android/iOS native notification APIs — no web equivalent
3. **`flutter_secure_storage`**: Platform-specific secure storage (Android Keystore / iOS Keychain) — no web equivalent
4. **`flutter_timezone`**: Accesses device timezone database — unavailable on web

## Adding Web Support (Future Consideration)

To support web in the future, the following would need to be addressed:

- Replace `sqlite3_flutter_libs` with a web-compatible database (e.g., Hive, IndexedDB via `drift` web support)
- Replace `flutter_local_notifications` with a web push notification service
- Replace `flutter_secure_storage` with web storage (with reduced security)
- Replace `flutter_timezone` with JavaScript `Intl` API

This would require significant architectural changes and is **not planned** for the MVP.

## Running the Application

### Android
```bash
# Run on connected device or emulator
flutter run -d android

# Or using the Android toolchain
cd android && ./gradlew installDebug
```

### iOS
```bash
# Run on connected device or simulator
flutter run -d ios

# Or via Xcode
open ios/Runner.xcworkspace
```

### Correct Development Workflow

Always run with a **mobile target**:
```bash
# List available mobile devices
flutter devices

# Run on a specific device (Android/iOS only)
flutter run -d <device_id>
```

**Do NOT attempt web targets:**
```bash
# ❌ These will fail:
flutter run -d chrome
flutter run -d edge
flutter run -d safari
```