import 'package:equatable/equatable.dart';

enum SduiActionType { navigate, openUrl, apiCall, snackbar, unknown }

SduiActionType _parseActionType(String? raw) {
  switch (raw) {
    case 'navigate':
      return SduiActionType.navigate;
    case 'open_url':
      return SduiActionType.openUrl;
    case 'api_call':
      return SduiActionType.apiCall;
    case 'snackbar':
      return SduiActionType.snackbar;
    default:
      return SduiActionType.unknown;
  }
}

class ActionConfig extends Equatable {
  final SduiActionType type;
  final String? route;
  final String? url;
  final String? endpoint;
  final String? method;
  final String? message;
  final String? onSuccessMessage;
  final String? onErrorMessage;
  final Map<String, dynamic> raw;

  const ActionConfig({
    required this.type,
    this.route,
    this.url,
    this.endpoint,
    this.method,
    this.message,
    this.onSuccessMessage,
    this.onErrorMessage,
    this.raw = const {},
  });

  factory ActionConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ActionConfig(type: SduiActionType.unknown);
    }
    return ActionConfig(
      type: _parseActionType(json['type'] as String?),
      route: json['route'] as String?,
      url: json['url'] as String?,
      endpoint: json['endpoint'] as String?,
      method: json['method'] as String?,
      message: json['message'] as String?,
      onSuccessMessage: json['onSuccessMessage'] as String?,
      onErrorMessage: json['onErrorMessage'] as String?,
      raw: json,
    );
  }

  @override
  List<Object?> get props => [type, route, url, endpoint, method, message];
}
