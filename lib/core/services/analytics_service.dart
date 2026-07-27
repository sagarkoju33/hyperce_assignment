class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {
    // Wire to Firebase Analytics / Segment / etc.
  }

  Future<void> setUserId(String? id) async {}

  Future<void> screenView(String screenName) async {
    await logEvent('screen_view', params: {'screen': screenName});
  }
}
