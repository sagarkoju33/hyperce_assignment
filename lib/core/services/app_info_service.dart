import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  PackageInfo? _info;

  Future<void> init() async {
    _info = await PackageInfo.fromPlatform();
  }

  String get appName => _info?.appName ?? '';
  String get version => _info?.version ?? '';
  String get buildNumber => _info?.buildNumber ?? '';
}
