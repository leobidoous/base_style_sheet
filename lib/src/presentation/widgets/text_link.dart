import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../../core/themes/typography/typography_constants.dart';
import '../extensions/build_context_extensions.dart';
import 'custom_loading.dart';

class TextLink extends StatelessWidget {
  const TextLink({
    super.key,
    required this.text,
    this.underline = true,
    this.isEnabled = true,
    this.isLoading = false,
    this.onTap,
    this.icon,
    this.styleText,
  });

  final Function()? onTap;
  final String text;
  final bool underline;
  final bool isEnabled;
  final bool isLoading;
  final IconData? icon;
  final TextStyle? styleText;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled && onTap != null ? 1 : .5,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: styleText ??
                    context.textTheme.bodyMedium?.copyWith(
                      color: context.textTheme.bodyMedium?.color,
                      fontWeight: context.textTheme.fontWeightMedium,
                      decoration: underline ? TextDecoration.underline : null,
                      decorationColor: context.textTheme.bodyMedium?.color,
                    ),
              ),
              if (icon != null) ...[
                Spacing.xxs.horizontal,
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isLoading
                      ? CustomLoading(
                          width: AppFontSize.bodyMedium.value,
                          height: AppFontSize.bodyMedium.value,
                        )
                      : Icon(
                          icon,
                          color: styleText?.color ??
                              context.textTheme.bodyMedium?.color,
                          size: AppFontSize.bodyMedium.value,
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
