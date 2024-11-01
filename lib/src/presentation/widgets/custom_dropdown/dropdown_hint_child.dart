part of 'custom_dropdown.dart';

class _DropdownHintChild<T> extends StatelessWidget {
  const _DropdownHintChild({
    this.icon,
    this.itemStyle,
    this.prefixIcon,
    this.value = '',
    this.childPadding,
    this.boxConstraints,
    required this.onClear,
    required this.fontSize,
    required this.readOnly,
    required this.showClear,
    required this.isLoading,
    required this.isEnabled,
    required this.heightType,
    required this.isExpanded,
    required this.placeholder,
    required this.rotateAnimation,
  });
  final Widget? icon;
  final String value;
  final bool readOnly;
  final bool isLoading;
  final bool isEnabled;
  final bool showClear;
  final double fontSize;
  final bool isExpanded;
  final Widget? prefixIcon;
  final String placeholder;
  final Function() onClear;
  final TextStyle? itemStyle;
  final EdgeInsets? childPadding;
  final DropdownHeightType heightType;
  final BoxConstraints? boxConstraints;
  final Animation<double> rotateAnimation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: childPadding ?? EdgeInsets.only(left: fontSize),
      constraints: boxConstraints ??
          BoxConstraints(
            minHeight: switch (heightType) {
              DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
              DropdownHeightType.small => AppThemeBase.buttonHeightSM,
            },
            maxHeight: AppThemeBase.buttonHeightMD,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                if (prefixIcon != null)
                  SizedBox(
                    width: switch (heightType) {
                      DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                      DropdownHeightType.small => AppThemeBase.buttonHeightSM,
                    },
                    height: switch (heightType) {
                      DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                      DropdownHeightType.small => AppThemeBase.buttonHeightSM,
                    },
                    child: prefixIcon,
                  ),
                isExpanded
                    ? Expanded(child: _textValue(context))
                    : Flexible(child: _textValue(context)),
              ],
            ),
          ),
          Spacing.xxs.horizontal,
          if (isLoading)
            CustomShimmer(
              width: switch (heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              height: switch (heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
            ),
          if (!isLoading) ...[
            SizedBox(
              width: switch (heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              height: switch (heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              child: showClear
                  ? CustomButton.icon(
                      type: ButtonType.noShape,
                      onPressed: readOnly || !isEnabled ? null : onClear,
                      heightType: switch (heightType) {
                        DropdownHeightType.small => ButtonHeightType.small,
                        DropdownHeightType.normal => ButtonHeightType.normal,
                      },
                      icon: Icons.close,
                    )
                  : AbsorbPointer(
                      child: icon ??
                          RotationTransition(
                            turns: rotateAnimation,
                            child: CustomButton.icon(
                              type: ButtonType.noShape,
                              heightType: switch (heightType) {
                                DropdownHeightType.normal =>
                                  ButtonHeightType.normal,
                                DropdownHeightType.small =>
                                  ButtonHeightType.small,
                              },
                              icon: Icons.keyboard_arrow_down_rounded,
                            ),
                          ),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _textValue(BuildContext context) {
    return ConstrainedBox(
      key: key,
      constraints: BoxConstraints(minWidth: const Spacing(.5).value),
      child: CustomScrollContent(
        scrollDirection: Axis.horizontal,
        alwaysScrollable: true,
        expanded: true,
        child: Text(
          value.isNotEmpty ? value : placeholder,
          textAlign: TextAlign.start,
          style: value.isEmpty
              ? context.textTheme.bodyMedium?.copyWith(
                  fontWeight: AppFontWeight.medium.value,
                  color: Colors.grey,
                  fontSize: fontSize,
                )
              : itemStyle ??
                  context.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppFontWeight.medium.value,
                    fontSize: fontSize,
                  ),
        ),
      ),
    );
  }
}
