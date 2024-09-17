part of 'custom_dropdown.dart';

class _DropdownHintChild<T> extends StatelessWidget {
  final Widget? icon;
  final bool readOnly;
  final bool isLoading;
  final bool isEnabled;
  final bool showClear;
  final bool isExpanded;
  final Widget? prefixIcon;
  final String placeholder;
  final Function() onClear;
  final TextStyle? itemStyle;
  final EdgeInsets? childPadding;
  final DropdownHeightType heightType;
  final BoxConstraints? boxConstraints;
  final Animation<double> rotateAnimation;
  final CustomDropdownItem<T>? itemSelected;

  const _DropdownHintChild({
    this.itemStyle,
    this.icon,
    this.prefixIcon,
    this.childPadding,
    this.itemSelected,
    this.boxConstraints,
    required this.onClear,
    required this.readOnly,
    required this.showClear,
    required this.isLoading,
    required this.isEnabled,
    required this.heightType,
    required this.isExpanded,
    required this.placeholder,
    required this.rotateAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: childPadding ?? EdgeInsets.only(left: Spacing.xs.value),
      constraints: boxConstraints ??
          BoxConstraints(
            minHeight: switch (heightType) {
              DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
              DropdownHeightType.small => AppThemeBase.buttonHeightSM,
            },
            maxHeight: context.kSize.height * .45,
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
                      onPressed: readOnly || !isEnabled ? null : onClear,
                      type: ButtonType.noShape,
                      heightType: switch (heightType) {
                        DropdownHeightType.normal => ButtonHeightType.normal,
                        DropdownHeightType.small => ButtonHeightType.small,
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
          itemSelected?.label ?? placeholder,
          textAlign: TextAlign.start,
          style: itemSelected == null
              ? context.textTheme.bodyMedium?.copyWith(
                  fontWeight: AppFontWeight.medium.value,
                  color: Colors.grey,
                )
              : itemStyle ??
                  context.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppFontWeight.medium.value,
                  ),
        ),
      ),
    );
  }
}
