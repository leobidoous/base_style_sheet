import 'package:flutter/material.dart'
    show
        BoxDecoration,
        BuildContext,
        Column,
        CrossAxisAlignment,
        Divider,
        EdgeInsets,
        Flexible,
        Icon,
        Icons,
        InkWell,
        MainAxisSize,
        Padding,
        RichText,
        State,
        StatefulWidget,
        Text,
        TextSpan,
        Widget;
import 'package:flutter/widgets.dart';

import '../../../extensions/build_context_extensions.dart';
import '../../custom_dialog.dart';
import '../../custom_scroll_content.dart';

class ImageError extends StatefulWidget {
  const ImageError({super.key, required this.error});

  final String error;

  @override
  State<ImageError> createState() => _ImageErrorState();
}

class _ImageErrorState extends State<ImageError> {
  @override
  Widget build(BuildContext context) {
    final theme = context;

    return Semantics(
      button: true,
      child: InkWell(
        onTap: () {
          CustomDialog.show(
            context,
            _buildErrorDialog(widget.error, null),
            showClose: true,
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(.025),
          ),
          child: Icon(
            Icons.image_not_supported_rounded,
            color: context.colorScheme.onBackground,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorDialog(Object error, StackTrace? stackTrace) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Image Error',
            style: context.textTheme.titleLarge,
          ),
          Divider(color: context.colorScheme.onBackground),
          Flexible(
            child: CustomScrollContent(
              child: RichText(
                text: TextSpan(
                  text: '$error',
                  style: context.textTheme.bodyMedium,
                  children: [
                    if (stackTrace != null)
                      TextSpan(
                        text: '\n\n$stackTrace',
                      ),
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
