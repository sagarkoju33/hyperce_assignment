import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/action_config.dart';
import '../../state/screen_providers.dart';

class ActionHandler {
  ActionHandler._();

  static Future<void> execute(
    BuildContext context,
    WidgetRef ref,
    ActionConfig? action,
  ) async {
    if (action == null) return;

    switch (action.type) {
      case SduiActionType.navigate:
        if (action.route != null && action.route!.isNotEmpty) {
          Navigator.of(context).pushNamed(action.route!);
        }
        break;

      case SduiActionType.openUrl:
        if (action.url != null) {
          final uri = Uri.tryParse(action.url!);
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else if (context.mounted) {
            _showSnackbar(context, 'Could not open link.');
          }
        }
        break;

      case SduiActionType.snackbar:
        if (context.mounted) {
          _showSnackbar(context, action.message ?? '');
        }
        break;

      case SduiActionType.apiCall:
        await _handleApiCall(context, ref, action);
        break;

      case SduiActionType.unknown:
        debugPrint('SDUI: unknown action type received: ${action.raw}');
        break;
    }
  }

  static Future<void> _handleApiCall(
    BuildContext context,
    WidgetRef ref,
    ActionConfig action,
  ) async {
    if (action.endpoint == null) return;

    final formState = Form.of(context);
    if (!formState.validate()) {
      _showSnackbar(context, 'Please fix the highlighted fields.');
      return;
    }

    final repo = ref.read(screenRepositoryProvider);
    final formValues = ref.read(formStateProvider);

    final result = await repo.performAction(
      action.endpoint!,
      method: action.method ?? 'POST',
      body: formValues,
    );

    if (!context.mounted) return;

    result.when(
      success: (_) =>
          _showSnackbar(context, action.onSuccessMessage ?? 'Success'),
      failure: (message, _) =>
          _showSnackbar(context, action.onErrorMessage ?? message),
    );
  }

  static void _showSnackbar(BuildContext context, String message) {
    if (message.isEmpty) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
