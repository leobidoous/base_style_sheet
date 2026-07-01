import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../extensions/build_context_extensions.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.color,
    this.onTap,
    this.shaddow,
    this.border,
    this.constraints,
    this.borderRadius,
    this.padding = .zero,
    this.isEnabled = true,
    this.isSelected = false,
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
      child: Semantics(
        button: onTap != null,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
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
                  border:
                      border ??
                      .all(
                        width: .05,
                        color: isSelected
                            ? context.colorScheme.primary
                            : color ??
                                  context.theme.shadowLightmodeLevel1.color
                                      .withValues(alpha: .01),
                      ),
                  borderRadius: borderRadius ?? context.theme.borderRadiusMD,
                  boxShadow: shaddow == null
                      ? [context.theme.shadowLightmodeLevel1]
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
      ),
    );
  }
}
