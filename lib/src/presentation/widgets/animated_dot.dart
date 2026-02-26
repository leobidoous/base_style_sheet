import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/responsive/responsive_extension.dart' show Responsive;
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
    this.isSelected = false,
  });

  final Size? dotSize;
  final bool isSelected;
  final Function()? onTap;
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
    currentState = widget.isSelected ? DotState.opened : DotState.closed;
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
    currentState = widget.isSelected ? DotState.opened : DotState.closed;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: widget.onTap,
        radius: 100.responsiveHeight,
        child: AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? context.colorScheme.primary
                : context.colorScheme.onSurface.withValues(alpha: .1),
            borderRadius: context.theme.borderRadiusLG,
          ),
          clipBehavior: .antiAliasWithSaveLayer,
          margin: const .symmetric(horizontal: 2),
          child: AnimatedSize(
            curve: Curves.easeIn,
            duration: duration,
            child: SizedBox(
              height: widget.isSelected
                  ? widget.dotSizeSelected?.height ?? const Spacing(1).value
                  : widget.dotSize?.height ?? const Spacing(1).value,
              width: widget.isSelected
                  ? widget.dotSizeSelected?.width ?? const Spacing(4).value
                  : widget.dotSize?.width ?? const Spacing(1).value,
            ),
          ),
        ),
      ),
    );
  }
}
