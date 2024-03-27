import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../base_style_sheet.dart';

enum SnackBarType { info, success, error }

class CustomSnackBar {
  static void snackShowMessage({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
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
              color: Theme.of(context).colorScheme.background,
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
        duration: const Duration(seconds: 5),
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
    SnackBarType type = SnackBarType.info,
  }) {
    FToast().removeQueuedCustomToasts();
    FToast().init(context).showToast(
          gravity: ToastGravity.TOP,
          isDismissable: true,
          toastDuration: const Duration(seconds: 5),
          positionedToastBuilder: (context, child) {
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(Spacing.md.value),
                  child: child,
                ),
              ),
            );
          },
          child: CustomCard(
            color: switch (type) {
              SnackBarType.error => context.colorScheme.error,
              SnackBarType.info => context.colorScheme.secondary,
              SnackBarType.success => context.colorScheme.primary,
            },
            borderRadius: context.theme.borderRadiusSM,
            padding: EdgeInsets.all(Spacing.sm.value),
            child: Row(
              children: <Widget>[
                Icon(
                  switch (type) {
                    SnackBarType.info => Icons.info_rounded,
                    SnackBarType.success => Icons.check_circle_outline_rounded,
                    SnackBarType.error => Icons.error,
                  },
                  color: switch (type) {
                    SnackBarType.info => context.theme.scaffoldBackgroundColor,
                    SnackBarType.success => context.textTheme.bodyMedium?.color,
                    SnackBarType.error => context.theme.scaffoldBackgroundColor,
                  },
                ),
                Spacing.sm.horizontal,
                Expanded(
                  child: Text(
                    message,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: switch (type) {
                        SnackBarType.info =>
                          context.theme.scaffoldBackgroundColor,
                        SnackBarType.success =>
                          context.textTheme.bodyMedium?.color,
                        SnackBarType.error =>
                          context.theme.scaffoldBackgroundColor,
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
