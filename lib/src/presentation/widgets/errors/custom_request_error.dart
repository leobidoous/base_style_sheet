import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';
import '../buttons/custom_button.dart';
import '../custom_scroll_content.dart';
import '../expansions/custom_expansion.dart';

class CustomRequestError extends StatelessWidget {
  const CustomRequestError({
    super.key,
    this.message,
    this.onPressed,
    this.maxHeight,
    this.btnType = ButtonType.primary,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.btnLabel = '',
  });
  final String? message;
  final String btnLabel;
  final double? maxHeight;
  final EdgeInsets padding;
  final Function()? onPressed;
  final ButtonType btnType;

  @override
  Widget build(BuildContext context) {
    return CustomScrollContent(
      expanded: false,
      alwaysScrollable: false,
      padding: padding,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CustomScrollContent(
                expanded: false,
                alwaysScrollable: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(.25),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Spacing.xxs.value),
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(Spacing.xs.value),
                            child: Icon(
                              Icons.error_outline_rounded,
                              color: context.colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacing.sm.vertical,
                    Text(
                      'Algo aconteceu aqui',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleSmall,
                    ),
                    Spacing.sm.vertical,
                    Text(
                      '''No momento, não é possível utilizar este serviço. Já estamos verificando o que ocorreu. Por favor, tente novamente.''',
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelMedium,
                    ),
                    if (message != null && message!.isNotEmpty) ...[
                      Spacing.sm.vertical,
                      CustomExpansion(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(
                            0,
                            Spacing.xs.value,
                            Spacing.xs.value,
                            Spacing.xs.value,
                          ),
                          child: Text(
                            'Ver mais',
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        crossAxisAlignment: CrossAxisAlignment.center,
                        body: Center(
                          child: Text(
                            message!,
                            textAlign: TextAlign.center,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (onPressed != null && btnLabel.isNotEmpty) ...[
              Spacing.xs.vertical,
              Padding(
                padding: EdgeInsets.only(top: const Spacing(2).value),
                child: CustomButton.text(
                  onPressed: onPressed,
                  text: btnLabel,
                  type: btnType,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
