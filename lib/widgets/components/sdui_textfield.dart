import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_config.dart';
import '../../state/screen_providers.dart';

class SduiTextField extends ConsumerStatefulWidget {
  final WidgetConfig config;
  const SduiTextField({super.key, required this.config});

  @override
  ConsumerState<SduiTextField> createState() => _SduiTextFieldState();
}

class _SduiTextFieldState extends ConsumerState<SduiTextField> {
  String? _validate(String? value) {
    final v = (value ?? '').trim();

    if (v.isEmpty) {
      return widget.config.required ? 'This field is required' : null;
    }

    switch (widget.config.validator) {
      case 'email':
        final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
        return emailRegex.hasMatch(v) ? null : 'Enter a valid email address';
      case 'number':
        if (value!.trim().isEmpty) return null;

        final number = num.tryParse(value);
        if (number == null) return 'Enter a valid number';
        if (number <= 0) return 'Number must be greater than 0';

        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final id =
        widget.config.id ?? widget.config.label ?? UniqueKey().toString();

    return TextFormField(
      keyboardType: widget.config.validator == 'number'
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.config.label,
        hintText: widget.config.hint,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _validate,
      onChanged: (value) {
        ref.read(formStateProvider.notifier).update(id, value);
      },
    );
  }
}
