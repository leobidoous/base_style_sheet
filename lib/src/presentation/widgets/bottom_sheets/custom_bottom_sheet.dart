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
    bool showDragHandle = false,
    Function(T value)? onClose,
    BoxConstraints? constraints,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
    CustomBottomSheetCloseMode closeMode = .outside,
  }) async {
    return await showModalBottomSheet<T?>(
      elevation: 0,
      context: context,
      enableDrag: isDismissible,
      isDismissible: isDismissible,
      constraints: BoxConstraints(),
      showDragHandle: showDragHandle,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      routeSettings: RouteSettings(name: routeName ?? '/${child.runtimeType}/'),
      barrierColor: Colors.black.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: .only(
          topLeft: context.theme.borderRadiusMD.topLeft,
          topRight: context.theme.borderRadiusMD.topRight,
        ),
      ),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: _CustomBottomSheet(
            backgroundColor: backgroundColor,
            isDismissible: isDismissible,
            constraints: constraints,
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
    this.constraints,
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
  final BoxConstraints? constraints;
  final CustomBottomSheetCloseMode closeMode;

  @override
  State<_CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<_CustomBottomSheet> {
  void _onClose() {
    Navigator.of(context).pop();
  }

  BoxDecoration get _decoration => BoxDecoration(
    borderRadius: .only(
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
      fit: .expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.isDismissible ? _onClose : null,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        Column(
          mainAxisSize: .min,
          mainAxisAlignment: .end,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints:
                    widget.constraints ?? BoxConstraints(maxWidth: 640),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: .only(
                      top: switch (defaultTargetPlatform) {
                        TargetPlatform.android =>
                          context.theme.appBarTheme.appBarHeight,
                        TargetPlatform.iOS =>
                          context.theme.appBarTheme.appBarHeight,
                        TargetPlatform() =>
                          widget.padding?.top ?? Spacing.sm.value,
                      },
                    ),
                    child: Column(
                      mainAxisSize: .min,
                      mainAxisAlignment: .end,
                      crossAxisAlignment: .stretch,
                      children: [
                        if (widget.closeMode ==
                            CustomBottomSheetCloseMode.outside)
                          if (widget.showClose)
                            Padding(
                              padding: .all(Spacing.xs.value),
                              child: Align(
                                alignment: .bottomRight,
                                child: CustomButton.icon(
                                  onPressed: _onClose,
                                  icon: Icons.close_rounded,
                                  type: .background,
                                  color: context.colorScheme.surface,
                                  heightType: .small,
                                ),
                              ),
                            ),
                        Flexible(
                          child: DecoratedBox(
                            decoration: _decoration,
                            child: SafeArea(
                              bottom: widget.useSafeArea,
                              child: Column(
                                mainAxisAlignment: .center,
                                mainAxisSize: .min,
                                children: [
                                  Padding(
                                    padding: .only(top: Spacing.xxxs.value),
                                    child: _header,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          widget.padding ??
                                          .fromLTRB(
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
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _header {
    switch (widget.closeMode) {
      case CustomBottomSheetCloseMode.inside:
        return Row(
          crossAxisAlignment: .start,
          mainAxisAlignment: .spaceBetween,
          children: [
            SizedBox(width: AppThemeBase.buttonHeightMD),
            BottomSheetDragIcon(),
            if (widget.showClose)
              CustomButton.icon(
                onPressed: _onClose,
                type: .noShape,
                icon: Icons.close_rounded,
                heightType: .small,
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
