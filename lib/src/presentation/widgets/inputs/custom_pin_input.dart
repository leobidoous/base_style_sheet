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
    this.hintText,
    this.fillColor,
    this.errorText,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.validators,
    this.onComplete,
    this.labelWidget,
    this.initialValue,
    this.maxLength = 4,
    this.labelText = '',
    this.padding = .zero,
    this.textInputAction,
    this.autofocus = true,
    this.isEnabled = true,
    this.readOnly = false,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.keyboardType = .number,
    this.inputFormatters = const [],
    this.textCapitalization = .sentences,
    this.autovalidateMode = .onUserInteraction,
  });

  final int maxLength;
  final bool readOnly;
  final bool autofocus;
  final bool isEnabled;
  final Color? fillColor;
  final String? hintText;
  final bool obscureText;
  final String? labelText;
  final String? errorText;
  final EdgeInsets padding;
  final FocusNode? focusNode;
  final String? initialValue;
  final InputLabel? labelWidget;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final Function(String input)? onComplete;
  final AutovalidateMode? autovalidateMode;
  final Function(String? input)? onChanged;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final Function(String input)? onFieldSubmitted;
  final String? Function(String? input)? validator;
  final List<String? Function(String? input)>? validators;

  @override
  State<CustomPinField> createState() => _CustomPinFieldState();
}

class _CustomPinFieldState extends State<CustomPinField> {
  BoxConstraints get boxConstraints => BoxConstraints(
    minHeight: AppThemeBase.buttonHeightMD,
    minWidth: AppThemeBase.buttonHeightMD,
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
      color: widget.fillColor ?? context.colorScheme.surface,
      border: Border.all(color: Colors.grey.shade300, width: 1),
    ),
  );

  PinTheme get focusedTheme => PinTheme(
    width: const Spacing(7).value,
    height: const Spacing(7).value,
    decoration: BoxDecoration(
      border: Border.all(color: context.colorScheme.primary, width: 1),
      color: widget.fillColor ?? context.colorScheme.surface,
      borderRadius: context.theme.borderRadiusXSM,
    ),
  );

  PinTheme get errorTheme => PinTheme(
    width: const Spacing(7).value,
    height: const Spacing(7).value,
    textStyle: pinTextStyle,
    decoration: BoxDecoration(
      border: Border.all(color: context.colorScheme.error, width: 1),
      color: widget.fillColor ?? context.colorScheme.surface,
      borderRadius: context.theme.borderRadiusXSM,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          if (widget.labelWidget != null) ...[
            widget.labelWidget!,
            Spacing.xxs.vertical,
          ],
          Pinput(
            length: widget.maxLength,
            autofocus: widget.autofocus,
            forceErrorState: widget.errorText != null,
            mainAxisAlignment: .spaceBetween,
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
                padding: .only(top: const Spacing(1).value),
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
