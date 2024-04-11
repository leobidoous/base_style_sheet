import 'package:flutter/material.dart';

import '../../../core/themes/responsive/responsive_extension.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../custom_scroll_content.dart';
import '../image_view/custom_image.dart';

class BottomSheetAlert extends StatelessWidget {
  const BottomSheetAlert({
    super.key,
    required this.title,
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
    this.buttonsDirection = Axis.vertical,
  });

  final String? svgAsset;
  final String? asset;
  final Widget? header;
  final String? packageName;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final String? content;
  final Widget? contentWidget;
  final String btnConfirmLabel;
  final String btnCancelLabel;
  final bool cancelIsLoading;
  final bool confirmIsLoading;
  final Axis buttonsDirection;
  final List<Widget> buttons;
  final Function()? onConfirm;
  final Function()? onCancel;

  CustomButton get _confirmButtom => CustomButton.text(
        onPressed: onConfirm,
        isLoading: confirmIsLoading,
        text: btnConfirmLabel,
      );
  CustomButton get _cancelButtom => CustomButton.text(
        onPressed: onCancel,
        isLoading: cancelIsLoading,
        text: btnCancelLabel,
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
          if (header != null) ...[
            header!,
            Spacing.md.vertical,
          ],
          if (svgAsset != null || asset != null) ...[
            CustomImage(
              svgAsset: svgAsset!,
              asset: asset,
              packageName: packageName,
              imageSize: Size(double.infinity, 100.responsiveHeight),
              backgroundColor: Colors.transparent,
            ),
            Spacing.md.vertical,
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle ?? context.textTheme.titleMedium,
          ),
          if (subtitle != null) ...[
            Spacing.md.vertical,
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
          ],
          if (content != null) ...[
            Spacing.md.vertical,
            SelectableText(
              content!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ],
          if (contentWidget != null) ...[Spacing.md.vertical, contentWidget!],
          if (onCancel != null || onConfirm != null) Spacing.md.vertical,
          switch (buttonsDirection) {
            Axis.horizontal => Row(
                children: [
                  if (onCancel != null) ...[
                    Expanded(child: _cancelButtom),
                    Spacing.sm.horizontal,
                  ],
                  if (onConfirm != null) Expanded(child: _confirmButtom),
                ],
              ),
            Axis.vertical => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (onConfirm != null) _confirmButtom,
                  if (onCancel != null) ...[
                    Spacing.sm.vertical,
                    _cancelButtom,
                  ],
                ],
              ),
          },
          switch (buttonsDirection) {
            Axis.horizontal => Row(
                children: buttons
                    .map(
                      (e) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: Spacing.md.value,
                            right: buttons.last == e ? 0 : Spacing.sm.value,
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
                      (e) => Padding(
                        padding: EdgeInsets.only(top: Spacing.md.value),
                        child: e,
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
