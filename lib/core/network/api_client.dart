import 'package:dio/dio.dart';

import 'dio_client.dart';

class ApiClient {
  ApiClient(this._client);

  final DioClient _client;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _client.dio.get<T>(path, queryParameters: query);

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
  }) =>
      _client.dio.post<T>(path, data: data);

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
  }) =>
      _client.dio.put<T>(path, data: data);

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
  }) =>
      _client.dio.patch<T>(path, data: data);

  Future<Response<T>> delete<T>(String path) =>
      _client.dio.delete<T>(path);

  Future<Response<T>> upload<T>(
    String path, {
    required FormData data,
  }) =>
      _client.dio.post<T>(path, data: data);
}
