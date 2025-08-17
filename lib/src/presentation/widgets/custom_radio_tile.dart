import 'package:flutter/material.dart';

import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

class CustomRadioTile<T> extends StatelessWidget {
  const CustomRadioTile({
    super.key,
    this.subtitle,
    this.onChanged,
    this.enabled = true,
    required this.title,
    required this.value,
    this.isSelected = false,
    this.padding = EdgeInsets.zero,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.controlAffinity = ListTileControlAffinity.leading,
  });

  final T value;
  final bool enabled;
  final Widget title;
  final bool isSelected;
  final Widget? subtitle;
  final Function(T)? onChanged;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final ListTileControlAffinity controlAffinity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .5,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: enabled ? () => onChanged?.call(value) : null,
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    if (controlAffinity == ListTileControlAffinity.leading) ...[
                      _radioCheck(context),
                      Spacing.sm.horizontal,
                    ],
                    Expanded(child: title),
                    if (controlAffinity ==
                        ListTileControlAffinity.trailing) ...[
                      Spacing.xs.horizontal,
                      _radioCheck(context),
                    ],
                  ],
                ),
                if (subtitle != null) ...[Spacing.xxs.vertical, subtitle!],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _radioCheck(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color:
              isSelected ? context.colorScheme.primary : Colors.grey.shade300,
        ),
      ),
      height: const Spacing(2.75).value,
      width: const Spacing(2.75).value,
      padding: EdgeInsets.all(const Spacing(.4).value),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surface,
        ),
      ),
    );
  }
}
