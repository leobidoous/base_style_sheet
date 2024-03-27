import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import 'input_label.dart';

enum InputHeightType { normal, small }

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    super.key,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters = const [],
    this.initialValue,
    this.labelText = '',
    this.errorText = '',
    this.hintText,
    this.prefix,
    this.keyboardType,
    this.controller,
    this.suffixIcon,
    this.autocorrect = false,
    this.prefixIcon,
    this.validators,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.maxLength,
    this.maxLines = 1,
    this.autofocus = false,
    this.textInputAction,
    this.enabled = true,
    this.enableSuggestions = false,
    this.opacityDisabled = 0.5,
    this.labelWidget,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.padding = EdgeInsets.zero,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.fillColor,
    this.readOnly = false,
    this.inputHeightType = InputHeightType.normal,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.focusedBorder,
    this.borderRadius,
    this.autofillHints = const [],
    this.textAlign = TextAlign.start,
    this.enableinteractiveSelection = true,
  });

  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final List<String? Function(String?)>? validators;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String?)? onChanged;
  final String? initialValue;
  final String? labelText;
  final Color? fillColor;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String? prefix;
  final TextAlign textAlign;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool enableSuggestions;
  final bool autocorrect;
  final int maxLines;
  final bool autofocus;
  final bool enabled;
  final BorderRadius? borderRadius;
  final bool enableinteractiveSelection;
  final bool readOnly;
  final double? opacityDisabled;
  final InputHeightType inputHeightType;
  final bool obscureText;
  final EdgeInsets padding;
  final List<String> autofillHints;
  final AutovalidateMode? autovalidateMode;
  final Function(String)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final InputLabel? labelWidget;
  final FloatingLabelBehavior floatingLabelBehavior;
  final InputBorder? focusedBorder;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  BoxConstraints get _boxConstraints {
    switch (widget.inputHeightType) {
      case InputHeightType.normal:
        return BoxConstraints(
          minHeight: AppThemeBase.inputHeightMD,
          minWidth: AppThemeBase.inputHeightMD,
        );
      case InputHeightType.small:
        return BoxConstraints(
          minHeight: AppThemeBase.buttonHeightSM,
          minWidth: AppThemeBase.buttonHeightSM,
        );
    }
  }

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

  double get _fontSize {
    switch (widget.inputHeightType) {
      case InputHeightType.normal:
        return AppFontSize.bodyMedium.value;
      case InputHeightType.small:
        return AppFontSize.bodySmall.value;
    }
  }

  double get _padding {
    switch (widget.inputHeightType) {
      case InputHeightType.normal:
        return _fontSize * 1.25;
      case InputHeightType.small:
        return _fontSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelWidget != null) ...[
            widget.labelWidget!,
            Spacing.xxxs.vertical,
          ],
          Opacity(
            opacity: widget.enabled ? 1 : 0.5,
            child: TextFormField(
              key: widget.key,
              onTap: widget.onTap,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              readOnly: widget.readOnly,
              maxLength: widget.maxLength,
              textAlign: widget.textAlign,
              focusNode: widget.focusNode,
              controller: widget.controller,
              autocorrect: widget.autocorrect,
              keyboardType: widget.keyboardType,
              autofillHints: widget.autofillHints,
              initialValue: widget.initialValue,
              inputFormatters: widget.inputFormatters,
              smartDashesType: SmartDashesType.enabled,
              autovalidateMode: widget.autovalidateMode,
              onFieldSubmitted: widget.onFieldSubmitted,
              enableSuggestions: widget.enableSuggestions,
              onEditingComplete: widget.onEditingComplete,
              textCapitalization: widget.textCapitalization,
              enableInteractiveSelection: widget.enableinteractiveSelection,
              textInputAction: widget.textInputAction ?? TextInputAction.done,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: AppFontWeight.normal.value,
                fontSize: _fontSize,
              ),
              obscureText: widget.obscureText,
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                isCollapsed: true,
                fillColor: widget.enabled
                    ? widget.fillColor ?? context.theme.scaffoldBackgroundColor
                    : (widget.fillColor ??
                            context.theme.scaffoldBackgroundColor)
                        .withOpacity(.75),
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: AppFontWeight.normal.value,
                  color: context.textTheme.bodyMedium?.color?.withOpacity(.75),
                  fontSize: _fontSize,
                ),
                labelStyle: context.textTheme.titleMedium?.copyWith(
                  fontWeight: AppFontWeight.medium.value,
                ),
                contentPadding: EdgeInsets.all(_padding),
                helperStyle: context.textTheme.labelSmall,
                prefix: Text(widget.prefix ?? ''),
                suffixIconConstraints: _boxConstraints,
                prefixIconConstraints: _boxConstraints,
                suffixIcon: widget.suffixIcon,
                prefixIcon: widget.prefixIcon,
                hintText: widget.hintText,
                labelText: widget.labelText,
                errorText: widget.errorText == '' ? null : widget.errorText,
                errorStyle: context.textTheme.labelSmall?.copyWith(
                  color: Colors.red,
                ),
                constraints: _boxConstraints,
                errorMaxLines: 2,
                counterText: '',
                floatingLabelBehavior: widget.floatingLabelBehavior,
                focusedErrorBorder: _border(Colors.red),
                disabledBorder: _border(Colors.grey),
                enabledBorder: _border(Colors.grey),
                focusedBorder: _border(Colors.grey),
                errorBorder: _border(Colors.red),
                border: _border(Colors.grey),
                alignLabelWithHint: true,
              ),
              onChanged: widget.onChanged,
              autofocus: widget.autofocus,
              validator: widget.validator ?? _validator,
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? context.theme.borderRadiusXLG,
      borderSide: BorderSide(color: color, width: .5),
    );
  }
}
