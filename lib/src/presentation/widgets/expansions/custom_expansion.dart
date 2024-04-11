import 'package:flutter/material.dart';

import '../buttons/custom_button.dart';

enum ExpansionState { opened, closed }

class CustomExpansion<T> extends StatefulWidget {
  const CustomExpansion({
    super.key,
    this.body,
    this.onTap,
    required this.title,
    this.isSelected = false,
    this.showTrailing = true,
    this.padding = EdgeInsets.zero,
    this.allowDismissOnBody = false,
    this.initialState = ExpansionState.closed,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final Widget title;
  final Widget? body;
  final bool isSelected;
  final bool showTrailing;
  final EdgeInsets padding;
  final Function()? onTap;
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
      duration: const Duration(milliseconds: 250),
    );
    switch (widget.initialState) {
      case ExpansionState.opened:
        _animation = Tween<double>(begin: 1, end: 0).animate(
          _animationController,
        );
        break;
      case ExpansionState.closed:
        _animation = Tween<double>(begin: 0, end: 1).animate(
          _animationController,
        );
        break;
    }
    _rotateAnimation = Tween<double>(begin: 1, end: .5).animate(
      _animationController,
    );
  }

  void forward() {
    _animationController.forward();
  }

  void reverse() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: widget.onTap ??
            () {
              if (_animationController.isCompleted) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }
            },
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedBuilder(
          animation: _animationController,
          child: Semantics(
            button: !widget.allowDismissOnBody,
            child: InkWell(
              onTap: !widget.allowDismissOnBody ? () {} : null,
              child: widget.body ?? const SizedBox(),
            ),
          ),
          builder: (_, child) {
            return Column(
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: widget.padding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: widget.title),
                      if (widget.showTrailing) ...[
                        RotationTransition(
                          turns: _rotateAnimation,
                          child: CustomButton.icon(
                            onPressed: () {
                              if (_animationController.isCompleted) {
                                _animationController.reverse();
                              } else {
                                _animationController.forward();
                              }
                            },
                            heightType: ButtonHeightType.small,
                            type: ButtonType.noShape,
                            icon: switch (widget.initialState) {
                              ExpansionState.opened =>
                                Icons.keyboard_arrow_up_rounded,
                              ExpansionState.closed =>
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
    );
  }
}
