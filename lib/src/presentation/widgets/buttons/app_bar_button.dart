import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/responsive/responsive_extension.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../containers/custom_shimmer.dart';

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
    return Opacity(
      opacity: isEnabled ? 1 : .5,
      child: Semantics(
        button: isEnabled,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: AppThemeBase.borderRadiusSM,
          child: Padding(
            padding: EdgeInsets.only(
              right: isLastButtom ? Spacing.md.value : 0,
            ),
            child: SizedBox(
              height: Spacing.md.value.responsiveHeight,
              child: Theme(
                data: context.theme.copyWith(
                  iconTheme: context.theme.iconTheme.copyWith(
                    color: context.textTheme.bodyMedium?.color,
                  ),
                ),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
