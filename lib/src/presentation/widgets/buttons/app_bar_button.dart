import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../containers/custom_shimmer.dart';
import 'custom_button.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({
    super.key,
    this.onTap,
    this.padding,
    this.borderRadius,
    required this.child,
    this.isEnabled = true,
    this.isLastButtom = true,
  });

  final Widget child;
  final bool isEnabled;
  final double? padding;
  final Function()? onTap;
  final bool isLastButtom;
  final BorderRadius? borderRadius;

  static Widget shimmer({isLastButtom = true, double? padding}) {
    return Padding(
      padding: EdgeInsets.only(
        right: isLastButtom ? (padding ?? Spacing.sm.value) : 0,
      ),
      child: CustomButton.child(
        padding: EdgeInsets.zero,
        type: ButtonType.noShape,
        heightType: ButtonHeightType.small,
        child: CustomShimmer(
          height: AppFontSize.iconButton.value,
          width: AppFontSize.iconButton.value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: isLastButtom ? (padding ?? Spacing.sm.value) : 0,
      ),
      child: CustomButton.child(
        isEnabled: isEnabled,
        padding: EdgeInsets.zero,
        type: ButtonType.noShape,
        borderRadius: borderRadius,
        onPressed: isEnabled ? onTap : null,
        heightType: ButtonHeightType.small,
        child: child,
      ),
    );
  }
}
