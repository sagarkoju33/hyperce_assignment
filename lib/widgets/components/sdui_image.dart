import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/widget_config.dart';

class SduiImage extends StatelessWidget {
  final WidgetConfig config;
  const SduiImage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final url = config.url;
    final radius = BorderRadius.circular(config.borderRadius ?? 0);

    if (url == null || url.isEmpty) {
      return _placeholder(context, radius, icon: Icons.image_not_supported_outlined);
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: url,
        width: config.width,
        height: config.height,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder(context, radius, loading: true),
        errorWidget: (_, __, ___) =>
            _placeholder(context, radius, icon: Icons.broken_image_outlined),
      ),
    );
  }

  Widget _placeholder(
    BuildContext context,
    BorderRadius radius, {
    IconData icon = Icons.image_outlined,
    bool loading = false,
  }) {
    return Container(
      height: config.height ?? 180,
      width: config.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: radius,
      ),
      alignment: Alignment.center,
      child: loading
          ? const CircularProgressIndicator(strokeWidth: 2)
          : Icon(icon, color: Theme.of(context).colorScheme.outline),
    );
  }
}
