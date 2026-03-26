import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../custom_scroll_content.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    super.key,
    this.title,
    this.header,
    this.content,
    this.subtitle,
    this.onConfirm,
    this.onCancel,
    this.titleStyle,
    this.btnConfirmKey,
    this.btnCancelKey,
    this.contentWidget,
    this.buttons = const [],
    this.btnCancelLabel = '',
    this.btnConfirmLabel = '',
    this.confirmIsLoading = false,
    this.cancelIsLoading = false,
    this.titleTextAlign = .center,
    this.contentTextAlign = .center,
    this.subtitleTextAlign = .center,
    this.buttonsDirection = .vertical,
    this.verticalSpacing = Spacing.sm,
    this.horizontalSpacing = Spacing.sm,
  });

  final String? title;
  final Widget? header;
  final String? content;
  final String? subtitle;
  final Key? btnCancelKey;
  final Key? btnConfirmKey;
  final bool cancelIsLoading;
  final bool confirmIsLoading;
  final List<Widget> buttons;
  final Function()? onConfirm;
  final Function()? onCancel;
  final TextStyle? titleStyle;
  final Widget? contentWidget;
  final String btnConfirmLabel;
  final String btnCancelLabel;
  final Axis buttonsDirection;
  final Spacing verticalSpacing;
  final TextAlign titleTextAlign;
  final Spacing horizontalSpacing;
  final TextAlign contentTextAlign;
  final TextAlign subtitleTextAlign;

  static Widget iconHeader(
    BuildContext context, {
    required IconData iconData,
    Color? iconColor,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: .circle,
        color: (iconColor ?? context.colorScheme.primary).withValues(
          alpha: .025,
        ),
      ),
      child: Padding(
        padding: .all(Spacing.xxs.value),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: .circle,
            color: (iconColor ?? context.colorScheme.primary).withValues(
              alpha: .075,
            ),
          ),
          child: Padding(
            padding: .all(Spacing.sm.value),
            child: Icon(
              iconData,
              size: AppFontSize.iconButton.value,
              color: iconColor ?? context.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget get _confirmButtom {
    return KeyedSubtree(
      key: btnConfirmKey,
      child: CustomButton.text(
        heightType: .normal,
        onPressed: onConfirm,
        text: btnConfirmLabel,
        isLoading: confirmIsLoading,
        isEnabled: !cancelIsLoading,
      ),
    );
  }

  Widget get _cancelButtom {
    return KeyedSubtree(
      key: btnCancelKey,
      child: CustomButton.text(
        type: .background,
        heightType: .normal,
        onPressed: onCancel,
        text: btnCancelLabel,
        isLoading: cancelIsLoading,
        isEnabled: !confirmIsLoading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollContent(
      expanded: false,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: verticalSpacing.value,
        children: [
          ?header,
          if (title != null)
            Text(
              title!,
              textAlign: titleTextAlign,
              style: titleStyle ?? context.textTheme.titleMedium,
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              textAlign: subtitleTextAlign,
              style: context.textTheme.bodyLarge,
            ),
          if (content != null)
            SelectableText(
              content!,
              textAlign: contentTextAlign,
              style: context.textTheme.bodyMedium,
            ),
          ?contentWidget,
          if (onCancel != null || onConfirm != null)
            switch (buttonsDirection) {
              .horizontal => Row(
                spacing: verticalSpacing.value,
                children: [
                  if (onCancel != null) Expanded(child: _cancelButtom),
                  if (onConfirm != null) Expanded(child: _confirmButtom),
                ],
              ),
              .vertical => Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: verticalSpacing.value,
                children: [
                  if (onConfirm != null) _confirmButtom,
                  if (onCancel != null) _cancelButtom,
                ],
              ),
            },
          if (buttons.isNotEmpty)
            switch (buttonsDirection) {
              .horizontal => Row(
                spacing: horizontalSpacing.value,
                children: buttons.map((e) => Expanded(child: e)).toList(),
              ),
              .vertical => Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: horizontalSpacing.value,
                children: buttons.map((b) => b).toList(),
              ),
            },
        ],
      ),
    );
  }
}
