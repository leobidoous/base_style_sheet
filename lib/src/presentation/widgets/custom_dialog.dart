import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        Border,
        BoxConstraints,
        BoxDecoration,
        BoxShadow,
        BuildContext,
        Colors,
        Column,
        Container,
        EdgeInsets,
        Flexible,
        Icons,
        MainAxisAlignment,
        MainAxisSize,
        Material,
        MaterialLocalizations,
        Navigator,
        Padding,
        PopScope,
        SafeArea,
        StatelessWidget,
        Widget,
        showGeneralDialog;
import 'package:flutter/widgets.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';
import 'buttons/custom_button.dart';
import 'errors/custom_request_error.dart';

class CustomDialog {
  static Future<bool> show(
    BuildContext context,
    Widget child, {
    Function()? onClose,
    EdgeInsets? padding,
    bool showClose = true,
    BoxConstraints? constraints,
    bool useRootNavigator = true,
    bool allowDismissOnTap = true,
    String routeName = '/custom_dialog/',
  }) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: useRootNavigator,
      routeSettings: RouteSettings(name: routeName),
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 250),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (_, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: _CustomDialog(
            allowDismissOnTap: allowDismissOnTap,
            constraints: constraints,
            showClose: showClose,
            onClose: onClose,
            padding: padding,
            child: child,
          ),
        );
      },
    ).then((value) => value == true);
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
      CustomRequestError(
        message: message,
        btnLabel: btnLabel,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
      constraints: constraints,
      showClose: showClose,
    );
  }
}

class _CustomDialog extends StatelessWidget {
  const _CustomDialog({
    this.allowDismissOnTap = true,
    required this.showClose,
    required this.child,
    this.constraints,
    this.padding,
    this.onClose,
  });
  final Widget child;
  final bool showClose;
  final Function()? onClose;
  final EdgeInsets? padding;
  final bool allowDismissOnTap;
  final BoxConstraints? constraints;

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
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: constraints,
                    decoration: BoxDecoration(
                      borderRadius: context.theme.borderRadiusMD,
                      border: Border.all(
                        color: context.colorScheme.surface,
                        width: 2,
                      ),
                      color: context.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: -5,
                          color: context.colorScheme.surface
                              .withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                    padding: padding ?? EdgeInsets.all(const Spacing(2).value),
                    margin: EdgeInsets.all(Spacing.md.value),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showClose)
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: Spacing.sm.value),
                              child: CustomButton.icon(
                                icon: Icons.close_rounded,
                                type: ButtonType.noShape,
                                onPressed: () => _onClose(context),
                                heightType: ButtonHeightType.small,
                              ),
                            ),
                          ),
                        Flexible(child: child),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
