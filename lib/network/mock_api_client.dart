import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'api_client.dart';
import 'api_exception.dart';

class MockApiClient implements ApiClient {
  final Map<String, String> _routeToAsset = const {
    '/screen/home': 'assets/mock/screen_home.json',
    '/screen/details': 'assets/mock/screen_details.json',
    '/screen/profile': 'assets/mock/screen_profile.json',
  };

  final Duration latency;

  MockApiClient({this.latency = const Duration(milliseconds: 600)});

  @override
  Future<Map<String, dynamic>> get(String path) async {
    await Future.delayed(latency);

    final assetPath = _routeToAsset[path];
    if (assetPath == null) {
      throw ApiException.notFound(path);
    }

    try {
      final raw = await rootBundle.loadString(assetPath);
      return jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException catch (e) {
      throw ApiException.parsing(e);
    } catch (e) {
      throw ApiException.unknown(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    await Future.delayed(latency);

    if (path.startsWith('/action/')) {
      return {'success': true, 'echo': body ?? {}};
    }

    throw ApiException.notFound(path);
  }
}
