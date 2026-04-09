import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';
import 'buttons/custom_button.dart';
import 'errors/custom_request_error.dart';

enum CustomDialogCloseMode { inside, outside }

class CustomDialog {
  static Future<bool> show<T>(
    BuildContext context,
    Widget child, {
    String? routeName,
    EdgeInsets? padding,
    bool showClose = true,
    Color? backgroundColor,
    bool isDismissible = true,
    Function(T value)? onClose,
    BoxConstraints? constraints,
    bool useRootNavigator = true,
    CustomDialogCloseMode closeMode = .outside,
  }) async {
    return await showGeneralDialog<T>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: useRootNavigator,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 250),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      routeSettings: RouteSettings(name: routeName ?? '/${child.runtimeType}/'),
      pageBuilder: (_, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: _CustomDialog(
            backgroundColor: backgroundColor,
            isDismissible: isDismissible,
            constraints: constraints,
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

  static Future<bool?> error(
    BuildContext context, {
    required String message,
    Function()? onPressed,
    EdgeInsets? padding,
    bool showClose = true,
    String btnLabel = '',
    BoxConstraints? constraints,
  }) async {
    return await show(
      context,
      Material(
        child: CustomRequestError(
          message: message,
          btnLabel: btnLabel,
          onPressed: onPressed,
          padding: .zero,
        ),
      ),
      constraints: constraints,
      showClose: showClose,
    );
  }
}

class _CustomDialog extends StatefulWidget {
  const _CustomDialog({
    this.isDismissible = true,
    required this.showClose,
    required this.child,
    this.constraints,
    this.padding,
    this.backgroundColor,
    this.closeMode = CustomDialogCloseMode.outside,
  });
  final Widget child;
  final bool showClose;
  final bool isDismissible;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BoxConstraints? constraints;
  final CustomDialogCloseMode closeMode;

  @override
  State<_CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<_CustomDialog> {
  void _onClose() {
    Navigator.of(context).pop();
  }

  BoxDecoration get _decoration => BoxDecoration(
    borderRadius: context.theme.borderRadiusMD,
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
          mainAxisAlignment: .center,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints:
                    widget.constraints ?? BoxConstraints(maxWidth: 640),
                child: SafeArea(
                  child: Padding(
                    padding: widget.padding ?? .all(Spacing.sm.value),
                    child: Column(
                      mainAxisSize: .min,
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .stretch,
                      children: [
                        if (widget.closeMode == CustomDialogCloseMode.outside)
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
                            child: Column(
                              mainAxisSize: .min,
                              mainAxisAlignment: .center,
                              children: [
                                if (widget.closeMode ==
                                    CustomDialogCloseMode.inside)
                                  if (widget.showClose)
                                    Padding(
                                      padding: .fromLTRB(
                                        Spacing.xs.value,
                                        Spacing.xs.value,
                                        Spacing.xs.value,
                                        0,
                                      ),
                                      child: Align(
                                        alignment: .topRight,
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
                                  child: Padding(
                                    padding:
                                        widget.padding ??
                                        .all(Spacing.sm.value),
                                    child: widget.child,
                                  ),
                                ),
                              ],
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
}
