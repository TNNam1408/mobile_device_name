import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Mobile Device Marketing Name Resolver for Flutter.
///
/// Resolves hardware model identifiers (e.g., "SM-S918B", "Pixel 8 Pro", "iPhone17,1")
/// or codenames (e.g., "dm3q", "husky") into commercial marketing names
/// (e.g., "Samsung Galaxy S23 Ultra", "Google Pixel 8 Pro", "iPhone 16 Pro").
class MobileDeviceName {
  static final MobileDeviceName _instance = MobileDeviceName._internal();

  /// Returns the singleton instance of [MobileDeviceName].
  static MobileDeviceName get instance => _instance;

  MobileDeviceName._internal();

  /// Normalized storage {lowercase_model -> marketing_name} for O(1) instant lookup.
  final Map<String, String> _deviceMap = {};

  bool _isInitialized = false;

  /// Default asset path when consumed as an external package.
  static const String packageAssetPath = 'packages/mobile_device_name/assets/devices_map.json';

  /// Fallback asset path when running locally in root project or test environment.
  static const String defaultAssetPath = 'assets/devices_map.json';

  /// Whether the database has been loaded into memory.
  bool get isInitialized => _isInitialized;

  /// Total number of indexed devices (Android & Apple).
  int get deviceCount => _deviceMap.length;

  /// Initializes the device mapping database from assets or a custom map.
  ///
  /// Call this once before querying, typically in `main()` after `WidgetsFlutterBinding.ensureInitialized()`.
  Future<void> initialize({
    String? assetPath,
    Map<String, String>? initialMap,
  }) async {
    if (initialMap != null && initialMap.isNotEmpty) {
      loadRawMap(initialMap);
      return;
    }

    final pathsToTry = <String>[
      if (assetPath != null) assetPath,
      packageAssetPath,
      defaultAssetPath,
    ];

    for (final path in pathsToTry) {
      try {
        final jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> decoded = json.decode(jsonString);

        _deviceMap.clear();
        decoded.forEach((key, value) {
          if (value is String) {
            _deviceMap[key.trim().toLowerCase()] = value;
          }
        });

        _isInitialized = true;
        return;
      } catch (_) {
        // Try next candidate path
      }
    }

    if (kDebugMode) {
      debugPrint(
        '[MobileDeviceName] Warning: Could not load devices_map.json asset. '
        'Verify that assets/devices_map.json is declared in pubspec.yaml.',
      );
    }
    _isInitialized = true;
  }

  /// Directly loads raw data into memory. Useful for unit testing or custom sources.
  void loadRawMap(Map<String, String> map) {
    _deviceMap.clear();
    map.forEach((key, value) {
      _deviceMap[key.trim().toLowerCase()] = value;
    });
    _isInitialized = true;
  }

  /// Resolves the commercial marketing name synchronously in O(1) time.
  ///
  /// - [model]: Hardware model identifier (e.g. `Build.MODEL` on Android or machine identifier on iOS).
  /// - [device]: (Optional) Hardware codename (e.g. `Build.DEVICE` on Android).
  /// - [fallback]: (Optional) Custom string to return if no match is found. Defaults to the original trimmed [model].
  String getMarketingName(String model, {String? device, String? fallback}) {
    final originalTrimmed = model.trim();
    if (originalTrimmed.isEmpty) {
      return fallback ?? '';
    }

    // 1. Direct O(1) case-insensitive lookup by Model
    final lowerModel = originalTrimmed.toLowerCase();
    final modelMatch = _deviceMap[lowerModel];
    if (modelMatch != null) {
      return modelMatch;
    }

    // 2. Direct O(1) case-insensitive lookup by Device codename
    if (device != null && device.trim().isNotEmpty) {
      final lowerDevice = device.trim().toLowerCase();
      final deviceMatch = _deviceMap[lowerDevice];
      if (deviceMatch != null) {
        return deviceMatch;
      }
    }

    // 3. Fallback to specified value or the raw model string
    return fallback ?? originalTrimmed;
  }

  /// Convenience asynchronous resolver that automatically initializes if not already loaded.
  static Future<String> resolve(
    String model, {
    String? device,
    String? fallback,
    String? assetPath,
  }) async {
    if (!instance.isInitialized) {
      await instance.initialize(assetPath: assetPath);
    }
    return instance.getMarketingName(model, device: device, fallback: fallback);
  }
}
