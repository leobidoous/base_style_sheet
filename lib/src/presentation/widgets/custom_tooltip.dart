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
      excludeFromSemantics: true,
      verticalOffset: verticalOffset ?? Spacing.md.value,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: context.theme.borderRadiusSM,
      ),
      textStyle: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onPrimary,
      ),
      triggerMode: triggerMode,
      textAlign: TextAlign.center,
      child: child,
    );
  }
}
