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
    this.isLoading = false,
    this.isLastButtom = true,
  });

  final Widget child;
  final bool isEnabled;
  final bool isLoading;
  final double? padding;
  final Function()? onTap;
  final bool isLastButtom;
  final BorderRadius? borderRadius;

  static Widget shimmer({bool isLastButtom = true, double? padding}) {
    return Padding(
      padding: .only(right: isLastButtom ? (padding ?? Spacing.sm.value) : 0),
      child: CustomButton.child(
        padding: .zero,
        type: .noShape,
        heightType: .small,
        child: CustomShimmer(
          height: AppFontSize.iconButton.value,
          width: AppFontSize.iconButton.value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return shimmer(isLastButtom: isLastButtom, padding: padding);

    return Padding(
      padding: .only(right: isLastButtom ? (padding ?? Spacing.sm.value) : 0),
      child: CustomButton.child(
        type: .noShape,
        padding: .zero,
        heightType: .small,
        isEnabled: isEnabled,
        borderRadius: borderRadius,
        onPressed: isEnabled ? onTap : null,
        child: child,
      ),
    );
  }
}
