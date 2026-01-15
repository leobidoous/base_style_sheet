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
    this.titleStyle,
    this.svgAsset,
    this.asset,
    this.content,
    this.subtitle,
    this.onConfirm,
    this.onCancel,
    this.contentWidget,
    this.btnCancelLabel = '',
    this.btnConfirmLabel = '',
    this.confirmIsLoading = false,
    this.cancelIsLoading = false,
    this.buttons = const [],
    this.packageName,
    this.header,
    this.verticalSpacing = Spacing.sm,
    this.horizontalSpacing = Spacing.sm,
    this.buttonsDirection = Axis.vertical,
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
  final bool cancelIsLoading;
  final bool confirmIsLoading;
  final Axis buttonsDirection;
  final Spacing verticalSpacing;
  final Spacing horizontalSpacing;
  final List<Widget> buttons;
  final Function()? onConfirm;
  final Function()? onCancel;

  CustomButton get _confirmButtom => CustomButton.text(
    onPressed: onConfirm,
    text: btnConfirmLabel,
    isLoading: confirmIsLoading,
  );
  CustomButton get _cancelButtom => CustomButton.text(
    onPressed: onCancel,
    text: btnCancelLabel,
    isLoading: cancelIsLoading,
    type: ButtonType.background,
  );

  @override
  Widget build(BuildContext context) {
    return CustomScrollContent(
      expanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) ...[header!, verticalSpacing.vertical],
          if (svgAsset != null || asset != null) ...[
            CustomImage(
              svgAsset: svgAsset!,
              asset: asset,
              packageName: packageName,
              imageSize: Size(double.infinity, 100.responsiveHeight),
              backgroundColor: Colors.transparent,
            ),
            verticalSpacing.vertical,
          ],
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.center,
              style: titleStyle ?? context.textTheme.titleMedium,
            ),
            verticalSpacing.vertical,
          ],
          if (subtitle != null) ...[
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
            verticalSpacing.vertical,
          ],
          if (content != null) ...[
            SelectableText(
              content!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            verticalSpacing.vertical,
          ],
          if (contentWidget != null) ...[
            contentWidget!,
            verticalSpacing.vertical,
          ],
          ...switch (buttonsDirection) {
            Axis.horizontal => [
              Row(
                children: [
                  if (onCancel != null) ...[
                    Expanded(child: _cancelButtom),
                    horizontalSpacing.horizontal,
                  ],
                  if (onConfirm != null) Expanded(child: _confirmButtom),
                ],
              ),
              if (onCancel != null && onConfirm != null && buttons.isNotEmpty)
                verticalSpacing.vertical,
            ],
            Axis.vertical => [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (onConfirm != null) _confirmButtom,
                  if (onCancel != null && onConfirm != null)
                    verticalSpacing.vertical,
                  if (onCancel != null) _cancelButtom,
                ],
              ),
              if (onCancel != null && onConfirm != null && buttons.isNotEmpty)
                verticalSpacing.vertical,
            ],
          },
          switch (buttonsDirection) {
            Axis.horizontal => Row(
              children: buttons
                  .map(
                    (e) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: buttons.last == e
                              ? 0
                              : horizontalSpacing.value,
                        ),
                        child: e,
                      ),
                    ),
                  )
                  .toList(),
            ),
            Axis.vertical => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons
                  .map(
                    (b) => Padding(
                      padding: EdgeInsets.only(
                        bottom: buttons.last == b ? 0 : horizontalSpacing.value,
                      ),
                      child: b,
                    ),
                  )
                  .toList(),
            ),
          },
        ],
      ),
    );
  }
}
