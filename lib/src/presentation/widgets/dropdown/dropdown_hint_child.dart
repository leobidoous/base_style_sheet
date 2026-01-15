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
    this.canFocus = false,
    this.canSearch = true,
    required this.onClear,
    this.onEditingComplete,
    required this.fontSize,
    required this.readOnly,
    required this.showClear,
    required this.isLoading,
    required this.isEnabled,
    required this.heightType,
    required this.isExpanded,
    required this.placeholder,
    required this.boxDecoration,
    required this.valueSelected,
    required this.rotateAnimation,
  });

  final Widget? icon;
  final bool canFocus;
  final bool readOnly;
  final bool canSearch;
  final bool isLoading;
  final bool isEnabled;
  final bool showClear;
  final double fontSize;
  final bool isExpanded;
  final Function()? onTap;
  final Widget? prefixIcon;
  final String placeholder;
  final Function() onClear;
  final String valueSelected;
  final TextStyle? itemStyle;
  final EdgeInsets? childPadding;
  final BoxDecoration? boxDecoration;
  final Function()? onEditingComplete;
  final DropdownHeightType heightType;
  final BoxConstraints? boxConstraints;
  final Animation<double> rotateAnimation;
  final Function(String?)? onSearchChanged;

  @override
  State<_DropdownHintChild> createState() => _DropdownHintChildState();
}

class _DropdownHintChildState extends State<_DropdownHintChild> {
  final _editingController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _editingController.text = widget.valueSelected;
  }

  @override
  void didUpdateWidget(covariant _DropdownHintChild oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _editingController.text = widget.valueSelected;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _editingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double get _buttonHeight {
    switch (widget.heightType) {
      case DropdownHeightType.medium:
        return AppThemeBase.buttonHeightMD;
      case DropdownHeightType.normal:
        return AppThemeBase.buttonHeightNM;
      case DropdownHeightType.small:
        return AppThemeBase.buttonHeightSM;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: widget.boxConstraints ?? const BoxConstraints(),
      child: IntrinsicWidth(
        stepWidth: widget.isExpanded
            ? widget.boxConstraints?.maxWidth ?? double.infinity
            : widget.boxConstraints?.minWidth,
        child: CustomInputField(
          autocorrect: true,
          onTap: widget.onTap,
          focusNode: _focusNode,
          enableSuggestions: true,
          enabled: widget.isEnabled,
          autofocus: widget.canFocus,
          borderSide: BorderSide.none,
          hintText: widget.placeholder,
          controller: _editingController,
          readOnly: widget.readOnly || !widget.canSearch,
          onChanged: (input) {
            widget.onTap?.call();
            widget.onSearchChanged?.call(input);
          },
          textInputAction: TextInputAction.done,
          fillColor: widget.boxDecoration?.color,
          onEditingComplete: widget.onEditingComplete,
          borderRadius: context.theme.borderRadiusNone,
          heightType: switch (widget.heightType) {
            DropdownHeightType.medium => InputHeightType.medium,
            DropdownHeightType.normal => InputHeightType.normal,
            DropdownHeightType.small => InputHeightType.small,
          },
          suffixIcon: widget.isLoading
              ? SizedBox(
                  width: _buttonHeight,
                  height: _buttonHeight,
                  child: CustomLoading(
                    width: widget.fontSize,
                    height: widget.fontSize,
                  ),
                )
              : SizedBox(
                  width: _buttonHeight,
                  height: _buttonHeight,
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
                                  DropdownHeightType.medium =>
                                    ButtonHeightType.medium,
                                  DropdownHeightType.normal =>
                                    ButtonHeightType.normal,
                                  DropdownHeightType.small =>
                                    ButtonHeightType.small,
                                },
                                icon: Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                ),
          prefixIcon: widget.prefixIcon == null
              ? null
              : SizedBox(
                  width: _buttonHeight,
                  height: _buttonHeight,
                  child: widget.prefixIcon,
                ),
        ),
      ),
    );
  }
}
