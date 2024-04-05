import 'package:flutter/material.dart';

import '../../core/themes/app_theme_base.dart';
import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../../core/themes/typography/typography_constants.dart';
import '../extensions/build_context_extensions.dart';
import 'containers/custom_shimmer.dart';
import 'custom_scroll_content.dart';
import 'dividers/custom_divider.dart';

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
    this.onChange,
    this.onClear,
    this.value = '',
    this.maxHeight,
    this.listPadding,
    this.itemStyle,
    this.childPadding,
    this.boxDecoration,
    this.boxConstraints,
    this.placeholder = '',
    required this.items,
    this.isEnabled = true,
    this.readOnly = false,
    this.itemSelectedStyle,
    this.isLoading = false,
    this.isExpanded = false,
  });

  final Widget? icon;
  final bool isExpanded;
  final String value;
  final bool readOnly;
  final bool isLoading;
  final bool isEnabled;
  final double? maxHeight;
  final String placeholder;
  final Function()? onClear;
  final TextStyle? itemStyle;
  final Function(T)? onChange;
  final EdgeInsets? listPadding;
  final EdgeInsets? childPadding;
  final TextStyle? itemSelectedStyle;
  final BoxDecoration? boxDecoration;
  final BoxConstraints? boxConstraints;
  final List<CustomDropdownItem<T>> items;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final TextEditingController textController;
  late final Animation<double> rotateAnimation;
  final scrollController = ScrollController();
  late final Animation<double> animation;
  final key = GlobalKey();
  bool showClear = false;
  late double maxHeight;
  late Offset offset;
  late Size size;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(
      text: widget.value.isNotEmpty ? widget.value : widget.placeholder,
    );
    showClear = widget.value.isNotEmpty && widget.onClear != null;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    rotateAnimation = Tween<double>(begin: 1, end: .5).animate(
      animationController,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  void _getWidgetInfo() {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox;
    size = renderBox.size;
    offset = renderBox.localToGlobal(Offset.zero);
  }

  bool isOnTop(BoxConstraints constraints) {
    return (offset.dy + (size.height / 2)) <= constraints.maxHeight / 2;
  }

  double getTopPosition(BoxConstraints constraints) {
    late double dy;
    dy = isOnTop(constraints) ? offset.dy : 0;
    return dy;
  }

  double getBottomPosition(BoxConstraints constraints) {
    late double dy;
    dy = isOnTop(constraints)
        ? 0
        : constraints.maxHeight - offset.dy - size.height;
    return dy;
  }

  double get getLeftPosition {
    late double left;
    left = widget.isExpanded ? widget.listPadding?.left ?? 0 : offset.dx;
    return left;
  }

  double getRightPosition(BoxConstraints constraints) {
    late double right;
    right = widget.isExpanded
        ? widget.listPadding?.right ?? 0
        : constraints.maxWidth - offset.dx - size.width;
    return right;
  }

  double getMaxHeight(BoxConstraints constraints) {
    return widget.maxHeight != null
        ? widget.maxHeight! > constraints.maxHeight
            ? constraints.maxHeight
            : widget.maxHeight!
        : isOnTop(constraints)
            ? constraints.maxHeight - getTopPosition(constraints)
            : constraints.maxHeight - getBottomPosition(constraints);
  }

  Future<void> _showDropdown() async {
    _getWidgetInfo();
    animationController.forward();
    await Navigator.of(context)
        .push(
          PageRouteBuilder(
            opaque: false,
            allowSnapshotting: true,
            barrierDismissible: true,
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
        .whenComplete(animationController.reverse);
  }

  bool get isEnabled {
    return widget.items.isNotEmpty && !widget.isLoading && widget.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: key,
      button: true,
      child: Opacity(
        opacity: !isEnabled ? .5 : 1,
        child: InkWell(
          onTap: widget.readOnly || !isEnabled ? null : _showDropdown,
          child: Container(
            decoration: widget.boxDecoration ??
                BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: context.theme.borderRadiusSM,
                  color: context.colorScheme.background,
                ),
            child: _child,
          ),
        ),
      ),
    );
  }

  Widget get _child {
    return Container(
      padding: widget.childPadding ??
          EdgeInsets.symmetric(
            horizontal: const Spacing(2).value,
            vertical: const Spacing(1).value,
          ),
      constraints: widget.boxConstraints ??
          BoxConstraints(
            minHeight: AppThemeBase.inputHeightMD,
            maxHeight: context.kSize.height * .45,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.isExpanded) Expanded(child: _textValue),
          if (!widget.isExpanded) Flexible(child: _textValue),
          Spacing.xs.horizontal,
          if (widget.isLoading)
            CustomShimmer(
              width: const Spacing(3).value,
              height: const Spacing(3).value,
            ),
          if (!widget.isLoading) ...[
            if (!showClear)
              SizedBox(
                width: const Spacing(3).value,
                child: widget.icon ??
                    RotationTransition(
                      turns: rotateAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: AppFontSize.titleLarge.value,
                      ),
                    ),
              ),
            if (showClear)
              SizedBox(
                width: const Spacing(3).value,
                child: Semantics(
                  button: true,
                  child: InkWell(
                    onTap: widget.readOnly || !isEnabled
                        ? null
                        : () {
                            setState(() {
                              textController.text = widget.placeholder;
                              widget.onClear?.call();
                              showClear = false;
                            });
                          },
                    child: widget.icon ??
                        Icon(
                          Icons.close,
                          size: AppFontSize.titleLarge.value,
                        ),
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
          textController.text,
          textAlign: TextAlign.start,
          style: (widget.value.isEmpty &&
                  widget.placeholder == textController.text)
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
        maxHeight = getMaxHeight(constraints);
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: isOnTop(constraints)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        decoration: widget.boxDecoration ??
                            BoxDecoration(
                              border: Border.all(color: Colors.grey, width: .5),
                              borderRadius: context.theme.borderRadiusSM,
                            ),
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        width: size.width,
                        child: ClipRRect(
                          borderRadius: widget.boxDecoration?.borderRadius ??
                              context.theme.borderRadiusSM,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isOnTop(constraints)) ...[
                                _child,
                                const CustomDivider(height: 0),
                              ],
                              Flexible(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: maxHeight,
                                  ),
                                  color: context.colorScheme.background,
                                  width: size.width,
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
      controller: scrollController,
      thumbColor: context.colorScheme.primary,
      radius: context.theme.borderRadiusXLG.bottomLeft,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        controller: scrollController,
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
                  textController.text = widget.items[index].label;
                  widget.onChange?.call(widget.items[index].value);
                  if (widget.onClear != null) showClear = true;
                });
                Navigator.of(context).pop();
              },
              child: widget.items[index].item ??
                  Padding(
                    padding: widget.listPadding ??
                        EdgeInsets.symmetric(
                          horizontal: const Spacing(2).value,
                          vertical: const Spacing(1.75).value,
                        ),
                    child: Text(
                      widget.items[index].label,
                      style: widget.items[index].label == textController.text
                          ? widget.itemSelectedStyle ??
                              context.textTheme.bodyMedium?.copyWith(
                                fontWeight: AppFontWeight.bold.value,
                                color: context.colorScheme.primary,
                              )
                          : widget.itemStyle ?? context.textTheme.bodyMedium,
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
}
