import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../containers/custom_shimmer.dart';
import '../custom_scroll_content.dart';
import '../dividers/custom_divider.dart';
import '../empties/list_empty.dart';
import '../inputs/custom_input_field.dart';
import '../inputs/input_label.dart';

part 'dropdown_builder.dart';
part 'dropdown_hint_child.dart';
part 'dropdrown_list.dart';

enum DropdownHeightType { normal, small }

class CustomDropdownItem<T> {
  const CustomDropdownItem({
    this.item,
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
  final Widget? item;

  CustomDropdownItem<T> copyWith({
    String? label,
  }) {
    return CustomDropdownItem(
      value: value,
      label: label ?? this.label,
    );
  }
}

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    this.icon,
    this.onClear,
    this.onChange,
    this.prefixIcon,
    this.itemStyle,
    this.maxHeight,
    this.validator,
    this.value = '',
    this.validators,
    this.labelWidget,
    this.listPadding,
    this.childPadding,
    this.boxDecoration,
    this.boxConstraints,
    required this.items,
    this.verticalSpacing,
    required this.context,
    this.placeholder = '',
    this.isEnabled = true,
    this.readOnly = false,
    this.itemSelectedStyle,
    this.isLoading = false,
    this.canSearch = false,
    this.isExpanded = false,
    this.useSafeArea = true,
    this.useParendRenderBox = true,
    this.heightType = DropdownHeightType.normal,
    this.autovalidateMode = AutovalidateMode.disabled,
  });
  final Widget? icon;
  final String value;
  final bool readOnly;
  final bool isLoading;
  final bool isEnabled;
  final bool canSearch;
  final bool isExpanded;
  final bool useSafeArea;
  final double? maxHeight;
  final Widget? prefixIcon;
  final String placeholder;
  final Function(T)? onClear;
  final TextStyle? itemStyle;
  final BuildContext context;
  final Function(T)? onChange;
  final InputLabel? labelWidget;
  final bool useParendRenderBox;
  final EdgeInsets? listPadding;
  final double? verticalSpacing;
  final EdgeInsets? childPadding;
  final TextStyle? itemSelectedStyle;
  final BoxDecoration? boxDecoration;
  final DropdownHeightType heightType;
  final BoxConstraints? boxConstraints;
  final List<CustomDropdownItem<T>> items;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? validator;
  final List<String? Function(String?)>? validators;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _rotateAnimation;
  final _scrollController = ScrollController();
  Offset _parentContextOffset = Offset.zero;
  bool _canForceValidator = false;
  final _key = GlobalKey();
  bool _showClear = false;
  late double _maxHeight;
  late Offset _offset;
  String _value = '';
  late Size _size;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _showClear = _value.isNotEmpty && widget.onClear != null;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      _animationController,
    );
    _rotateAnimation = Tween<double>(begin: 1, end: .5).animate(
      _animationController,
    );
  }

  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    _value = widget.value;
    if (widget.autovalidateMode != AutovalidateMode.disabled) {
      _canForceValidator = _value.isEmpty;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? _validator(String? input) {
    String? error = widget.validator?.call(input);
    widget.validators?.forEach((val) {
      if (error == null) {
        error = val(input);
        return;
      }
    });
    return error;
  }

  void _getWidgetInfos() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    _size = renderBox.size;
    RenderBox? parendRenderBox;

    if (widget.useParendRenderBox) {
      parendRenderBox = widget.context.findRenderObject() as RenderBox;
      _parentContextOffset = parendRenderBox.localToGlobal(Offset.zero);
    }

    _offset = renderBox.localToGlobal(Offset.zero, ancestor: parendRenderBox);
  }

  bool _isOnTop(BoxConstraints constraints) {
    return (_offset.dy + (_size.height / 2)) <= constraints.maxHeight / 2;
  }

  double _getTopPosition(BoxConstraints constraints) {
    late double dy;
    dy = _isOnTop(constraints)
        ? _offset.dy
        : (widget.verticalSpacing ?? Spacing.sm.value);
    return dy + (widget.useSafeArea ? _parentContextOffset.dy : 0);
  }

  double _getBottomPosition(BuildContext context, BoxConstraints constraints) {
    late double dy;
    dy = _isOnTop(constraints)
        ? Spacing.keyboardHeigth(context)
        : constraints.maxHeight - _offset.dy - _size.height;
    return (_isOnTop(constraints)
            ? dy + (widget.verticalSpacing ?? Spacing.sm.value)
            : Spacing.keyboardHeigth(context) > dy
                ? Spacing.keyboardHeigth(context)
                : dy) -
        (widget.useSafeArea ? _parentContextOffset.dy : 0);
  }

  double get _getLeftPosition {
    return widget.isExpanded ? (widget.listPadding?.left ?? 0) : _offset.dx;
  }

  double _getRightPosition(BoxConstraints constraints) {
    return widget.isExpanded
        ? widget.listPadding?.right ?? 0
        : constraints.maxWidth - _offset.dx - _size.width;
  }

  double _getMaxHeight(BuildContext context, BoxConstraints constraints) {
    return widget.maxHeight != null
        ? widget.maxHeight! > constraints.maxHeight
            ? constraints.maxHeight
            : widget.maxHeight!
        : _isOnTop(constraints)
            ? constraints.maxHeight -
                (_getTopPosition(constraints) +
                    (widget.useSafeArea ? _parentContextOffset.dy : 0))
            : constraints.maxHeight -
                (_getBottomPosition(context, constraints) -
                    (widget.useSafeArea ? _parentContextOffset.dy : 0));
  }

  Future<void> _showDropdown() async {
    _animationController.forward();
    FocusScope.of(widget.context).requestFocus(FocusNode());
    await Navigator.of(widget.context)
        .push(
          PageRouteBuilder(
            opaque: false,
            fullscreenDialog: true,
            barrierDismissible: true,
            barrierColor: Colors.transparent,
            transitionDuration: const Duration(milliseconds: 150),
            reverseTransitionDuration: const Duration(milliseconds: 150),
            settings: RouteSettings(name: '/custom_dropdown/$T'),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Flexible(child: child)],
                ),
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) {
              return Material(
                borderOnForeground: false,
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                child: _dropdownBuilder,
              );
            },
          ),
        )
        .whenComplete(_animationController.reverse);
  }

  bool get _isEnabled => !widget.isLoading && widget.isEnabled;

  double get _fontSize {
    switch (widget.heightType) {
      case DropdownHeightType.normal:
        return AppFontSize.bodyMedium.value;
      case DropdownHeightType.small:
        return AppFontSize.bodySmall.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.labelWidget != null) ...[
              widget.labelWidget!,
              Spacing.xxxs.vertical,
            ],
            Flexible(
              child: AnimatedOpacity(
                opacity: _opacityAnimation.value,
                duration: Duration.zero,
                child: child,
              ),
            ),
          ],
        );
      },
      child: FormField<String>(
        enabled: _isEnabled,
        initialValue: _value,
        validator: _validator,
        key: ValueKey(_value),
        autovalidateMode: widget.autovalidateMode,
        forceErrorText: _canForceValidator ? _validator(_value) : null,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                key: _key,
                button: true,
                child: Opacity(
                  opacity: !_isEnabled ? .5 : 1,
                  child: InkWell(
                    onTap:
                        widget.readOnly || !_isEnabled ? null : _showDropdown,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: _container(child: _hintChild),
                  ),
                ),
              ),
              if (context.hasError) ...[
                Padding(
                  padding: EdgeInsets.only(
                    top: Spacing.xxs.value,
                    left: widget.childPadding?.left ?? Spacing.xs.value,
                    right: widget.childPadding?.right ?? Spacing.xs.value,
                  ),
                  child: Text(
                    context.errorText ?? '',
                    style: context.context.textTheme.labelSmall?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget get _dropdownBuilder {
    return LayoutBuilder(
      builder: (context, constraints) {
        _getWidgetInfos();
        _maxHeight = _getMaxHeight(context, constraints);
        return SafeArea(
          top: !_isOnTop(constraints),
          bottom: _isOnTop(constraints),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: InkWell(
                  onTap: Navigator.of(widget.context).pop,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                left: _getLeftPosition,
                top: _getTopPosition(constraints),
                right: _getRightPosition(constraints),
                bottom: _getBottomPosition(context, constraints),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: _isOnTop(constraints)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: _container(
                        maxHeight: _maxHeight,
                        child: _DropdownBuilder(
                          value: _value,
                          width: _size.width,
                          items: widget.items,
                          fontSize: _fontSize,
                          canSearch: widget.canSearch,
                          isOnTop: _isOnTop(constraints),
                          boxDecoration: widget.boxDecoration ??
                              BoxDecoration(
                                color: context.colorScheme.surface,
                                borderRadius: context.theme.borderRadiusLG,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: .5,
                                ),
                              ),
                          onChanged: (item) {
                            setState(() {
                              _value = item.label;
                              widget.onChange?.call(item.value);
                              if (widget.onClear != null) _showClear = true;
                            });
                            Navigator.of(context).pop();
                          },
                          hintChild: _hintChild,
                          padding: widget.listPadding,
                          itemStyle: widget.itemStyle,
                          heightType: widget.heightType,
                          placeholder: widget.placeholder,
                          scrollController: _scrollController,
                          itemSelectedStyle: widget.itemSelectedStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _container({required Widget child, double? maxHeight}) {
    return Container(
      decoration: widget.boxDecoration ??
          BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: context.theme.borderRadiusLG,
            border: Border.all(color: Colors.grey, width: .5),
          ),
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? AppThemeBase.buttonHeightMD,
      ),
      child: ClipRRect(
        borderRadius:
            widget.boxDecoration?.borderRadius ?? context.theme.borderRadiusLG,
        child: child,
      ),
    );
  }

  Widget get _hintChild {
    return InkWell(
      onTap: !_animationController.isForwardOrCompleted
          ? null
          : () {
              if (_animationController.isForwardOrCompleted) {
                Navigator.of(context).pop();
              }
            },
      child: _DropdownHintChild(
        onClear: () {
          setState(() {
            _showClear = false;
            _value = '';
          });
          if (_animationController.isForwardOrCompleted) {
            Navigator.of(context).pop();
          }
        },
        value: _value,
        icon: widget.icon,
        fontSize: _fontSize,
        isEnabled: _isEnabled,
        showClear: _showClear,
        readOnly: widget.readOnly,
        itemStyle: widget.itemStyle,
        prefixIcon: widget.prefixIcon,
        isLoading: widget.isLoading,
        heightType: widget.heightType,
        isExpanded: widget.isExpanded,
        placeholder: widget.placeholder,
        rotateAnimation: _rotateAnimation,
        childPadding: widget.childPadding,
        boxConstraints: widget.boxConstraints,
      ),
    );
  }
}
