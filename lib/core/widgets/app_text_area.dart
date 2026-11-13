import 'package:flutter/material.dart';

class AppTextArea extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool required;
  final bool enabled;

  const AppTextArea({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.minLines = 3,
    this.maxLines = 5,
    this.maxLength,
    this.validator,
    this.required = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF243C2A),
            ),
            children: [
              TextSpan(text: label),
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          validator: validator,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(hintText: hint, alignLabelWithHint: true),
        ),
      ],
    );
  }
}
