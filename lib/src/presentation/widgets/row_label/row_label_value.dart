import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';

class RowLabelValue extends StatelessWidget {
  const RowLabelValue({
    super.key,
    required this.label,
    required this.value,
    this.isAllBold = false,
    this.isLabelBold = false,
    this.isValueBold = false,
    this.showTooltip = false,
    this.style,
    this.styleBold,
    this.labelStyle,
    this.valueStyle,
    this.tooltipIcon,
    this.onTapTooltip,
    this.tooltipIconColor,
    this.crossAxisAlignment,
    this.flexLabel = 4,
    this.flexValue = 6,
  });

  final String label;
  final String value;
  final bool isAllBold;
  final bool isLabelBold;
  final bool isValueBold;
  final bool showTooltip;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TextStyle? styleBold;
  final IconData? tooltipIcon;
  final Color? tooltipIconColor;
  final Function()? onTapTooltip;
  final CrossAxisAlignment? crossAxisAlignment;
  final int flexLabel;
  final int flexValue;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? context.textTheme.bodyMedium;

    final defaultStyleBold = styleBold ??
        context.textTheme.bodyMedium?.copyWith(
          fontWeight: AppFontWeight.bold.value,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: flexLabel,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  style: labelStyle ??
                      (isAllBold || isLabelBold
                          ? defaultStyleBold
                          : defaultStyle),
                ),
              ),
              if (showTooltip) ...[
                Spacing.xs.horizontal,
                InkWell(
                  onTap: onTapTooltip,
                  child: Icon(
                    tooltipIcon ?? Icons.info_outline_rounded,
                    size: labelStyle?.fontSize ?? defaultStyle?.fontSize,
                    color: tooltipIconColor ??
                        style?.color ??
                        defaultStyleBold?.color,
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          flex: flexValue,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: valueStyle ??
                (isAllBold || isValueBold ? defaultStyleBold : defaultStyle),
          ),
        ),
      ],
    );
  }
}
