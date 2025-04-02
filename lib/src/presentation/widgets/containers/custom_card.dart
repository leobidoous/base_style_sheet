import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../extensions/build_context_extensions.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.color,
    this.onTap,
    this.shaddow,
    this.border,
    this.constraints,
    this.borderRadius,
    required this.child,
    this.isEnabled = true,
    this.isSelected = false,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final Color? color;
  final Border? border;
  final bool isEnabled;
  final bool isSelected;
  final Function()? onTap;
  final EdgeInsets padding;
  final List<BoxShadow>? shaddow;
  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : .5,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: borderRadius ?? context.theme.borderRadiusMD,
        child: AbsorbPointer(
          absorbing: !isEnabled,
          child: ConstrainedBox(
            constraints: constraints ?? BoxConstraints(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colorScheme.primary
                    : color ?? context.colorScheme.surface,
                border: border ??
                    Border.all(
                      width: .05,
                      color: isSelected
                          ? context.colorScheme.primary
                          : color ??
                              context.colorScheme.onSurface.withValues(
                                alpha: .01,
                              ),
                    ),
                borderRadius: borderRadius ?? context.theme.borderRadiusMD,
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
