import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';

enum ExpansionState { opened, closed }

class CustomExpansion<T> extends StatefulWidget {
  const CustomExpansion({
    super.key,
    this.body,
    this.icon,
    this.onTap,
    this.iconColor,
    this.onForward,
    this.onReverse,
    required this.title,
    this.padding = .zero,
    this.isEnabled = true,
    this.allowExpand = true,
    this.isSelected = false,
    this.showTrailing = true,
    this.initialState = .closed,
    this.allowDismissOnBody = false,
    this.crossAxisAlignment = .stretch,
  });

  final Widget title;
  final Widget? body;
  final IconData? icon;
  final bool isEnabled;
  final bool isSelected;
  final Color? iconColor;
  final bool allowExpand;
  final bool showTrailing;
  final EdgeInsets padding;
  final Function()? onTap;
  final Function()? onForward;
  final Function()? onReverse;
  final bool allowDismissOnBody;
  final ExpansionState initialState;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<CustomExpansion<T>> createState() => CustomExpansionState<T>();
}

class CustomExpansionState<T> extends State<CustomExpansion<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _rotateAnimation;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.medium2,
      reverseDuration: Durations.medium2,
    );
    switch (widget.initialState) {
      case ExpansionState.opened:
        _animation = Tween<double>(
          begin: 1,
          end: 0,
        ).animate(_animationController);
        break;
      case ExpansionState.closed:
        _animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(_animationController);
        break;
    }
    _rotateAnimation = Tween<double>(
      begin: 1,
      end: .5,
    ).animate(_animationController);
  }

  void forward() {
    _animationController.forward();
  }

  void reverse() {
    _animationController.reverse();
  }

  bool get isExpanded => _animationController.isCompleted;
  bool get isAnimating => _animationController.isAnimating;
  bool get isDismissed => _animationController.isDismissed;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onChangeExpansion() {
    if (!widget.allowExpand) return;

    if (_animationController.isCompleted) {
      widget.onReverse?.call();
      _animationController.reverse();
    } else {
      widget.onForward?.call();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Opacity(
        opacity: widget.isEnabled ? 1 : .5,
        child: AbsorbPointer(
          absorbing: !widget.isEnabled,
          child: InkWell(
            onTap: () {
              widget.onTap != null ? widget.onTap!() : _onChangeExpansion();
            },
            borderRadius: context.theme.borderRadiusMD,
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            child: AnimatedBuilder(
              animation: _animationController,
              child: Semantics(
                button: !widget.allowDismissOnBody,
                child: InkWell(
                  borderRadius: context.theme.borderRadiusMD,
                  onTap: !widget.allowDismissOnBody ? () {} : null,
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  child: widget.body ?? const SizedBox(),
                ),
              ),
              builder: (_, child) {
                return Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: widget.crossAxisAlignment,
                  children: [
                    Padding(
                      padding: widget.padding,
                      child: Row(
                        mainAxisSize: .min,
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Flexible(child: widget.title),
                          if (widget.showTrailing) ...[
                            RotationTransition(
                              turns: _rotateAnimation,
                              child: CustomButton.icon(
                                type: .noShape,
                                heightType: .small,
                                iconColor: widget.iconColor,
                                onPressed: _onChangeExpansion,
                                icon:
                                    widget.icon ??
                                    switch (widget.initialState) {
                                      .opened =>
                                        Icons.keyboard_arrow_up_rounded,
                                      .closed =>
                                        Icons.keyboard_arrow_down_rounded,
                                    },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    FadeTransition(
                      opacity: _animation,
                      child: SizeTransition(
                        sizeFactor: _animation,
                        axisAlignment: 1,
                        child: child!,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
