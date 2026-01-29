import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

/// [DotState] of [AnimatedDot]
enum DotState { opened, closed }

class AnimatedDot extends StatefulWidget {
  const AnimatedDot({
    super.key,
    this.onTap,
    this.dotSize,
    this.dotSizeSelected,
    this.selected = false,
  });

  final bool selected;
  final Function()? onTap;
  final Size? dotSize;
  final Size? dotSizeSelected;

  @override
  _AnimatedDotState createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<AnimatedDot>
    with SingleTickerProviderStateMixin {
  final duration = const Duration(milliseconds: 250);
  late final Animation<double> scaleAnimation;
  late final AnimationController controller;
  late DotState currentState;

  @override
  void initState() {
    currentState = widget.selected ? DotState.opened : DotState.closed;
    controller = AnimationController(vsync: this, duration: duration);
    controller.addListener(() {
      final double controllerValue = controller.value;
      if (controllerValue < 0.2) {
        currentState = DotState.closed;
      } else if (controllerValue > 0.8) {
        currentState = DotState.opened;
      }
    });
    scaleAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedDot oldWidget) {
    currentState = widget.selected ? DotState.opened : DotState.closed;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(
            color: widget.selected ? context.colorScheme.primary : Colors.grey,
            borderRadius: context.theme.borderRadiusLG,
          ),
          clipBehavior: .antiAliasWithSaveLayer,
          margin: const .symmetric(horizontal: 2),
          child: AnimatedSize(
            curve: Curves.easeIn,
            duration: duration,
            child: SizedBox(
              height: widget.selected
                  ? widget.dotSizeSelected?.height ?? const Spacing(1).value
                  : widget.dotSize?.height ?? const Spacing(1).value,
              width: widget.selected
                  ? widget.dotSizeSelected?.width ?? const Spacing(2).value
                  : widget.dotSize?.width ?? const Spacing(1).value,
            ),
          ),
        ),
      ),
    );
  }
}
