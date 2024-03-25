import 'package:flutter/material.dart';

import '../../../core/themes/responsive/responsive_extension.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../custom_scroll_content.dart';
import '../image_view/custom_image.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    super.key,
    this.svgAsset,
    this.asset,
    this.icon,
    this.iconBackgroundColor,
    required this.title,
    this.content,
    this.isContentBold = false,
    this.subtitle,
    this.btnCancelLabel = '',
    required this.btnConfirmLabel,
    required this.onConfirm,
    this.onCancel,
    this.packageName,
  });
  final String? svgAsset;
  final Icon? icon;
  final Color? iconBackgroundColor;
  final String? asset;
  final String title;
  final String? subtitle;
  final String? content;
  final bool? isContentBold;
  final String btnConfirmLabel;
  final String btnCancelLabel;
  final String? packageName;
  final Function() onConfirm;
  final Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (asset != null || svgAsset != null) ...[
          CustomImage(
            asset: asset,
            svgAsset: svgAsset,
            packageName: packageName,
            backgroundColor: Colors.transparent,
            imageSize: Size(double.infinity, 100.responsiveHeight),
          ),
          Spacing.md.vertical,
        ],
        if (icon != null) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBackgroundColor?.withOpacity(.25),
            ),
            child: Padding(
              padding: EdgeInsets.all(Spacing.xxs.value),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBackgroundColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(Spacing.xs.value),
                  child: icon,
                ),
              ),
            ),
          ),
          Spacing.md.vertical,
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium,
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
          Flexible(
            child: CustomScrollContent(
              expanded: false,
              child: SelectableText(
                content!,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: isContentBold!
                      ? AppFontWeight.bold.value
                      : AppFontWeight.light.value,
                ),
              ),
            ),
          ),
        ],
        Spacing.md.vertical,
        Row(
          children: [
            if (onCancel != null) ...[
              Expanded(
                child: CustomButton.text(
                  onPressed: onCancel,
                  text: btnCancelLabel,
                  type: ButtonType.background,
                ),
              ),
              Spacing.sm.horizontal,
            ],
            Expanded(
              child: CustomButton.text(
                onPressed: onConfirm,
                text: btnConfirmLabel,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
