import 'package:flutter/material.dart'
    show
        BuildContext,
        Colors,
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        MainAxisAlignment,
        MainAxisSize,
        Size,
        StatelessWidget,
        Text,
        TextAlign,
        Widget;

import '../../../core/themes/responsive/responsive_extension.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../custom_scroll_content.dart';
import '../image_view/custom_image.dart';

class ListEmpty extends StatelessWidget {
  const ListEmpty({
    super.key,
    this.message = 'Nenhum resultado encontrado',
    this.content,
    this.onPressed,
    this.svgAsset,
    this.asset,
    this.packageName,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.btnLabel = 'Buscar novamente',
  });

  final String? svgAsset;
  final String? asset;
  final EdgeInsets padding;
  final String message;
  final String? content;
  final String btnLabel;
  final String? packageName;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomScrollContent(
      expanded: false,
      padding: padding,
      alwaysScrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (svgAsset != null || asset != null) ...[
            CustomImage(
              asset: asset,
              svgAsset: svgAsset,
              packageName: packageName,
              backgroundColor: Colors.transparent,
              imageSize: Size(double.infinity, 150.responsiveHeight),
            ),
            Spacing.sm.vertical,
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: AppFontWeight.semiBold.value,
            ),
          ),
          if (content != null) ...[
            Spacing.sm.vertical,
            Text(
              content!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: AppFontWeight.light.value,
              ),
            ),
          ],
          if (onPressed != null) ...[
            Spacing.sm.vertical,
            CustomButton.text(
              onPressed: onPressed,
              text: btnLabel,
            ),
          ],
        ],
      ),
    );
  }
}
