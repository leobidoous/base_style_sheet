import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';

enum TabState { opened, closed }

class TabBarItem extends StatefulWidget {
  const TabBarItem({super.key, this.selected = false, required this.title});

  final String title;
  final bool selected;

  @override
  State<TabBarItem> createState() => _TabBarItemState();
}

class _TabBarItemState extends State<TabBarItem>
    with SingleTickerProviderStateMixin {
  final duration = const Duration(milliseconds: 250);
  late final Animation<double> scaleAnimation;
  late final AnimationController controller;
  late TabState currentState;

  @override
  void initState() {
    currentState = widget.selected ? TabState.opened : TabState.closed;
    controller = AnimationController(vsync: this, duration: duration);
    controller.addListener(() {
      final double controllerValue = controller.value;
      if (controllerValue < 0.2) {
        currentState = TabState.closed;
      } else if (controllerValue > 0.8) {
        currentState = TabState.opened;
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
  void didUpdateWidget(covariant TabBarItem oldWidget) {
    currentState = widget.selected ? TabState.opened : TabState.closed;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.selected ? 1 : .5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: context.textTheme.titleSmall?.copyWith(
              color: widget.selected ? context.colorScheme.primary : null,
              fontSize: AppFontSize.bodyLarge.value,
              fontWeight: widget.selected ? AppFontWeight.bold.value : null,
            ),
          ),
          AnimatedContainer(
            duration: duration,
            decoration: BoxDecoration(
              color: widget.selected
                  ? context.colorScheme.primary
                  : Colors.grey,
              borderRadius: context.theme.borderRadiusXSM,
            ),
            margin: EdgeInsets.only(top: Spacing.xxs.value),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: duration,
              child: SizedBox(
                height: 4,
                width: widget.selected ? const Spacing(3).value : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
