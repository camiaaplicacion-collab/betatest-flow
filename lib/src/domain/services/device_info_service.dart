import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {
  DeviceInfoService({
    DeviceInfoPlugin? deviceInfoPlugin,
  }) : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  static const String _unknown = 'unknown';

  final DeviceInfoPlugin _deviceInfoPlugin;

  Future<Map<String, dynamic>> collectTechnicalData() async {
    final data = <String, dynamic>{
      'platform': _platformName(),
      'appVersion': _unknown,
      'buildNumber': _unknown,
      'deviceBrand': _unknown,
      'deviceModel': _unknown,
      'osVersion': _unknown,
      'androidVersion': _unknown,
      'androidSdkInt': null,
    };

    await _addPackageInfo(data);
    await _addDeviceInfo(data);

    return data;
  }

  Future<void> _addPackageInfo(Map<String, dynamic> data) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      data['appVersion'] = _orUnknown(packageInfo.version);
      data['buildNumber'] = _orUnknown(packageInfo.buildNumber);
    } catch (_) {
      // Keep default safe values when package metadata is unavailable.
    }
  }

  Future<void> _addDeviceInfo(Map<String, dynamic> data) async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        data['platform'] = 'web';
        data['deviceModel'] = _orUnknown(webInfo.browserName.name);
        data['osVersion'] = _orUnknown(webInfo.userAgent);
        return;
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final androidInfo = await _deviceInfoPlugin.androidInfo;
          data['platform'] = 'android';
          data['deviceBrand'] = _orUnknown(androidInfo.brand);
          data['deviceModel'] = _orUnknown(androidInfo.model);
          data['androidVersion'] = _orUnknown(androidInfo.version.release);
          data['androidSdkInt'] = androidInfo.version.sdkInt;
          data['osVersion'] = _orUnknown(androidInfo.version.release);
          return;
        case TargetPlatform.iOS:
          final iosInfo = await _deviceInfoPlugin.iosInfo;
          data['platform'] = 'ios';
          data['deviceModel'] = _orUnknown(iosInfo.utsname.machine);
          data['osVersion'] = _orUnknown(iosInfo.systemVersion);
          return;
        case TargetPlatform.macOS:
          final macOsInfo = await _deviceInfoPlugin.macOsInfo;
          data['platform'] = 'macos';
          data['deviceModel'] = _orUnknown(macOsInfo.model);
          data['osVersion'] = _orUnknown(macOsInfo.osRelease);
          return;
        case TargetPlatform.windows:
          final windowsInfo = await _deviceInfoPlugin.windowsInfo;
          data['platform'] = 'windows';
          data['deviceModel'] = _orUnknown(windowsInfo.computerName);
          data['osVersion'] = _orUnknown(windowsInfo.displayVersion);
          return;
        case TargetPlatform.linux:
          final linuxInfo = await _deviceInfoPlugin.linuxInfo;
          data['platform'] = 'linux';
          data['deviceModel'] = _orUnknown(linuxInfo.prettyName);
          data['osVersion'] = _orUnknown(linuxInfo.version);
          return;
        case TargetPlatform.fuchsia:
          data['platform'] = 'fuchsia';
          return;
      }
    } catch (_) {
      // Keep default safe values when specific platform information fails.
    }
  }

  String _platformName() {
    if (kIsWeb) {
      return 'web';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }

  String _orUnknown(String? value) {
    if (value == null || value.trim().isEmpty) {
      return _unknown;
    }
    return value;
  }
}