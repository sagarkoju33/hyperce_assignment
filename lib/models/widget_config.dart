import 'package:equatable/equatable.dart';
import 'action_config.dart';

/// Generic, recursive representation of a single node in the server-driven
/// UI tree. Rather than modelling every widget type as its own Dart class
/// (which would require touching the parser every time a new widget type
/// is added), [WidgetConfig] stays close to the raw JSON and exposes
/// typed, null-safe accessors. Individual widget builders (see
/// `widgets/components/`) pull only the fields they care about.
///
/// This is what makes the "add a new widget type with minimal changes"
/// requirement possible: adding support for a new type means (1) adding a
/// case in `WidgetFactory` and (2) writing one new builder widget - the
/// model itself never needs to change.
class WidgetConfig extends Equatable {
  final String type;
  final Map<String, dynamic> properties;

  const WidgetConfig({required this.type, required this.properties});

  factory WidgetConfig.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    if (type is! String || type.isEmpty) {
      // Missing/invalid type is treated as its own explicit widget type so
      // the renderer can show a graceful inline error instead of crashing.
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
  // A field is mandatory if the backend explicitly sets "required": true,
  // OR (for backward compatibility with the original assignment JSON)
  // "validator": "required". This lets a field be *both* mandatory and
  // format-checked, e.g. {"validator": "email", "required": true}.
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
      properties['style'] is Map<String, dynamic> ? properties['style'] as Map<String, dynamic> : null;

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
