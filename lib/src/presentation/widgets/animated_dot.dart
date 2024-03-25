import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

enum DotState { opened, closed }

class AnimatedDot extends StatefulWidget {
  const AnimatedDot({super.key, this.onTap, this.selected = false});
  final bool selected;
  final Function()? onTap;
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
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: AnimatedSize(
            curve: Curves.easeIn,
            duration: duration,
            child: SizedBox(
              height: const Spacing(1).value,
              width: widget.selected
                  ? const Spacing(2).value
                  : const Spacing(1).value,
            ),
          ),
        ),
      ),
    );
  }
}
