import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> request(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Future<bool> camera() => request(Permission.camera);
  Future<bool> photos() => request(Permission.photos);
  Future<bool> microphone() => request(Permission.microphone);
  Future<bool> location() => request(Permission.location);
  Future<bool> notification() => request(Permission.notification);
  Future<bool> contacts() => request(Permission.contacts);
  Future<bool> bluetooth() => request(Permission.bluetooth);
  Future<bool> storage() => request(Permission.storage);
}
