class NotificationService {
  Future<void> init() async {
    // Initialize FCM / local notifications here.
  }

  Future<String?> get token async => null;

  Future<void> showLocal({
    required String title,
    required String body,
  }) async {}
}
