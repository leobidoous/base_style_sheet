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
    this.btnType = ButtonType.primary,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
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
      alwaysScrollable: false,
      padding: padding,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight ?? double.infinity),
        child: SafeArea(
          top: isSafeArea,
          bottom: isSafeArea,
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
                          color: Colors.red.withValues(alpha: .25),
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
                                size: AppFontSize.iconButton.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacing.xs.vertical,
                      Text(
                        'Algo aconteceu aqui',
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleSmall,
                      ),
                      Spacing.xs.vertical,
                      Text(
                        '''No momento, não é possível utilizar este serviço. Já estamos verificando o que ocorreu. Por favor, tente novamente.''',
                        textAlign: TextAlign.center,
                        style: context.textTheme.labelMedium,
                      ),
                      if (message != null && message!.isNotEmpty) ...[
                        Spacing.xs.vertical,
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
