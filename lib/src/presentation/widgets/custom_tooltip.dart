import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.triggerMode,
    this.verticalOffset,
  });

  final String message;
  final Widget child;
  final double? verticalOffset;
  final TooltipTriggerMode? triggerMode;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      verticalOffset: verticalOffset ?? Spacing.md.value,
      excludeFromSemantics: true,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: context.theme.borderRadiusSM,
      ),
      textStyle: context.textTheme.bodyMedium,
      enableFeedback: true,
      triggerMode: triggerMode,
      child: child,
    );
  }
}
