import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../../core/themes/typography/typography_constants.dart';
import '../extensions/build_context_extensions.dart';
import 'custom_loading.dart';

class TextLink extends StatelessWidget {
  const TextLink({
    super.key,
    this.icon,
    this.onTap,
    this.maxLines,
    this.styleText,
    required this.text,
    this.underline = true,
    this.isEnabled = true,
    this.isLoading = false,
    this.textAlign = .center,
    this.controlAffinity = .trailing,
  });

  final String text;
  final int? maxLines;
  final bool underline;
  final bool isEnabled;
  final bool isLoading;
  final IconData? icon;
  final Function()? onTap;
  final TextAlign? textAlign;
  final TextStyle? styleText;
  final ListTileControlAffinity controlAffinity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: !isLoading && isEnabled && onTap != null ? 1 : .5,
      child: Semantics(
        button: true,
        child: InkWell(
          borderRadius: context.theme.borderRadiusMD,
          onTap: !isLoading && isEnabled ? onTap : null,
          child: Row(
            mainAxisSize: .min,
            spacing: Spacing.xxs.value,
            children: [
              if (controlAffinity == .leading)
                if (icon != null) _icon,
              Flexible(
                child: Text(
                  text,
                  maxLines: maxLines,
                  textAlign: textAlign,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                  style:
                      styleText ??
                      context.textTheme.bodyMedium?.copyWith(
                        color: context.textTheme.bodyMedium?.color,
                        fontWeight: context.textTheme.fontWeightMedium,
                        decoration: underline ? TextDecoration.underline : null,
                        decorationColor: context.textTheme.bodyMedium?.color,
                      ),
                ),
              ),
              if (controlAffinity == .trailing)
                if (icon != null) _icon,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _icon {
    return Builder(
      builder: (context) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading
              ? CustomLoading(
                  width: AppFontSize.bodyMedium.value,
                  height: AppFontSize.bodyMedium.value,
                )
              : Icon(
                  icon,
                  color:
                      styleText?.color ?? context.textTheme.bodyMedium?.color,
                  size: AppFontSize.bodyMedium.value,
                ),
        );
      },
    );
  }
}
