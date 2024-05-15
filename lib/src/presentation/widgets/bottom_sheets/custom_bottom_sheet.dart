import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';

class CustomBottomSheet {
  static Future<bool> show(
    BuildContext context,
    Widget child, {
    bool showClose = false,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool allowDismissOnTap = true,
    bool isScrollControlled = true,
    BoxConstraints? constraints,
    Color? backgroundColor,
    EdgeInsets? padding,
  }) async {
    return await showModalBottomSheet<bool>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: context.theme.borderRadiusMD.topLeft,
          topRight: context.theme.borderRadiusMD.topRight,
        ),
      ),
      elevation: 0,
      context: context,
      useRootNavigator: true,
      constraints: constraints,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: _CustomBottomSheet(
            allowDismissOnTap: allowDismissOnTap,
            backgroundColor: backgroundColor,
            useSafeArea: useSafeArea,
            showClose: showClose,
            padding: padding,
            child: child,
          ),
        );
      },
    ).then((value) => value == true);
  }
}

class _CustomBottomSheet extends StatelessWidget {
  const _CustomBottomSheet({
    required this.showClose,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.useSafeArea = true,
    this.allowDismissOnTap = true,
  });
  final Widget child;
  final bool showClose;
  final bool useSafeArea;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool allowDismissOnTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          child: GestureDetector(
            onTap: allowDismissOnTap
                ? () => Navigator.of(context).pop(false)
                : null,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: context.theme.borderRadiusMD.topLeft,
                      topRight: context.theme.borderRadiusMD.topRight,
                    ),
                    border: Border.all(
                      color: context.colorScheme.surface,
                      width: 2,
                    ),
                    color: backgroundColor ?? context.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: -5,
                        color: context.colorScheme.surface.withOpacity(0.5),
                      ),
                    ],
                  ),
                  padding: padding ?? EdgeInsets.all(Spacing.md.value),
                  margin: EdgeInsets.only(
                    top: useSafeArea
                        ? context.theme.appBarTheme.appBarHeight
                        : 0,
                  ),
                  child: SafeArea(
                    top: useSafeArea,
                    bottom: useSafeArea,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showClose)
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: Spacing.sm.value,
                              ),
                              child: CustomButton.icon(
                                type: ButtonType.noShape,
                                icon: Icons.close_rounded,
                                heightType: ButtonHeightType.small,
                                onPressed: () => Navigator.of(context).pop(
                                  false,
                                ),
                              ),
                            ),
                          ),
                        Flexible(child: child),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
