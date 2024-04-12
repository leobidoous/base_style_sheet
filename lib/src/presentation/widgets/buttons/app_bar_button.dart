import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../containers/custom_shimmer.dart';
import 'custom_button.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({
    super.key,
    required this.child,
    required this.onTap,
    this.isEnabled = true,
    this.isLastButtom = true,
  });

  final Function() onTap;
  final Widget child;
  final bool isEnabled;
  final bool isLastButtom;

  static Widget shimmer({isLastButtom = true}) {
    return Padding(
      padding: EdgeInsets.only(
        right: isLastButtom ? Spacing.md.value : 0,
      ),
      child: CustomShimmer(
        height: AppFontSize.iconButton.value,
        width: AppFontSize.iconButton.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: isLastButtom ? Spacing.md.value : 0,
      ),
      child: CustomButton.child(
        isEnabled: isEnabled,
        padding: EdgeInsets.zero,
        onPressed: isEnabled ? onTap : null,
        heightType: ButtonHeightType.small,
        type: ButtonType.noShape,
        child: child,
      ),
    );
  }
}
