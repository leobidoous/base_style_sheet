import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

class CustomCheckboxTile<T> extends StatelessWidget {
  const CustomCheckboxTile({
    super.key,
    this.subtitle,
    this.onChanged,
    this.title,
    this.textTitle,
    this.isSelected = false,
    this.padding = EdgeInsets.zero,
    this.controlAffinity = ListTileControlAffinity.leading,
  });

  final Widget? title;
  final String? textTitle;
  final bool isSelected;
  final Widget? subtitle;
  final EdgeInsets padding;
  final Function(bool)? onChanged;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (controlAffinity == ListTileControlAffinity.leading) ...[
                    _boxCheck(context),
                    Spacing.sm.horizontal,
                  ],
                  Expanded(
                    child: title ??
                        Text(
                          textTitle ?? '',
                          style: context.textTheme.bodyMedium,
                        ),
                  ),
                  if (controlAffinity == ListTileControlAffinity.trailing) ...[
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: context.theme.borderRadiusXSM,
        border: Border.all(
          width: 1,
          color: isSelected
              ? context.colorScheme.primary
              : context.textTheme.bodyMedium?.color ?? Colors.grey,
        ),
      ),
      height: const Spacing(2).value,
      width: const Spacing(2).value,
      child: DecoratedBox(
        decoration: BoxDecoration(
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
