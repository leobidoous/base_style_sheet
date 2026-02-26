part of 'custom_dropdown.dart';

class _DropdownHintChild extends StatefulWidget {
  const _DropdownHintChild({
    this.icon,
    this.onTap,
    this.prefixIcon,
    this.onSearchChanged,
    this.canFocus = true,
    this.canSearch = true,
    required this.onClear,
    this.onEditingComplete,
    required this.fontSize,
    required this.readOnly,
    required this.showClear,
    required this.isLoading,
    required this.isEnabled,
    required this.isExpanded,
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
  final bool isExpanded;
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
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (widget.canFocus && widget.canSearch) {
        _focusNode.requestFocus();
        _editingController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _editingController.text.length,
        );
      }
    });
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
      autocorrect: false,
      onTap: widget.onTap,
      focusNode: _focusNode,
      textInputAction: .done,
      enableSuggestions: true,
      autofocus: widget.canFocus,
      isEnabled: widget.isEnabled,
      hintText: widget.placeholder,
      isExpanded: widget.isExpanded,
      controller: _editingController,
      fillColor: widget.boxDecoration?.color,
      onEditingComplete: widget.onEditingComplete,
      borderRadius: context.theme.borderRadiusNone,
      readOnly: widget.readOnly || !widget.canSearch,
      onChanged: (input) {
        widget.onTap?.call();
        widget.onSearchChanged?.call(input);
      },
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
