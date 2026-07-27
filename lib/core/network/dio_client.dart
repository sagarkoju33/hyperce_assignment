import 'package:dio/dio.dart';

import 'package:b1/app/config/constants.dart';
import 'package:b1/app/config/environment.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';

class DioClient {
  DioClient({
    Dio? dio,
    Future<String?> Function()? tokenProvider,
    Future<void> Function()? onUnauthorized,
  }) : _dio = dio ?? Dio() {
    _dio
      ..options = BaseOptions(
        baseUrl: AppEnvironment.apiBaseUrl,
        connectTimeout: AppConstants.defaultTimeout,
        receiveTimeout: AppConstants.defaultTimeout,
        headers: {'Accept': 'application/json'},
      )
      ..interceptors.addAll([
        AuthInterceptor(tokenProvider: tokenProvider),
        if (onUnauthorized != null)
          UnauthorizedInterceptor(onUnauthorized: onUnauthorized),
        RetryInterceptor(_dio),
        ErrorInterceptor(),
        if (!AppEnvironment.isProduction) createLoggerInterceptor(),
      ]);
  }

  final Dio _dio;
  Dio get dio => _dio;
}
