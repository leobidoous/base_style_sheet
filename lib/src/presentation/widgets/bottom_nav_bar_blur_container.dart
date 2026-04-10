import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';
import 'containers/custom_card.dart';

class BottomNavBarBlurContainer extends StatelessWidget {
  const BottomNavBarBlurContainer({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: .blur(sigmaX: 4, sigmaY: 4),
        child: CustomCard(
          shaddow: const [],
          color: Colors.transparent,
          border: context.theme.borderNone,
          padding: padding ?? .all(Spacing.sm.value),
          borderRadius: .only(
            topLeft: context.theme.borderRadiusMD.topLeft,
            topRight: context.theme.borderRadiusMD.topRight,
          ),
          child: SafeArea(top: false, child: child),
        ),
      ),
    );
  }
}
