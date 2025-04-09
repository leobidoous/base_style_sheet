part of 'custom_dropdown.dart';

class _DropdownHintChild extends StatefulWidget {
  const _DropdownHintChild({
    this.icon,
    this.onTap,
    this.itemStyle,
    this.prefixIcon,
    this.childPadding,
    this.boxConstraints,
    this.onSearchChanged,
    required this.onClear,
    required this.fontSize,
    required this.readOnly,
    required this.showClear,
    required this.isLoading,
    required this.isEnabled,
    required this.heightType,
    required this.isExpanded,
    required this.placeholder,
    required this.boxDecoration,
    required this.textController,
    required this.rotateAnimation,
  });

  final Widget? icon;
  final bool readOnly;
  final bool isLoading;
  final bool isEnabled;
  final bool showClear;
  final double fontSize;
  final bool isExpanded;
  final Function()? onTap;
  final Widget? prefixIcon;
  final String placeholder;
  final Function() onClear;
  final TextStyle? itemStyle;
  final EdgeInsets? childPadding;
  final BoxDecoration? boxDecoration;
  final DropdownHeightType heightType;
  final BoxConstraints? boxConstraints;
  final Animation<double> rotateAnimation;
  final Function(String?)? onSearchChanged;
  final TextEditingController textController;

  @override
  State<_DropdownHintChild> createState() => _DropdownHintChildState();
}

class _DropdownHintChildState extends State<_DropdownHintChild> {
  
  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      autofocus: true,
      autocorrect: true,
      onTap: widget.onTap,
      enableSuggestions: true,
      readOnly: widget.readOnly,
      enabled: widget.isEnabled,
      borderSide: BorderSide.none,
      hintText: widget.placeholder,
      controller: widget.textController,
      onChanged: (input) {
        widget.onTap?.call();
        widget.onSearchChanged?.call(input);
      },
      fillColor: widget.boxDecoration?.color,
      borderRadius: context.theme.borderRadiusNone,
      heightType: switch (widget.heightType) {
        DropdownHeightType.normal => InputHeightType.normal,
        DropdownHeightType.small => InputHeightType.small,
      },
      suffixIcon: widget.isLoading
          ? SizedBox(
              width: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              height: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              child: CustomLoading(
                width: widget.fontSize,
                height: widget.fontSize,
              ),
            )
          : SizedBox(
              width: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              height: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              child: widget.showClear
                  ? Center(
                      child: CustomButton.icon(
                        type: ButtonType.noShape,
                        onPressed: widget.readOnly || !widget.isEnabled
                            ? null
                            : widget.onClear,
                        heightType: ButtonHeightType.small,
                        icon: Icons.close,
                      ),
                    )
                  : widget.icon ??
                      RotationTransition(
                        turns: widget.rotateAnimation,
                        child: CustomButton.icon(
                          type: ButtonType.noShape,
                          heightType: switch (widget.heightType) {
                            DropdownHeightType.normal =>
                              ButtonHeightType.normal,
                            DropdownHeightType.small => ButtonHeightType.small,
                          },
                          icon: Icons.keyboard_arrow_down_rounded,
                        ),
                      ),
            ),
      prefixIcon: widget.prefixIcon == null
          ? null
          : SizedBox(
              width: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              height: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              child: widget.prefixIcon,
            ),
    );
  }
}
