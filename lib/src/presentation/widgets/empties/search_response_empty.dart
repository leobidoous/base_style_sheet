import 'package:flutter/material.dart'
    show
        BouncingScrollPhysics,
        BuildContext,
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        FontWeight,
        Icon,
        Icons,
        MainAxisAlignment,
        MainAxisSize,
        Padding,
        RichText,
        SingleChildScrollView,
        StatelessWidget,
        TextAlign,
        TextSpan,
        Widget;

import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';

class SearchResponseEmpty extends StatelessWidget {
  const SearchResponseEmpty({
    super.key,
    required this.message,
    this.onPressed,
    this.btnLabel = 'Buscar novamente',
  });

  final String message;
  final String btnLabel;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 60),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Nenhum resultado encontrado para o termo:\n',
              style: context.textTheme.bodyLarge?.copyWith(),
              children: [
                TextSpan(
                  text: message,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (onPressed != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: CustomButton.text(
                onPressed: onPressed,
                text: btnLabel,
              ),
            ),
        ],
      ),
    );
  }
}
