import 'package:flutter/material.dart';

import '../../../../base_style_sheet.dart' show CustomCard;
import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../controllers/paged_list_controller.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../containers/custom_shimmer.dart';
import '../custom_loading.dart';
import '../custom_scroll_content.dart';
import '../dividers/custom_divider.dart';
import '../empties/list_empty.dart';
import '../errors/custom_request_error.dart';
import '../inputs/custom_input_field.dart';
import '../inputs/input_label.dart';
import '../paged_list/paged_list_view.dart';

part 'dropdown_builder.dart';
part 'dropdown_hint_child.dart';
part 'dropdrown_list.dart';

enum DropdownHeightType { medium, normal, small }

class CustomDropdownItem<T> {
  const CustomDropdownItem({
    this.item,
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
  final Widget? item;

  CustomDropdownItem<T> copyWith({String? label}) {
    return CustomDropdownItem(value: value, label: label ?? this.label);
  }
}

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    this.icon,
    this.onClear,
    this.onChanged,
    this.prefixIcon,
    this.itemStyle,
    this.maxHeight,
    this.validator,
    this.value = '',
    this.validators,
    this.inputLabel,
    this.listPadding,
    this.borderRadius,
    this.childPadding,
    this.boxDecoration,
    this.boxConstraints,
    this.listController,
    this.onSearchChanged,
    this.verticalSpacing,
    this.items = const [],
    this.placeholder = '',
    this.isEnabled = true,
    this.readOnly = false,
    this.itemSelectedStyle,
    this.isLoading = false,
    this.canSearch = false,
    this.isExpanded = true,
    this.heightType = .medium,
    this.autovalidateMode = .disabled,
  });
  final Widget? icon;
  final String value;
  final bool readOnly;
  final bool isLoading;
  final bool isEnabled;
  final bool canSearch;
  final bool isExpanded;
  final double? maxHeight;
  final Widget? prefixIcon;
  final String placeholder;
  final Function()? onClear;
  final TextStyle? itemStyle;
  final InputLabel? inputLabel;
  final EdgeInsets? listPadding;
  final double? verticalSpacing;
  final EdgeInsets? childPadding;
  final BorderRadius? borderRadius;
  final Function(T value)? onChanged;
  final TextStyle? itemSelectedStyle;
  final BoxDecoration? boxDecoration;
  final DropdownHeightType heightType;
  final BoxConstraints? boxConstraints;
  final List<CustomDropdownItem<T>> items;
  final AutovalidateMode autovalidateMode;
  final String? Function(String? input)? validator;
  final List<String? Function(String? input)>? validators;
  final Function(String? input, {bool isReset})? onSearchChanged;
  final PagedListController<dynamic, CustomDropdownItem<T>>? listController;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  late final PagedListController<dynamic, CustomDropdownItem<T>>
  _listController;
  final ValueNotifier<String> _valueSelected = ValueNotifier('');
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _rotateAnimation;
  final _scrollController = ScrollController();
  bool _canForceValidator = false;
  String _textSearchFilter = '';
  OverlayEntry? _overlayEntry;
  final _key = GlobalKey();
  bool _showClear = false;
  late double _maxHeight;
  late Offset _offset;
  late Size _size;

  bool get _isEnabled => !widget.isLoading && widget.isEnabled;

  double get _fontSize {
    switch (widget.heightType) {
      case .medium:
        return AppFontSize.bodyMedium.value;
      case .normal:
        return (AppFontSize.bodyMedium.value + AppFontSize.bodySmall.value) / 2;
      case .small:
        return AppFontSize.bodySmall.value;
    }
  }

  BorderRadius get _borderRadius {
    switch (widget.heightType) {
      case .medium:
        return widget.borderRadius ?? context.theme.borderRadiusLG;
      case .normal:
        return widget.borderRadius ?? context.theme.borderRadiusLG;
      case .small:
        return widget.borderRadius ?? context.theme.borderRadiusLG;
    }
  }

  @override
  void initState() {
    super.initState();
    _valueSelected.value = widget.value;
    _showClear = widget.value.isNotEmpty && widget.onClear != null;
    _animationController = AnimationController(
      duration: Durations.medium1,
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_animationController);
    _rotateAnimation = Tween<double>(
      begin: 1,
      end: .5,
    ).animate(_animationController);

    _listController =
        widget.listController ??
        PagedListController(
          preventNewFetch: true,
          pageSize: widget.items.length,
        );

    if (widget.listController == null) {
      _listController.setListener(({
        required int pageKey,
        int? pageSize,
      }) async {
        return widget.items
            .where(
              (e) => e.label.toLowerCase().contains(
                _textSearchFilter.toLowerCase(),
              ),
            )
            .toList();
      });
    }
  }

  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    _textSearchFilter = '';
    _showClear =
        (_valueSelected.value.isNotEmpty || _textSearchFilter.isNotEmpty) &&
        widget.onClear != null;
    if (widget.autovalidateMode != .disabled) {
      _canForceValidator = _valueSelected.value.isEmpty;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.listController == null) _listController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    _valueSelected.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onChangedItem(BuildContext context, CustomDropdownItem<T> item) {
    setState(() {
      _textSearchFilter = '';
      _valueSelected.value = item.label;
      widget.onChanged?.call(item.value);
    });
    _removeOverlay();
  }

  void _showDropdown() {
    if (_overlayEntry != null) return;

    _animationController.forward();

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: _dropdownChild(overlay.context),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    try {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayEntry = null;
      FocusScope.of(context).requestFocus(FocusNode());
      _animationController.isCompleted ? _animationController.reverse() : null;
    } catch (e) {
      // Caso o dropdown seja fechado rapidamente após aberto, pode ocorrer
      // uma exceção ao tentar remover o overlay. Nesse caso, apenas ignoramos.
    }
  }

  void _getWidgetInfos(BuildContext overlayContext) {
    try {
      final renderBox = _key.currentContext?.findRenderObject() as RenderBox;
      final overlayRenderBox = overlayContext.findRenderObject() as RenderBox?;
      _size = renderBox.size;
      _offset = renderBox.localToGlobal(.zero, ancestor: overlayRenderBox);
    } catch (e) {
      // Caso o dropdown seja fechado rapidamente após aberto, pode ocorrer
      // uma exceção ao tentar pegar o renderBox. Nesse caso, apenas ignoramos.
    }
  }

  bool _isOnTop(BoxConstraints constraints) {
    return (_offset.dy + (_size.height / 2)) <= constraints.maxHeight / 2;
  }

  double _getTopPosition(BoxConstraints constraints) {
    return _isOnTop(constraints)
        ? _offset.dy
        : (widget.verticalSpacing ?? Spacing.sm.value);
  }

  double _getBottomPosition(BuildContext context, BoxConstraints constraints) {
    late double dy;
    dy = _isOnTop(constraints)
        ? (widget.verticalSpacing ?? Spacing.sm.value)
        : constraints.maxHeight - _offset.dy - _size.height;
    return (_isOnTop(constraints)
        ? dy + (widget.verticalSpacing ?? Spacing.sm.value)
        : Spacing.keyboardHeigth(context) > dy
        ? Spacing.keyboardHeigth(context) +
              (widget.verticalSpacing ?? Spacing.sm.value)
        : dy);
  }

  double get _getLeftPosition {
    return _offset.dx;
  }

  double _getRightPosition(BoxConstraints constraints) {
    return constraints.maxWidth - _offset.dx - _size.width;
  }

  double _getMaxHeight(BuildContext context, BoxConstraints constraints) {
    final mediaQuery = MediaQuery.of(context);
    final safeAreaTop = mediaQuery.padding.top;
    final safeAreaBottom = mediaQuery.padding.bottom;
    final padding = widget.verticalSpacing ?? Spacing.sm.value;

    if (widget.maxHeight != null) return widget.maxHeight!;

    if (_isOnTop(constraints)) {
      return constraints.maxHeight - _offset.dy - safeAreaBottom - padding;
    } else {
      return _offset.dy + _size.height - safeAreaTop - padding;
    }
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: widget.isExpanded ? .stretch : .start,
          children: [
            if (widget.inputLabel != null) ...[
              widget.inputLabel!,
              Spacing.xxxs.vertical,
            ],
            Flexible(
              child: AnimatedOpacity(
                opacity: _opacityAnimation.value,
                duration: .zero,
                child: child,
              ),
            ),
          ],
        );
      },
      child: FormField<String>(
        enabled: _isEnabled,
        validator: _validator,
        initialValue: _valueSelected.value,
        key: ValueKey(_valueSelected.value),
        autovalidateMode: widget.autovalidateMode,
        forceErrorText: _canForceValidator
            ? _validator(_valueSelected.value)
            : null,
        builder: (c) {
          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: widget.isExpanded ? .stretch : .start,
            children: [
              Semantics(
                key: _key,
                child: _container(child: _hintChild, hasError: c.hasError),
              ),
              if (c.hasError) ...[
                Padding(
                  padding: .only(
                    top: Spacing.xxs.value,
                    left: widget.childPadding?.left ?? Spacing.xs.value,
                    right: widget.childPadding?.right ?? Spacing.xs.value,
                  ),
                  child: Text(
                    c.errorText ?? '',
                    style: c.context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.error,
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

  Widget _container({
    double? maxHeight,
    required Widget child,
    bool hasError = false,
  }) {
    return DecoratedBox(
      decoration:
          widget.boxDecoration ??
          BoxDecoration(
            color: widget.isEnabled ? context.colorScheme.surface : null,
            borderRadius: _borderRadius,
            border: .all(
              color: hasError ? context.colorScheme.error : Colors.grey,
              width: widget.isEnabled ? .5 : .25,
            ),
          ),
      child: ConstrainedBox(
        constraints:
            widget.boxConstraints ??
            BoxConstraints(
              maxHeight: maxHeight?.abs() ?? AppThemeBase.buttonHeightMD,
            ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return IntrinsicWidth(
              stepWidth: widget.isExpanded
                  ? widget.boxConstraints?.maxWidth ?? .infinity
                  : (widget.boxConstraints?.minWidth ?? 0) <
                        constraints.minWidth
                  ? widget.boxConstraints?.minWidth
                  : null,
              child: ClipRRect(
                borderRadius:
                    widget.boxDecoration?.borderRadius ?? _borderRadius,
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dropdownChild(BuildContext overlayContext) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _getWidgetInfos(overlayContext);
        _maxHeight = _getMaxHeight(context, constraints);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (Spacing.keyboardIsOpened(context)) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  } else {
                    _removeOverlay();
                    widget.onSearchChanged?.call('', isReset: true);
                  }
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: _getLeftPosition,
              top: _getTopPosition(constraints),
              right: _getRightPosition(constraints),
              bottom: _getBottomPosition(overlayContext, constraints),
              child: GestureDetector(
                onTap: () {}, // Previne que o tap no dropdown o feche
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  mainAxisAlignment: _isOnTop(constraints) ? .start : .end,
                  children: [
                    Flexible(
                      child: _container(
                        maxHeight: _maxHeight,
                        child: _dropdownBuilder(constraints),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dropdownBuilder(BoxConstraints constraints) {
    return ValueListenableBuilder(
      valueListenable: _valueSelected,
      builder: (context, value, child) {
        return _DropdownBuilder(
          width: _size.width,
          items: widget.items,
          fontSize: _fontSize,
          valueSelected: value,
          hintChild: _hintChild,
          padding: widget.listPadding,
          itemStyle: widget.itemStyle,
          heightType: widget.heightType,
          isOnTop: _isOnTop(constraints),
          listController: _listController,
          listPadding: widget.listPadding,
          placeholder: widget.placeholder,
          scrollController: _scrollController,
          itemSelectedStyle: widget.itemSelectedStyle,
          boxDecoration:
              widget.boxDecoration ??
              BoxDecoration(
                borderRadius: _borderRadius,
                color: context.colorScheme.surface,
                border: .all(color: Colors.grey, width: .5),
              ),
          onChanged: (item) => _onChangedItem(context, item),
        );
      },
    );
  }

  Widget get _hintChild {
    return ValueListenableBuilder(
      valueListenable: _valueSelected,
      builder: (context, value, child) {
        return _DropdownHintChild(
          onClear: () {
            if (_animationController.isForwardOrCompleted) {
              Navigator.of(context).pop();
            }
            setState(() {
              widget.onClear?.call();
              _textSearchFilter = '';
              _valueSelected.value = '';
              if (widget.onSearchChanged == null) {
                _listController.refresh();
              } else {
                widget.onSearchChanged?.call(_textSearchFilter, isReset: true);
              }
            });
          },
          onTap: () {
            if (_animationController.isDismissed && !widget.readOnly) {
              _showDropdown();
            }
          },
          onSearchChanged: (input) {
            _textSearchFilter = input ?? '';
            if (widget.onSearchChanged == null) {
              _listController.refresh();
            } else {
              widget.onSearchChanged?.call(_textSearchFilter, isReset: false);
            }
          },
          icon: widget.icon,
          fontSize: _fontSize,
          isEnabled: _isEnabled,
          showClear: _showClear,
          readOnly: widget.readOnly,
          canSearch: widget.canSearch,
          isLoading: widget.isLoading,
          prefixIcon: widget.prefixIcon,
          heightType: widget.heightType,
          placeholder: widget.placeholder,
          rotateAnimation: _rotateAnimation,
          boxDecoration: widget.boxDecoration,
          valueSelected: _valueSelected.value,
          canFocus: _animationController.isForwardOrCompleted,
          onEditingComplete: () {
            if (_listController.value.isNotEmpty) {
              _onChangedItem(
                context,
                _listController.value.firstWhere(
                  (e) => e.label == _valueSelected.value,
                  orElse: () => _listController.value.first,
                ),
              );
            }
          },
        );
      },
    );
  }
}
