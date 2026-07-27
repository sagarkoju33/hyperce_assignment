import 'package:equatable/equatable.dart';
import 'action_config.dart';

class WidgetConfig extends Equatable {
  final String type;
  final Map<String, dynamic> properties;

  const WidgetConfig({required this.type, required this.properties});

  factory WidgetConfig.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    if (type is! String || type.isEmpty) {
      return WidgetConfig(type: '__missing_type__', properties: json);
    }
    return WidgetConfig(type: type, properties: json);
  }

  // ---- Common typed accessors -------------------------------------------------

  String? get id => properties['id'] as String?;
  String? get text => properties['text'] as String?;
  String? get url => properties['url'] as String?;
  String? get label => properties['label'] as String?;
  String? get hint => properties['hint'] as String?;
  String? get validator => properties['validator'] as String?;

  bool get required =>
      (properties['required'] as bool?) ?? (validator == 'required');
  String? get style => properties['style'] as String?;
  String? get backgroundColor => properties['backgroundColor'] as String?;
  double? get padding => (properties['padding'] as num?)?.toDouble();
  double? get height => (properties['height'] as num?)?.toDouble();
  double? get width => (properties['width'] as num?)?.toDouble();
  double? get borderRadius => (properties['borderRadius'] as num?)?.toDouble();
  String? get mainAxisAlignment => properties['mainAxisAlignment'] as String?;
  String? get crossAxisAlignment => properties['crossAxisAlignment'] as String?;

  Map<String, dynamic>? get textStyle =>
      properties['style'] is Map<String, dynamic>
      ? properties['style'] as Map<String, dynamic>
      : null;

  ActionConfig? get action => properties['action'] is Map<String, dynamic>
      ? ActionConfig.fromJson(properties['action'] as Map<String, dynamic>)
      : null;

  WidgetConfig? get child {
    final raw = properties['child'];
    if (raw is Map<String, dynamic>) return WidgetConfig.fromJson(raw);
    return null;
  }

  List<WidgetConfig> get children {
    final raw = properties['children'];
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(WidgetConfig.fromJson)
          .toList(growable: false);
    }
    return const [];
  }

  @override
  List<Object?> get props => [type, properties];
}
