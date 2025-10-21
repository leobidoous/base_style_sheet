import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import 'bottom_sheet_drag_icon.dart';

enum CustomBottomSheetCloseMode { inside, outside }

class CustomBottomSheet {
  static Future<bool> show<T>(
    BuildContext context,
    Widget child, {
    String? routeName,
    EdgeInsets? padding,
    Color? backgroundColor,
    bool showClose = false,
    bool useSafeArea = true,
    bool isDismissible = true,
    Function(T value)? onClose,
    BoxConstraints? constraints,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
    CustomBottomSheetCloseMode closeMode = CustomBottomSheetCloseMode.outside,
  }) async {
    return await showModalBottomSheet<T?>(
      elevation: 0,
      context: context,
      constraints: constraints,
      enableDrag: isDismissible,
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      routeSettings: RouteSettings(
        name: routeName ?? '/${child.runtimeType}/',
      ),
      barrierColor: Colors.black.withValues(alpha: 0.8),
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
            isDismissible: isDismissible,
            backgroundColor: backgroundColor,
            useSafeArea: useSafeArea,
            showClose: showClose,
            closeMode: closeMode,
            padding: padding,
            child: child,
          ),
        );
      },
    ).then((value) {
      if (value is T) onClose?.call(value);
      return value == true;
    });
  }
}

class _CustomBottomSheet extends StatefulWidget {
  const _CustomBottomSheet({
    this.padding,
    this.backgroundColor,
    required this.child,
    required this.closeMode,
    required this.showClose,
    this.useSafeArea = true,
    this.isDismissible = true,
  });
  final Widget child;
  final bool showClose;
  final bool useSafeArea;
  final bool isDismissible;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final CustomBottomSheetCloseMode closeMode;

  @override
  State<_CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<_CustomBottomSheet> {
  void _onClose() {
    Navigator.of(context).pop();
  }

  BoxDecoration get _decoration => BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: context.theme.borderRadiusMD.topLeft,
          topRight: context.theme.borderRadiusMD.topRight,
        ),
        color: widget.backgroundColor ?? context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: -5,
            color: context.colorScheme.surface.withValues(alpha: 0.5),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.isDismissible ? _onClose : null,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              top: switch (defaultTargetPlatform) {
                TargetPlatform.android =>
                  context.theme.appBarTheme.appBarHeight,
                TargetPlatform.iOS => context.theme.appBarTheme.appBarHeight,
                TargetPlatform() => widget.padding?.top ?? Spacing.sm.value,
              },
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.closeMode == CustomBottomSheetCloseMode.outside)
                  if (widget.showClose)
                    Padding(
                      padding: EdgeInsets.all(Spacing.xs.value),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CustomButton.icon(
                          onPressed: _onClose,
                          icon: Icons.close_rounded,
                          type: ButtonType.background,
                          color: context.colorScheme.surface,
                          heightType: ButtonHeightType.small,
                        ),
                      ),
                    ),
                Flexible(
                  child: DecoratedBox(
                    decoration: _decoration,
                    child: SafeArea(
                      bottom: widget.useSafeArea,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: Spacing.xxxs.value),
                            child: _header,
                          ),
                          Flexible(
                            child: Padding(
                              padding: widget.padding ??
                                  EdgeInsets.fromLTRB(
                                    Spacing.sm.value,
                                    Spacing.xs.value,
                                    Spacing.sm.value,
                                    Spacing.sm.value,
                                  ),
                              child: widget.child,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _header {
    switch (widget.closeMode) {
      case CustomBottomSheetCloseMode.inside:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: AppThemeBase.buttonHeightMD),
            BottomSheetDragIcon(),
            if (widget.showClose)
              CustomButton.icon(
                onPressed: _onClose,
                type: ButtonType.noShape,
                icon: Icons.close_rounded,
                heightType: ButtonHeightType.small,
              )
            else
              SizedBox(width: AppThemeBase.buttonHeightMD),
          ],
        );
      case CustomBottomSheetCloseMode.outside:
        return BottomSheetDragIcon();
    }
  }
}
