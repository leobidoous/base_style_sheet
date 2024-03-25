import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        Border,
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
        SafeArea,
        StatelessWidget,
        Widget,
        PopScope,
        showGeneralDialog;

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';
import 'buttons/custom_button.dart';
import 'errors/custom_request_error.dart';

class CustomDialog {
  static Future<bool> show(
    BuildContext context,
    Widget child, {
    bool showClose = true,
    EdgeInsets? padding,
  }) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 250),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (_, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: _CustomDialog(
            showClose: showClose,
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
    String btnLabel = 'Tentar novamente',
  }) async {
    return await show(
      context,
      CustomRequestError(
        message: message,
        btnLabel: btnLabel,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
      showClose: showClose,
    );
  }
}

class _CustomDialog extends StatelessWidget {
  const _CustomDialog({
    required this.showClose,
    required this.child,
    this.padding,
  });
  final bool showClose;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: context.theme.borderRadiusMD,
                  border: Border.all(
                    color: context.colorScheme.background,
                    width: 2,
                  ),
                  color: context.colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: -5,
                      color: context.colorScheme.background.withOpacity(0.5),
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
                          padding: EdgeInsets.only(bottom: Spacing.sm.value),
                          child: CustomButton.icon(
                            icon: Icons.close_rounded,
                            type: ButtonType.noShape,
                            heightType: ButtonHeightType.small,
                            onPressed: () => Navigator.of(context).pop(false),
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
    );
  }
}