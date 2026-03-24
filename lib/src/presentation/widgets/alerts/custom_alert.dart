import 'package:flutter/material.dart';

import '../../../core/themes/responsive/responsive_extension.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../custom_scroll_content.dart';
import '../image_view/custom_image.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    super.key,
    this.title,
    this.asset,
    this.header,
    this.content,
    this.subtitle,
    this.onConfirm,
    this.onCancel,
    this.svgAsset,
    this.titleStyle,
    this.packageName,
    this.contentWidget,
    this.buttons = const [],
    this.btnCancelLabel = '',
    this.btnConfirmLabel = '',
    this.btnConfirmKey,
    this.btnCancelKey,
    this.confirmIsLoading = false,
    this.cancelIsLoading = false,
    this.buttonsDirection = .vertical,
    this.verticalSpacing = Spacing.sm,
    this.horizontalSpacing = Spacing.sm,
  });

  final String? svgAsset;
  final String? asset;
  final Widget? header;
  final String? packageName;
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final String? content;
  final Widget? contentWidget;
  final String btnConfirmLabel;
  final String btnCancelLabel;
  final Key? btnConfirmKey;
  final Key? btnCancelKey;
  final bool cancelIsLoading;
  final bool confirmIsLoading;
  final Axis buttonsDirection;
  final Spacing verticalSpacing;
  final Spacing horizontalSpacing;
  final List<Widget> buttons;
  final Function()? onConfirm;
  final Function()? onCancel;

  Widget get _confirmButtom {
    final button = CustomButton.text(
      heightType: .normal,
      onPressed: onConfirm,
      text: btnConfirmLabel,
      isLoading: confirmIsLoading,
      isEnabled: !cancelIsLoading,
    );
    if (btnConfirmKey != null) {
      return KeyedSubtree(key: btnConfirmKey, child: button);
    }
    return button;
  }

  Widget get _cancelButtom {
    final button = CustomButton.text(
      type: .background,
      heightType: .normal,
      onPressed: onCancel,
      text: btnCancelLabel,
      isLoading: cancelIsLoading,
      isEnabled: !confirmIsLoading,
    );
    if (btnCancelKey != null) {
      return KeyedSubtree(key: btnCancelKey, child: button);
    }
    return button;
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
          if (svgAsset != null || asset != null) ...[
            CustomImage(
              svgAsset: svgAsset!,
              asset: asset,
              packageName: packageName,
              imageSize: Size(double.infinity, 100.responsiveHeight),
              backgroundColor: Colors.transparent,
            ),
          ],
          if (title != null)
            Text(
              title!,
              textAlign: .center,
              style: titleStyle ?? context.textTheme.titleMedium,
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              textAlign: .center,
              style: context.textTheme.bodyLarge,
            ),
          if (content != null)
            SelectableText(
              content!,
              textAlign: .center,
              style: context.textTheme.bodyMedium,
            ),
          ?contentWidget,
          if (onCancel != null || onConfirm != null)
            switch (buttonsDirection) {
              Axis.horizontal => Row(
                spacing: verticalSpacing.value,
                children: [
                  if (onCancel != null) Expanded(child: _cancelButtom),
                  if (onConfirm != null) Expanded(child: _confirmButtom),
                ],
              ),
              Axis.vertical => Column(
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
              Axis.horizontal => Row(
                spacing: horizontalSpacing.value,
                children: buttons.map((e) => Expanded(child: e)).toList(),
              ),
              Axis.vertical => Column(
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
