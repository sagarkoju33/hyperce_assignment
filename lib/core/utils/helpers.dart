import 'package:flutter/foundation.dart';

abstract final class Helpers {
  static void debugLog(Object? message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print(message);
    }
  }

  static T? castOrNull<T>(Object? value) => value is T ? value : null;
}
