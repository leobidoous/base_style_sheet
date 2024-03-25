import 'package:flutter/material.dart';

import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({
    super.key,
    required this.label,
    this.hasError = false,
    this.color,
  });
  final String label;
  final Color? color;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodyMedium?.copyWith(
        fontWeight: AppFontWeight.medium.value,
        color: color,
      ),
    );
  }
}
