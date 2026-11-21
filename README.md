# Mobile Device Name Resolver for Flutter

[![pub package](https://img.shields.io/pub/v/mobile_device_name.svg)](https://pub.dev/packages/mobile_device_name)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-flutter%20%7C%20android%20%7C%20ios-blue)](https://pub.dev/packages/mobile_device_name)

A blazing-fast, **100% offline** Flutter package that converts raw hardware model identifiers (such as Android `Build.MODEL` and Apple machine identifiers) into clean, consumer-friendly commercial marketing names in **$O(1)$ constant time**.

Powered by a pre-indexed database of **66,800+ devices** synchronizing automatically with official **Google Play Supported Devices** and **Apple IPSW & AppleDB APIs**.

---

## 🌟 Key Features

- **⚡ Instant $O(1)$ Lookup**: Single-hash table architecture with automatic lowercase normalization and whitespace trimming. Zero UI thread stutter or frame drops.
- **📱 66,800+ Devices Out-of-the-Box**:
  - **Android**: Full coverage of Samsung, Google Pixel, Xiaomi, OnePlus, Oppo, Vivo, Motorola, Sony, TCL, and more.
  - **Apple**: Complete catalog covering all generations of iPhone (from original to iPhone 16/17/18/e/Air/Duo), iPad (Standard, mini, Air, Pro M2/M3/M4), Apple Watch (Series 1–12, SE, Ultra 1–4), Apple Vision Pro, Apple TV, and Simulators.
- **🛡️ 100% Offline & Private**: Zero runtime network requests. Does not leak device information to any external server.
- **🔄 Monthly Automated Cloud Sync**: Equipped with a pre-configured GitHub Actions Cron workflow that updates the database on the 1st of every month at zero cost.
- **📦 Memory-Optimized**: Unified single-dictionary design cutting RAM usage by 50% compared to dual-mapping implementations.

---

## 🚀 Getting Started

### 1. Installation

Add the package to your `pubspec.yaml`:

```bash
flutter pub add mobile_device_name
```

Or manually:

```yaml
dependencies:
  mobile_device_name: ^1.0.0
```

### 2. Initialization

Initialize the database once during app startup, typically in `main()`:

```dart
import 'package:flutter/material.dart';
import 'package:mobile_device_name/mobile_device_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the device database into memory
  await MobileDeviceName.instance.initialize();

  runApp(const MyApp());
}
```

---

## 💡 Usage Examples

### Synchronous Lookup ($O(1)$)

Use `getMarketingName` anywhere in your widgets or business logic:

```dart
// Android lookup by Model
final samsung = MobileDeviceName.instance.getMarketingName('SM-S918B');
print(samsung); // "Samsung Galaxy S23 Ultra"

// Android lookup with optional device codename fallback
final xiaomi = MobileDeviceName.instance.getMarketingName(
  '23021RAA2Y',
  device: 'topaz',
);
print(xiaomi); // "Xiaomi Redmi Note 12"

// Apple lookup by machine identifier
final iphone = MobileDeviceName.instance.getMarketingName('iPhone17,1');
print(iphone); // "iPhone 16 Pro"

final ipad = MobileDeviceName.instance.getMarketingName('iPad16,3');
print(ipad); // "iPad Pro 11-inch (M4, Wi-Fi)"

// Case-insensitive & whitespace tolerant
final pixel = MobileDeviceName.instance.getMarketingName('  pixel 8 pro  ');
print(pixel); // "Google Pixel 8 Pro"
```

### Quick Asynchronous Resolver

If you prefer not to initialize upfront:

```dart
final name = await MobileDeviceName.resolve('SM-S918B');
print(name); // "Samsung Galaxy S23 Ultra"
```

---

## 📱 Real-World Integration with `device_info_plus`

Here is the standard pattern to resolve the current physical device's marketing name:

```dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_device_name/mobile_device_name.dart';

Future<String> getCurrentDeviceMarketingName() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return MobileDeviceName.instance.getMarketingName(
      androidInfo.model,
      device: androidInfo.device,
    );
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return MobileDeviceName.instance.getMarketingName(
      iosInfo.utsname.machine,
    );
  }

  return 'Unknown Device';
}
```

---

## 📖 API Reference

| Method / Property | Return Type | Description |
| :--- | :--- | :--- |
| `initialize({String? assetPath, Map? initialMap})` | `Future<void>` | Preloads the database from asset bundle. |
| `getMarketingName(String model, {String? device, String? fallback})` | `String` | Synchronous $O(1)$ resolver with case-insensitivity. |
| `resolve(String model, {String? device, String? fallback})` | `Future<String>` | Asynchronous resolver that auto-initializes if needed. |
| `loadRawMap(Map<String, String> map)` | `void` | Directly injects a custom lookup map (ideal for unit testing). |
| `deviceCount` | `int` | Total number of indexed devices currently in memory. |
| `isInitialized` | `bool` | Whether the mapping table is currently loaded. |

---

## ⚙️ Automated Cloud Sync via GitHub Actions

This repository includes a scheduled GitHub Actions workflow (`.github/workflows/update_device_map.yml`):
- **Schedule**: Automatically runs at `00:00 UTC` on the 1st of every month (`0 0 1 * *`).
- **Actions**:
  1. Fetches the latest Android database from **Google Play Supported Devices**.
  2. Synchronizes the latest Apple hardware IDs from **IPSW Downloads API** & **AppleDB**.
  3. Formats, deduplicates, and compiles into `assets/devices_map.json`.
  4. Automatically commits and pushes changes if new devices are released.
  5. *(Optional)* Sends an email notification report upon completion.

### Running the Crawler Locally

To manually trigger the crawler on your development machine:

```bash
# Fetch and merge both Android and Apple devices into assets/devices_map.json
python3 tool/update_devices.py

# Optional flags:
python3 tool/update_devices.py --apple-only   # Update Apple devices only
python3 tool/update_devices.py --skip-apple   # Update Android devices only
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/TNNam1408/mobile_device_name/issues).

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
