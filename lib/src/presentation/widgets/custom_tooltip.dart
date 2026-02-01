import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip({
    super.key,
    this.color,
    this.margin,
    this.padding,
    this.border,
    this.message,
    this.textAlign,
    this.boxShadow,
    this.globalKey,
    this.richMessage,
    this.triggerMode,
    this.verticalOffset,
    required this.child,
  });

  final Widget child;
  final Color? color;
  final String? message;
  final BoxBorder? border;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final TextAlign? textAlign;
  final GlobalKey? globalKey;
  final double? verticalOffset;
  final InlineSpan? richMessage;
  final List<BoxShadow>? boxShadow;
  final TooltipTriggerMode? triggerMode;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      excludeFromSemantics: true,
      key: globalKey ?? ValueKey('Tooltip_$hashCode'),
      verticalOffset: verticalOffset ?? Spacing.md.value,
      textStyle: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onPrimary,
      ),
      decoration: BoxDecoration(
        border:
            border ??
            Border.all(
              width: .05,
              color: context.colorScheme.onSurface.withValues(alpha: .01),
            ),
        borderRadius: context.theme.borderRadiusSM,
        color: color ?? context.colorScheme.primary,
        boxShadow: boxShadow ?? [context.theme.shadowLightmodeLevel0],
      ),

      margin: margin,
      padding: padding,
      richMessage: richMessage,
      triggerMode: triggerMode,
      textAlign: textAlign ?? .center,
      child: child,
    );
  }
}
