import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../extensions/build_context_extensions.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.borderRadius,
    this.border,
    this.shaddow,
    this.color,
    this.onTap,
    this.constraints,
    required this.child,
    this.isSelected = false,
    this.isEnabled = true,
    this.padding = EdgeInsets.zero,
  });

  final Function()? onTap;
  final Widget child;
  final bool isSelected;
  final bool isEnabled;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? color;
  final List<BoxShadow>? shaddow;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : .5,
      child: Semantics(
        button: isEnabled ? onTap != null : null,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: AbsorbPointer(
            absorbing: !isEnabled,
            child: Container(
              constraints: constraints,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colorScheme.primary
                    : color ?? context.colorScheme.surface,
                borderRadius: borderRadius ?? context.theme.borderRadiusMD,
                border: border ??
                    Border.all(
                      color: isSelected
                          ? context.colorScheme.primary
                          : color ??
                              context.colorScheme.onSurface.withValues(
                                alpha: .01,
                              ),
                    ),
                boxShadow: shaddow == null
                    ? [context.theme.shadowLightmodeLevel0]
                    : (shaddow?.isEmpty ?? false)
                        ? null
                        : shaddow,
              ),
              child: ClipRRect(
                borderRadius: borderRadius ?? context.theme.borderRadiusMD,
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
