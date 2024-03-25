import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import 'input_label.dart';

class CustomPinField extends StatefulWidget {
  const CustomPinField({
    super.key,
    this.textCapitalization = TextCapitalization.sentences,
    this.initialValue,
    this.maxLength = 4,
    this.labelText = '',
    this.errorText,
    this.hintText,
    this.controller,
    this.validators,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.autofocus = true,
    this.textInputAction,
    this.enabled = true,
    this.labelWidget,
    this.keyboardType = TextInputType.number,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.padding = EdgeInsets.zero,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.inputFormatters = const [],
    this.onComplete,
    this.readOnly = false,
  });

  final TextCapitalization textCapitalization;
  final List<String? Function(String?)>? validators;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Function(String?)? onChanged;
  final String? initialValue;
  final int maxLength;
  final String? labelText;
  final String? errorText;
  final String? hintText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final bool obscureText;
  final EdgeInsets padding;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter> inputFormatters;
  final Function(String)? onFieldSubmitted;
  final bool readOnly;
  final Function(String)? onComplete;
  final InputLabel? labelWidget;

  @override
  State<CustomPinField> createState() => _CustomPinFieldState();
}

class _CustomPinFieldState extends State<CustomPinField> {
  BoxConstraints get boxConstraints => BoxConstraints(
        minHeight: AppThemeBase.inputHeightMD,
        minWidth: AppThemeBase.inputHeightMD,
      );

  String? _validator(String? input) {
    String? error;
    widget.validators?.forEach((val) {
      if (error == null) {
        error = val(input);
        return;
      }
    });
    return error;
  }

  TextStyle? get pinTextStyle => context.textTheme.bodyLarge?.copyWith(
        fontWeight: context.textTheme.fontWeightMedium,
        color: const Color(0xFF4E4B59),
      );

  PinTheme get defaultTheme => PinTheme(
        width: const Spacing(7).value,
        height: const Spacing(7).value,
        textStyle: pinTextStyle,
        decoration: BoxDecoration(
          borderRadius: context.theme.borderRadiusXSM,
          color: context.theme.scaffoldBackgroundColor,
          border: Border.all(color: Colors.grey.shade300, width: .5),
        ),
      );

  PinTheme get focusedTheme => PinTheme(
        width: const Spacing(7).value,
        height: const Spacing(7).value,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: context.colorScheme.primary, width: .5),
          borderRadius: context.theme.borderRadiusXSM,
        ),
      );

  PinTheme get errorTheme => PinTheme(
        width: const Spacing(7).value,
        height: const Spacing(7).value,
        textStyle: pinTextStyle,
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.error, width: .5),
          borderRadius: context.theme.borderRadiusXSM,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelWidget != null) ...[
            widget.labelWidget!,
            Spacing.xxs.vertical,
          ],
          Pinput(
            length: widget.maxLength,
            autofocus: widget.autofocus,
            forceErrorState: widget.errorText != null,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            focusNode: widget.focusNode,
            controller: widget.controller,
            defaultPinTheme: defaultTheme,
            focusedPinTheme: focusedTheme,
            errorPinTheme: errorTheme,
            inputFormatters: widget.inputFormatters,
            pinAnimationType: PinAnimationType.fade,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onSubmitted: widget.onFieldSubmitted,
            errorText: widget.errorText,
            onChanged: widget.onChanged,
            errorBuilder: (errorText, pin) {
              if (errorText == null || errorText.isEmpty) {
                return const SizedBox();
              }
              return Padding(
                padding: EdgeInsets.only(top: const Spacing(1).value),
                child: Text(
                  errorText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: pinTextStyle?.copyWith(
                    fontSize: AppFontSize.labelMedium.value,
                    color: context.colorScheme.error,
                  ),
                ),
              );
            },
            validator: widget.validator ?? _validator,
            onCompleted: widget.onComplete,
            closeKeyboardWhenCompleted: true,
            keyboardType: widget.keyboardType,
          ),
        ],
      ),
    );
  }
}
