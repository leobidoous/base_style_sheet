import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip({
    super.key,
    this.message,
    this.textAlign,
    this.globalKey,
    this.richMessage,
    this.triggerMode,
    this.verticalOffset,
    required this.child,
  });

  final Widget child;
  final String? message;
  final TextAlign? textAlign;
  final GlobalKey? globalKey;
  final double? verticalOffset;
  final InlineSpan? richMessage;
  final TooltipTriggerMode? triggerMode;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      excludeFromSemantics: true,
      key: globalKey ?? ValueKey('Tooltip_$hashCode'),
      verticalOffset: verticalOffset ?? Spacing.md.value,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: context.theme.borderRadiusSM,
      ),
      textStyle: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onPrimary,
      ),
      richMessage: richMessage,
      triggerMode: triggerMode,
      textAlign: textAlign ?? TextAlign.center,
      child: child,
    );
  }
}
