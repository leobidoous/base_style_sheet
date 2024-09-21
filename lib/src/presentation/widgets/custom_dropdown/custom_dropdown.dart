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
    this.labelWidget,
    this.maxHeight,
    this.listPadding,
    this.childPadding,
    this.boxDecoration,
    this.initialValue,
    this.boxConstraints,
    required this.items,
    required this.context,
    this.placeholder = '',
    this.isEnabled = true,
    this.readOnly = false,
    this.itemSelectedStyle,
    this.isLoading = false,
    this.isExpanded = false,
    this.useSafeArea = true,
    this.useParendRenderBox = true,
    this.heightType = DropdownHeightType.normal,
  });
  final Widget? icon;
  final bool readOnly;
  final bool isLoading;
  final bool isEnabled;
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
  final EdgeInsets? childPadding;
  final TextStyle? itemSelectedStyle;
  final BoxDecoration? boxDecoration;
  final DropdownHeightType heightType;
  final BoxConstraints? boxConstraints;
  final List<CustomDropdownItem<T>> items;
  final CustomDropdownItem<T>? initialValue;

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
  CustomDropdownItem<T>? _valueSelected;
  final _key = GlobalKey();
  bool _showClear = false;
  late double _maxHeight;
  late Offset _offset;
  late Size _size;

  @override
  void initState() {
    super.initState();
    _valueSelected = widget.initialValue;
    _showClear = _valueSelected != null && widget.onClear != null;
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
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
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
    dy = _isOnTop(constraints) ? _offset.dy : 0;
    return dy + (widget.useSafeArea ? _parentContextOffset.dy : 0);
  }

  double _getBottomPosition(BuildContext context, BoxConstraints constraints) {
    late double dy;
    dy = _isOnTop(constraints)
        ? Spacing.keyboardHeigth(context)
        : constraints.maxHeight - _offset.dy - _size.height;
    return (_isOnTop(constraints)
            ? dy
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
                color: Colors.transparent,
                child: InkWell(
                  onTap: Navigator.of(widget.context).pop,
                  child: _dropdownBuilder,
                ),
              );
            },
          ),
        )
        .whenComplete(_animationController.reverse);
  }

  bool get _isEnabled => !widget.isLoading && widget.isEnabled;

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
      child: Semantics(
        key: _key,
        button: true,
        child: Opacity(
          opacity: !_isEnabled ? .5 : 1,
          child: InkWell(
            onTap: widget.readOnly || !_isEnabled ? null : _showDropdown,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              decoration: widget.boxDecoration ??
                  BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: context.theme.borderRadiusLG,
                    border: Border.all(color: Colors.grey, width: .5),
                  ),
              child: ClipRRect(
                borderRadius: widget.boxDecoration?.borderRadius ??
                    context.theme.borderRadiusLG,
                child: _hintChild,
              ),
            ),
          ),
        ),
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
                      key: UniqueKey(),
                      child: Container(
                        decoration: widget.boxDecoration ??
                            BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: context.theme.borderRadiusLG,
                              border: Border.all(color: Colors.grey, width: .5),
                            ),
                        constraints: BoxConstraints(maxHeight: _maxHeight),
                        child: ClipRRect(
                          borderRadius: widget.boxDecoration?.borderRadius ??
                              context.theme.borderRadiusLG,
                          child: _DropdownBuilder(
                            width: _size.width,
                            items: widget.items,
                            isOnTop: _isOnTop(constraints),
                            boxDecoration: widget.boxDecoration,
                            onChanged: (item) {
                              setState(() {
                                _valueSelected = item;
                                widget.onChange?.call(item.value);
                                if (widget.onClear != null) _showClear = true;
                              });
                              Navigator.of(context).pop();
                            },
                            hintChild: _hintChild,
                            padding: widget.listPadding,
                            itemStyle: widget.itemStyle,
                            itemSelected: _valueSelected,
                            heightType: widget.heightType,
                            placeholder: widget.placeholder,
                            scrollController: _scrollController,
                            itemSelectedStyle: widget.itemSelectedStyle,
                          ),
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

  Widget get _hintChild {
    return _DropdownHintChild(
      onClear: () {
        setState(() {
          if (_valueSelected != null) {
            widget.onClear?.call(_valueSelected!.value);
          }
          _valueSelected = null;
          _showClear = false;
        });
      },
      icon: widget.icon,
      isEnabled: _isEnabled,
      showClear: _showClear,
      readOnly: widget.readOnly,
      itemStyle: widget.itemStyle,
      prefixIcon: widget.prefixIcon,
      isLoading: widget.isLoading,
      itemSelected: _valueSelected,
      heightType: widget.heightType,
      isExpanded: widget.isExpanded,
      placeholder: widget.placeholder,
      rotateAnimation: _rotateAnimation,
      childPadding: widget.childPadding,
      boxConstraints: widget.boxConstraints,
    );
  }
}
