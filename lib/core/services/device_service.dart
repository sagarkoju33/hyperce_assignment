import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceService {
  final DeviceInfoPlugin _plugin = DeviceInfoPlugin();

  Future<String> get deviceLabel async {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final info = await _plugin.androidInfo;
        return '${info.brand} ${info.model}';
      case TargetPlatform.iOS:
        final info = await _plugin.iosInfo;
        return '${info.name} ${info.model}';
      default:
        return defaultTargetPlatform.name;
    }
  }
}
