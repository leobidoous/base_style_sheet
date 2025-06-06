import 'package:flutter/material.dart'
    show
        BuildContext,
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        MainAxisAlignment,
        MainAxisSize,
        SafeArea,
        StatelessWidget,
        Text,
        TextAlign,
        Widget;

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../custom_scroll_content.dart';

class ListEmpty extends StatelessWidget {
  const ListEmpty({
    super.key,
    this.header,
    this.content,
    this.onPressed,
    this.btnLabel = '',
    required this.message,
    this.isSafeArea = false,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  final String message;
  final String? content;
  final Widget? header;
  final String btnLabel;
  final bool isSafeArea;
  final EdgeInsets padding;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomScrollContent(
      expanded: false,
      padding: padding,
      alwaysScrollable: false,
      child: SafeArea(
        top: isSafeArea,
        bottom: isSafeArea,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) ...[
              header!,
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
            if (onPressed != null && btnLabel.isNotEmpty) ...[
              Spacing.sm.vertical,
              CustomButton.text(onPressed: onPressed, text: btnLabel),
            ],
          ],
        ),
      ),
    );
  }
}
