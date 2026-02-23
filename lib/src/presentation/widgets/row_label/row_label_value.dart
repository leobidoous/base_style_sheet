import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';

class RowLabelValue extends StatelessWidget {
  const RowLabelValue({
    super.key,
    this.style,
    this.styleBold,
    this.labelStyle,
    this.label = '',
    this.value = '',
    this.valueStyle,
    this.tooltipIcon,
    this.valueWidget,
    this.labelWidget,
    this.onTapTooltip,
    this.flexLabel = 4,
    this.flexValue = 6,
    this.tooltipIconColor,
    this.mainAxisAlignment,
    this.isAllBold = false,
    this.crossAxisAlignment,
    this.isLabelBold = false,
    this.isValueBold = false,
    this.showTooltip = false,
  });

  final String label;
  final String value;
  final int? flexLabel;
  final int? flexValue;
  final bool isAllBold;
  final bool isLabelBold;
  final bool isValueBold;
  final bool showTooltip;
  final TextStyle? style;
  final Widget? valueWidget;
  final Widget? labelWidget;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TextStyle? styleBold;
  final IconData? tooltipIcon;
  final Color? tooltipIconColor;
  final Function()? onTapTooltip;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? context.textTheme.bodyMedium;

    final defaultStyleBold =
        styleBold ??
        context.textTheme.bodyMedium?.copyWith(
          fontWeight: AppFontWeight.bold.value,
        );

    return Row(
      mainAxisSize: .min,
      crossAxisAlignment: crossAxisAlignment ?? .center,
      mainAxisAlignment: mainAxisAlignment ?? .spaceBetween,
      children: [
        Flexible(
          flex: flexLabel ?? 1,
          child:
              labelWidget ??
              Row(
                mainAxisSize: .min,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style:
                          labelStyle ??
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
                        size:
                            labelStyle?.fontSize ??
                            defaultStyle?.fontSize ??
                            AppFontSize.iconButton.value,
                        color:
                            tooltipIconColor ??
                            style?.color ??
                            defaultStyleBold?.color,
                      ),
                    ),
                  ],
                ],
              ),
        ),
        Flexible(
          flex: flexValue ?? 1,
          child:
              valueWidget ??
              Text(
                value,
                textAlign: .end,
                style:
                    valueStyle ??
                    (isAllBold || isValueBold
                        ? defaultStyleBold
                        : defaultStyle),
              ),
        ),
      ],
    );
  }
}
