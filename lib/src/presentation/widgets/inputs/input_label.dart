import 'package:flutter/material.dart';

import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({
    super.key,
    required this.label,
    this.hasError = false,
    this.isRequired = false,
    this.color,
  });
  final String label;
  final Color? color;
  final bool hasError;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: AppFontWeight.medium.value,
                color: context.colorScheme.error,
              ),
            ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodyMedium?.copyWith(
        fontWeight: AppFontWeight.medium.value,
        color: color,
      ),
    );
  }
}
