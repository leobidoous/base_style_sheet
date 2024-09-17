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
    this.errorStyle,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.textInputAction,
    this.enabled = true,
    this.enableSuggestions = false,
    this.opacityDisabled = 0.5,
    this.labelWidget,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.contentPadding,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.fillColor,
    this.buildCounter,
    this.counterText = '',
    this.readOnly = false,
    this.heightType = InputHeightType.normal,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.focusedBorder,
    this.borderRadius,
    this.borderSide,
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
  final Function(String)? onChanged;
  final String? initialValue;
  final String? counterText;
  final String? labelText;
  final Color? fillColor;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String? prefix;
  final TextAlign textAlign;
  final TextStyle? errorStyle;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? minLines;
  final bool enableSuggestions;
  final bool autocorrect;
  final int maxLines;
  final bool autofocus;
  final bool enabled;
  final BorderRadius? borderRadius;
  final bool enableinteractiveSelection;
  final bool readOnly;
  final double? opacityDisabled;
  final InputHeightType heightType;
  final bool obscureText;
  final EdgeInsets? contentPadding;
  final List<String> autofillHints;
  final AutovalidateMode? autovalidateMode;
  final Function(String)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final InputLabel? labelWidget;
  final FloatingLabelBehavior floatingLabelBehavior;
  final InputBorder? focusedBorder;
  final BorderSide? borderSide;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? buildCounter;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  BoxConstraints get _boxConstraints {
    switch (widget.heightType) {
      case InputHeightType.normal:
        return BoxConstraints(
          minHeight: AppThemeBase.buttonHeightMD,
          minWidth: AppThemeBase.buttonHeightMD,
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
    switch (widget.heightType) {
      case InputHeightType.normal:
        return AppFontSize.bodyMedium.value;
      case InputHeightType.small:
        return AppFontSize.bodySmall.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.labelWidget != null) ...[
          widget.labelWidget!,
          Spacing.xxxs.vertical,
        ],
        Flexible(
          child: Opacity(
            opacity: widget.enabled ? 1 : .5,
            child: TextFormField(
              key: widget.key,
              onTap: widget.onTap,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              readOnly: widget.readOnly,
              maxLength: widget.maxLength,
              textAlign: widget.textAlign,
              focusNode: widget.focusNode,
              controller: widget.controller,
              autocorrect: widget.autocorrect,
              keyboardType: widget.keyboardType,
              autofillHints: widget.autofillHints,
              initialValue: widget.initialValue,
              buildCounter: widget.buildCounter,
              inputFormatters: widget.inputFormatters,
              smartDashesType: SmartDashesType.enabled,
              autovalidateMode: widget.autovalidateMode,
              onFieldSubmitted: widget.onFieldSubmitted,
              textAlignVertical: TextAlignVertical.center,
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
                isDense: true,
                isCollapsed: true,
                filled: widget.fillColor != null,
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
                errorMaxLines: 2,
                hintText: widget.hintText,
                labelText: widget.labelText,
                constraints: _boxConstraints,
                counterText: widget.counterText,
                prefix: Text(widget.prefix ?? ''),
                suffixIconConstraints: _boxConstraints.copyWith(
                  minWidth: widget.suffixIcon != null
                      ? _boxConstraints.minWidth
                      : widget.contentPadding?.right ?? _fontSize,
                ),
                prefixIconConstraints: _boxConstraints.copyWith(
                  minWidth: widget.prefixIcon != null
                      ? _boxConstraints.minWidth
                      : widget.contentPadding?.left ?? _fontSize,
                ),
                helperStyle: context.textTheme.labelSmall,
                suffixIcon: widget.suffixIcon ?? SizedBox(width: _fontSize),
                prefixIcon: widget.prefixIcon ?? SizedBox(width: _fontSize),
                errorStyle: widget.errorStyle ??
                    context.textTheme.labelSmall?.copyWith(color: Colors.red),
                contentPadding: widget.contentPadding ??
                    EdgeInsets.symmetric(
                      horizontal: _fontSize,
                      vertical: widget.maxLines > 1 ? _fontSize : 0,
                    ),
                errorText: widget.errorText == '' ? null : widget.errorText,
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
        ),
      ],
    );
  }

  InputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? context.theme.borderRadiusXLG,
      borderSide: widget.borderSide ?? BorderSide(color: color, width: .5),
    );
  }
}
