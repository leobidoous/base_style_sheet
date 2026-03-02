import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

class CustomCheckboxTile<T> extends StatelessWidget {
  const CustomCheckboxTile({
    super.key,
    this.title,
    this.subtitle,
    this.onChanged,
    this.textTitle,
    this.padding = .zero,
    this.isSelected = false,
    this.controlAffinity = .leading,
  });

  final Widget? title;
  final bool isSelected;
  final Widget? subtitle;
  final String? textTitle;
  final EdgeInsets padding;
  final Function(bool value)? onChanged;
  final ListTileControlAffinity controlAffinity;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        focusColor: Colors.transparent,
        onTap: () => onChanged?.call(!isSelected),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Row(
                children: [
                  if (controlAffinity == .leading) ...[
                    _boxCheck(context),
                    Spacing.sm.horizontal,
                  ],
                  Expanded(
                    child:
                        title ??
                        Text(
                          textTitle ?? '',
                          style: context.textTheme.bodyMedium,
                        ),
                  ),
                  if (controlAffinity == .trailing) ...[
                    Spacing.sm.horizontal,
                    _boxCheck(context),
                  ],
                ],
              ),
              if (subtitle != null) ...[Spacing.xxs.vertical, subtitle!],
            ],
          ),
        ),
      ),
    );
  }

  Widget _boxCheck(BuildContext context) {
    return SizedBox(
      height: const Spacing(2).value,
      width: const Spacing(2).value,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: .all(
            width: 1,
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.onSurface.withValues(alpha: .75),
          ),
          borderRadius: context.theme.borderRadiusXSM,
          color: isSelected ? context.colorScheme.primary : Colors.transparent,
        ),
        child: isSelected
            ? Icon(
                Icons.check_rounded,
                color: context.colorScheme.surface,
                size: const Spacing(1.5).value,
              )
            : null,
      ),
    );
  }
}
