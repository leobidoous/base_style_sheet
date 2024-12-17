import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../base_style_sheet.dart';

enum SnackBarType { info, success, error }

class CustomSnackBar {
  static void snackShowMessage({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              switch (type) {
                SnackBarType.info => Icons.info_rounded,
                SnackBarType.success => Icons.check_circle_outline_rounded,
                SnackBarType.error => Icons.error,
              },
              color: Theme.of(context).colorScheme.surface,
            ),
            Spacing.sm.horizontal,
            Expanded(
              child: Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.scaffoldBackgroundColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            ),
          ],
        ),
        backgroundColor: switch (type) {
          SnackBarType.error => context.colorScheme.error,
          SnackBarType.info => context.colorScheme.secondary,
          SnackBarType.success => context.colorScheme.primary,
        },
        duration: duration ?? const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: context.theme.borderRadiusMD,
        ),
      ),
    );
  }

  static void toastShowMessage({
    required BuildContext context,
    required String message,
    EdgeInsets? padding,
    SnackBarType type = SnackBarType.info,
    TextStyle? style,
    Color? infoColor,
    Color? errorColor,
    Color? successColor,
    Duration? duration,
  }) {
    FToast().removeQueuedCustomToasts();
    FToast().init(context).showToast(
          isDismissible: true,
          gravity: ToastGravity.TOP,
          toastDuration: duration ?? const Duration(seconds: 5),
          positionedToastBuilder: (context, child, gravity) {
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: padding ?? EdgeInsets.all(Spacing.sm.value),
                  child: child,
                ),
              ),
            );
          },
          child: CustomCard(
            color: switch (type) {
              SnackBarType.error => errorColor ?? Colors.red,
              SnackBarType.info => infoColor ?? Colors.orange,
              SnackBarType.success => successColor ?? Colors.green,
            },
            borderRadius: context.theme.borderRadiusSM,
            padding: EdgeInsets.all(Spacing.sm.value),
            child: Row(
              children: <Widget>[
                Icon(
                  switch (type) {
                    SnackBarType.error => Icons.error,
                    SnackBarType.info => Icons.info_rounded,
                    SnackBarType.success => Icons.check_circle_outline_rounded,
                  },
                  color: style?.color ??
                      switch (type) {
                        SnackBarType.info => Colors.black,
                        SnackBarType() => Colors.white,
                      },
                ),
                Spacing.sm.horizontal,
                Expanded(
                  child: Text(
                    message,
                    style: style ??
                        context.textTheme.bodyMedium?.copyWith(
                          color: switch (type) {
                            SnackBarType.info => Colors.black,
                            SnackBarType() => Colors.white,
                          },
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
