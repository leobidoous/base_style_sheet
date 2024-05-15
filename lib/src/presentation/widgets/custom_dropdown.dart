import 'package:flutter/material.dart';

import '../../core/themes/app_theme_base.dart';
import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../../core/themes/typography/typography_constants.dart';
import '../extensions/build_context_extensions.dart';
import 'buttons/custom_button.dart';
import 'containers/custom_shimmer.dart';
import 'custom_scroll_content.dart';
import 'dividers/custom_divider.dart';

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
}

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    this.icon,
    this.onClear,
    this.prefixIcon,
    this.onChange,
    this.maxHeight,
    this.itemStyle,
    this.value = '',
    this.listPadding,
    this.childPadding,
    this.boxDecoration,
    this.boxConstraints,
    required this.items,
    required this.context,
    this.placeholder = '',
    this.isEnabled = true,
    this.readOnly = false,
    this.itemSelectedStyle,
    this.isLoading = false,
    this.isExpanded = false,
    this.heightType = DropdownHeightType.normal,
  });

  final Widget? icon;
  final String value;
  final bool readOnly;
  final bool isLoading;
  final bool isEnabled;
  final bool isExpanded;
  final double? maxHeight;
  final Widget? prefixIcon;
  final String placeholder;
  final Function()? onClear;
  final TextStyle? itemStyle;
  final BuildContext context;
  final Function(T)? onChange;
  final EdgeInsets? listPadding;
  final EdgeInsets? childPadding;
  final TextStyle? itemSelectedStyle;
  final BoxDecoration? boxDecoration;
  final DropdownHeightType heightType;
  final BoxConstraints? boxConstraints;
  final List<CustomDropdownItem<T>> items;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final TextEditingController _textController;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _rotateAnimation;
  final _scrollController = ScrollController();
  late Offset _parentContextOffset;
  final _key = GlobalKey();
  bool _showClear = false;
  late double _maxHeight;
  late Offset _offset;
  late Size _size;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.value.isNotEmpty ? widget.value : widget.placeholder,
    );
    _showClear = widget.value.isNotEmpty && widget.onClear != null;
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
    _textController.dispose();
    super.dispose();
  }

  void _getWidgetInfos() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    _size = renderBox.size;

    final parendRenderBox = widget.context.findRenderObject() as RenderBox;
    _parentContextOffset = parendRenderBox.localToGlobal(Offset.zero);

    _offset = renderBox.localToGlobal(Offset.zero, ancestor: parendRenderBox);
  }

  bool isOnTop(BoxConstraints constraints) {
    return (_offset.dy + (_size.height / 2)) <= constraints.maxHeight / 2;
  }

  double getTopPosition(BoxConstraints constraints) {
    late double dy;
    dy = isOnTop(constraints) ? _offset.dy : 0;
    return dy + _parentContextOffset.dy;
  }

  double getBottomPosition(BoxConstraints constraints) {
    late double dy;
    dy = isOnTop(constraints)
        ? 0
        : constraints.maxHeight - _offset.dy - _size.height;
    return dy - _parentContextOffset.dy;
  }

  double get getLeftPosition {
    late double left;
    left = widget.isExpanded ? widget.listPadding?.left ?? 0 : _offset.dx;
    return left;
  }

  double getRightPosition(BoxConstraints constraints) {
    late double right;
    right = widget.isExpanded
        ? widget.listPadding?.right ?? 0
        : constraints.maxWidth - _offset.dx - _size.width;
    return right;
  }

  double getMaxHeight(BoxConstraints constraints) {
    return widget.maxHeight != null
        ? widget.maxHeight! > constraints.maxHeight
            ? constraints.maxHeight
            : widget.maxHeight!
        : isOnTop(constraints)
            ? constraints.maxHeight -
                (getTopPosition(constraints) + _parentContextOffset.dy)
            : constraints.maxHeight -
                (getBottomPosition(constraints) - _parentContextOffset.dy);
  }

  Future<void> _showDropdown() async {
    _animationController.forward();
    await Navigator.of(widget.context)
        .push(
          PageRouteBuilder(
            opaque: false,
            maintainState: true,
            allowSnapshotting: true,
            settings: const RouteSettings(),
            barrierDismissible: true,
            fullscreenDialog: false,
            barrierColor: Colors.transparent,
            transitionDuration: const Duration(milliseconds: 150),
            reverseTransitionDuration: const Duration(milliseconds: 150),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Flexible(child: child)],
                ),
              );
            },
            pageBuilder: (_, animation, secondaryAnimation) {
              return Material(
                color: Colors.transparent,
                child: Semantics(
                  button: true,
                  child: InkWell(
                    onTap: Navigator.of(context).pop,
                    child: _dropdownBuilder,
                  ),
                ),
              );
            },
          ),
        )
        .whenComplete(_animationController.reverse);
  }

  bool get isEnabled {
    return widget.items.isNotEmpty && !widget.isLoading && widget.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return AnimatedOpacity(
          opacity: _opacityAnimation.value,
          duration: Duration.zero,
          child: child,
        );
      },
      child: Semantics(
        key: _key,
        button: true,
        child: Opacity(
          opacity: !isEnabled ? .5 : 1,
          child: InkWell(
            onTap: widget.readOnly || !isEnabled ? null : _showDropdown,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              decoration: widget.boxDecoration ??
                  BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: context.theme.borderRadiusXSM,
                    color: context.colorScheme.surface,
                  ),
              clipBehavior: Clip.hardEdge,
              child: ClipRRect(
                borderRadius: widget.boxDecoration?.borderRadius ??
                    context.theme.borderRadiusXSM,
                child: _child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _child {
    return Container(
      padding: widget.childPadding ?? EdgeInsets.only(left: Spacing.xs.value),
      decoration: BoxDecoration(
        borderRadius:
            widget.boxDecoration?.borderRadius ?? context.theme.borderRadiusXSM,
        color: widget.boxDecoration?.color ?? context.colorScheme.surface,
      ),
      constraints: widget.boxConstraints ??
          BoxConstraints(
            minHeight: switch (widget.heightType) {
              DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
              DropdownHeightType.small => AppThemeBase.buttonHeightSM,
            },
            maxHeight: context.kSize.height * .45,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.prefixIcon != null)
            SizedBox(
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
          if (widget.isExpanded) Expanded(child: _textValue),
          if (!widget.isExpanded) Flexible(child: _textValue),
          Spacing.xxs.horizontal,
          if (widget.isLoading)
            CustomShimmer(
              width: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              height: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
            ),
          if (!widget.isLoading) ...[
            SizedBox(
              width: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              height: switch (widget.heightType) {
                DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                DropdownHeightType.small => AppThemeBase.buttonHeightSM,
              },
              child: _showClear
                  ? CustomButton.icon(
                      onPressed: widget.readOnly || !isEnabled
                          ? null
                          : () {
                              setState(() {
                                _textController.text = widget.placeholder;
                                widget.onClear?.call();
                                _showClear = false;
                              });
                            },
                      type: ButtonType.noShape,
                      heightType: switch (widget.heightType) {
                        DropdownHeightType.normal => ButtonHeightType.normal,
                        DropdownHeightType.small => ButtonHeightType.small,
                      },
                      icon: Icons.close,
                    )
                  : widget.icon ??
                      RotationTransition(
                        turns: _rotateAnimation,
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
          ],
        ],
      ),
    );
  }

  Widget get _textValue {
    return Container(
      key: widget.key,
      constraints: BoxConstraints(minWidth: const Spacing(.5).value),
      child: CustomScrollContent(
        scrollDirection: Axis.horizontal,
        alwaysScrollable: true,
        expanded: true,
        child: Text(
          _textController.text,
          textAlign: TextAlign.start,
          style: (widget.value.isEmpty &&
                  widget.placeholder == _textController.text)
              ? context.textTheme.bodyMedium?.copyWith(
                  fontWeight: AppFontWeight.medium.value,
                  color: Colors.grey,
                )
              : widget.itemStyle ??
                  context.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppFontWeight.medium.value,
                  ),
        ),
      ),
    );
  }

  Widget get _dropdownBuilder {
    return LayoutBuilder(
      builder: (context, constraints) {
        _getWidgetInfos();
        _maxHeight = getMaxHeight(constraints);
        return SafeArea(
          top: !isOnTop(constraints),
          bottom: isOnTop(constraints),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: getLeftPosition,
                top: getTopPosition(constraints),
                right: getRightPosition(constraints),
                bottom: getBottomPosition(constraints),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: isOnTop(constraints)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        clipBehavior: Clip.none,
                        decoration: widget.boxDecoration ??
                            BoxDecoration(
                              borderRadius: context.theme.borderRadiusXSM,
                              border: Border.all(color: Colors.grey, width: .5),
                            ),
                        constraints: BoxConstraints(maxHeight: _maxHeight),
                        child: ClipRRect(
                          borderRadius: widget.boxDecoration?.borderRadius ??
                              context.theme.borderRadiusXSM,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isOnTop(constraints)) ...[
                                _child,
                                const CustomDivider(height: 0),
                              ],
                              Flexible(
                                child: SizedBox(
                                  width: _size.width,
                                  child: _listView,
                                ),
                              ),
                              if (!isOnTop(constraints)) ...[
                                const CustomDivider(height: 0),
                                _child,
                              ],
                            ],
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

  Widget get _listView {
    return RawScrollbar(
      padding: EdgeInsets.zero,
      controller: _scrollController,
      thumbColor: context.colorScheme.primary,
      radius: context.theme.borderRadiusXSM.bottomLeft,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        controller: _scrollController,
        itemCount: widget.items.length,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (_, __) => const CustomDivider(height: 0),
        itemBuilder: (context, index) {
          return Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                setState(() {
                  _textController.text = widget.items[index].label;
                  widget.onChange?.call(widget.items[index].value);
                  if (widget.onClear != null) _showClear = true;
                });
                Navigator.of(context).pop();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              radius: Spacing.md.value,
              child: Container(
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(
                  minHeight: switch (widget.heightType) {
                    DropdownHeightType.normal => AppThemeBase.buttonHeightMD,
                    DropdownHeightType.small => AppThemeBase.buttonHeightSM,
                  },
                ),
                child: widget.items[index].item ??
                    Padding(
                      padding: widget.listPadding ??
                          EdgeInsets.symmetric(horizontal: Spacing.xs.value),
                      child: CustomScrollContent(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.items[index].label,
                          style:
                              widget.items[index].label == _textController.text
                                  ? widget.itemSelectedStyle ??
                                      context.textTheme.bodyMedium?.copyWith(
                                        fontWeight: AppFontWeight.bold.value,
                                        color: context.colorScheme.primary,
                                      )
                                  : widget.itemStyle ??
                                      context.textTheme.bodyMedium,
                        ),
                      ),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
