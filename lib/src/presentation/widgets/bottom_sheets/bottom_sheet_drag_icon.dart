import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';

class BottomSheetDragIcon extends StatelessWidget {
  const BottomSheetDragIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Spacing.xs.value),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.primaryContainer,
          borderRadius: context.theme.borderRadiusMD,
        ),
        child: SizedBox(
          height: Spacing.xxs.value,
          width: const Spacing(8).value,
        ),
      ),
    );
  }
}
