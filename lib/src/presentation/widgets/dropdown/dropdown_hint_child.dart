part of 'custom_dropdown.dart';

class _DropdownHintChild extends StatefulWidget {
  const _DropdownHintChild({
    this.icon,
    this.onTap,
    this.prefixIcon,
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
  final Function()? onTap;
  final Widget? prefixIcon;
  final String placeholder;
  final Function() onClear;
  final String valueSelected;
  final BoxDecoration? boxDecoration;
  final Function()? onEditingComplete;
  final DropdownHeightType heightType;
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
      case .medium:
        return AppThemeBase.buttonHeightMD;
      case .normal:
        return AppThemeBase.buttonHeightNM;
      case .small:
        return AppThemeBase.buttonHeightSM;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      borderSide: .none,
      autocorrect: true,
      onTap: widget.onTap,
      focusNode: _focusNode,
      enableSuggestions: true,
      enabled: widget.isEnabled,
      autofocus: widget.canFocus,
      hintText: widget.placeholder,
      controller: _editingController,
      readOnly: widget.readOnly || !widget.canSearch,
      onChanged: (input) {
        widget.onTap?.call();
        widget.onSearchChanged?.call(input);
      },
      textInputAction: .done,
      fillColor: widget.boxDecoration?.color,
      onEditingComplete: widget.onEditingComplete,
      borderRadius: context.theme.borderRadiusNone,
      heightType: switch (widget.heightType) {
        .medium => .medium,
        .normal => .normal,
        .small => .small,
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
                        type: .noShape,
                        onPressed: widget.readOnly || !widget.isEnabled
                            ? null
                            : widget.onClear,
                        heightType: .small,
                        icon: Icons.close,
                      ),
                    )
                  : widget.icon ??
                        RotationTransition(
                          turns: widget.rotateAnimation,
                          child: CustomButton.icon(
                            type: .noShape,
                            heightType: switch (widget.heightType) {
                              .medium => .medium,
                              .normal => .normal,
                              .small => .small,
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
    );
  }
}
