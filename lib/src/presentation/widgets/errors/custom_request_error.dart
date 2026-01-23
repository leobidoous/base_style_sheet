import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
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
    this.btnLabel = '',
    this.isSafeArea = false,
    this.btnType = .primary,
    this.padding = const .symmetric(vertical: 16),
  });
  final String? message;
  final bool isSafeArea;
  final String btnLabel;
  final double? maxHeight;
  final EdgeInsets padding;
  final ButtonType btnType;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomScrollContent(
      expanded: false,
      padding: padding,
      alwaysScrollable: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight ?? .infinity),
        child: SafeArea(
          top: isSafeArea,
          bottom: isSafeArea,
          child: Column(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            children: [
              Flexible(
                child: CustomScrollContent(
                  expanded: false,
                  alwaysScrollable: false,
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: .circle,
                          color: context.colorScheme.error.withValues(
                            alpha: .25,
                          ),
                        ),
                        child: Padding(
                          padding: .all(Spacing.xxs.value),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: .circle,
                              color: context.colorScheme.error,
                            ),
                            child: Padding(
                              padding: .all(Spacing.xs.value),
                              child: Icon(
                                Icons.error_outline_rounded,
                                color: context.colorScheme.surface,
                                size: AppFontSize.iconButton.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacing.xs.vertical,
                      Text(
                        'Algo aconteceu aqui',
                        textAlign: .center,
                        style: context.textTheme.titleSmall,
                      ),
                      Spacing.xs.vertical,
                      Text(
                        '''No momento, não é possível utilizar este serviço. Já estamos verificando o que ocorreu. Por favor, tente novamente.''',
                        textAlign: .center,
                        style: context.textTheme.labelMedium,
                      ),
                      if (message != null && message!.isNotEmpty) ...[
                        Spacing.xs.vertical,
                        CustomExpansion(
                          title: Padding(
                            padding: .fromLTRB(
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
                          crossAxisAlignment: .center,
                          body: Center(
                            child: SelectableText(
                              message!,
                              textAlign: .center,
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
                Spacing.sm.vertical,
                CustomButton.text(
                  onPressed: onPressed,
                  text: btnLabel,
                  type: btnType,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
