import 'package:flutter/material.dart';

import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

class CustomRadioTile<T> extends StatelessWidget {
  const CustomRadioTile({
    super.key,
    this.subtitle,
    this.onChanged,
    required this.title,
    required this.value,
    this.padding = .zero,
    this.isEnabled = true,
    this.isSelected = false,
    this.controlAffinity = .leading,
    this.crossAxisAlignment = .center,
  });

  final T value;
  final Widget title;
  final bool isEnabled;
  final bool isSelected;
  final Widget? subtitle;
  final EdgeInsetsGeometry padding;
  final Function(T value)? onChanged;
  final CrossAxisAlignment crossAxisAlignment;
  final ListTileControlAffinity controlAffinity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : .5,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: isEnabled ? () => onChanged?.call(value) : null,
          child: Padding(
            padding: padding,
            child: Column(
              spacing: Spacing.xxs.value,
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  spacing: Spacing.sm.value,
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    if (controlAffinity == .leading) _radioCheck(context),
                    Expanded(child: title),
                    if (controlAffinity == .trailing) _radioCheck(context),
                  ],
                ),
                ?subtitle,
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
        shape: .circle,
        border: .all(
          width: 1,
          color: isSelected
              ? context.colorScheme.primary
              : Colors.grey.shade300,
        ),
      ),
      height: const Spacing(2.75).value,
      width: const Spacing(2.75).value,
      padding: .all(const Spacing(.4).value),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: .circle,
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surface,
        ),
      ),
    );
  }
}
