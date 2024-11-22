import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import 'bottom_sheet_drag_icon.dart';

class CustomBottomSheet {
  static Future<bool> show(
    BuildContext context,
    Widget child, {
    EdgeInsets? padding,
    Function()? onClose,
    Color? backgroundColor,
    bool showClose = false,
    bool useSafeArea = true,
    bool isDismissible = true,
    BoxConstraints? constraints,
    bool useRootNavigator = true,
    bool allowDismissOnTap = true,
    bool isScrollControlled = true,
    String routeName = '/custom_bottom_sheet/',
  }) async {
    return await showModalBottomSheet<bool>(
      elevation: 0,
      context: context,
      constraints: constraints,
      enableDrag: isDismissible,
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      barrierColor: Colors.black.withOpacity(0.8),
      routeSettings: RouteSettings(name: routeName),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: context.theme.borderRadiusMD.topLeft,
          topRight: context.theme.borderRadiusMD.topRight,
        ),
      ),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: _CustomBottomSheet(
            allowDismissOnTap: allowDismissOnTap,
            backgroundColor: backgroundColor,
            useSafeArea: useSafeArea,
            showClose: showClose,
            padding: padding,
            onClose: onClose,
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
    this.onClose,
    this.padding,
    this.backgroundColor,
    this.useSafeArea = true,
    this.allowDismissOnTap = true,
  });
  final Widget child;
  final bool showClose;
  final bool useSafeArea;
  final EdgeInsets? padding;
  final Function()? onClose;
  final Color? backgroundColor;
  final bool allowDismissOnTap;

  void _onClose(BuildContext context) {
    onClose?.call();
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: allowDismissOnTap ? () => _onClose(context) : null,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  top: useSafeArea ? context.theme.appBarTheme.appBarHeight : 0,
                ),
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
                    child: SafeArea(
                      top: useSafeArea,
                      bottom: useSafeArea,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              Spacing.xs.value,
                              Spacing.xxxs.value,
                              Spacing.xs.value,
                              0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: AppThemeBase.buttonHeightMD),
                                BottomSheetDragIcon(),
                                if (!showClose)
                                  SizedBox(
                                    width: AppThemeBase.buttonHeightMD,
                                  ),
                                if (showClose)
                                  CustomButton.icon(
                                    type: ButtonType.noShape,
                                    icon: Icons.close_rounded,
                                    heightType: ButtonHeightType.small,
                                    onPressed: () => _onClose(context),
                                  ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding:
                                  padding ?? EdgeInsets.all(Spacing.md.value),
                              child: child,
                            ),
                          ),
                        ],
                      ),
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
