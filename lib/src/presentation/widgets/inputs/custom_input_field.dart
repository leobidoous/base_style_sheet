import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import 'input_label.dart';

enum InputHeightType { medium, normal, small }

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    super.key,
    this.prefix,
    this.onTap,
    this.fillColor,
    this.hintText,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.maxLength,
    this.validators,
    this.borderSide,
    this.controller,
    this.errorStyle,
    this.inputLabel,
    this.borderRadius,
    this.maxLines = 1,
    this.onTapOutside,
    this.keyboardType,
    this.initialValue,
    this.buildCounter,
    this.focusedBorder,
    this.labelText = '',
    this.errorText = '',
    this.contentPadding,
    this.isEnabled = true,
    this.isDense = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.counterText = '',
    this.readOnly = false,
    this.isExpanded = true,
    this.autofocus = false,
    this.onEditingComplete,
    this.isCollapsed = true,
    this.textAlign = .start,
    this.autocorrect = false,
    this.obscureText = false,
    this.heightType = .medium,
    this.opacityDisabled = 0.5,
    this.autofillHints = const [],
    this.enableSuggestions = false,
    this.inputFormatters = const [],
    this.floatingLabelBehavior = .always,
    this.textCapitalization = .sentences,
    this.enableinteractiveSelection = true,
    this.autovalidateMode = .onUserInteraction,
  });

  final List<String? Function(String?)>? validators;
  final FloatingLabelBehavior floatingLabelBehavior;
  final List<TextInputFormatter>? inputFormatters;
  final Function(PointerDownEvent)? onTapOutside;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool enableinteractiveSelection;
  final Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final InputBorder? focusedBorder;
  final InputHeightType heightType;
  final EdgeInsets? contentPadding;
  final BorderRadius? borderRadius;
  final List<String> autofillHints;
  final double? opacityDisabled;
  final BorderSide? borderSide;
  final InputLabel? inputLabel;
  final bool enableSuggestions;
  final TextStyle? errorStyle;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextAlign textAlign;
  final String? counterText;
  final String? labelText;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final bool autocorrect;
  final bool isCollapsed;
  final bool obscureText;
  final bool isExpanded;
  final Color? fillColor;
  final bool autofocus;
  final bool isEnabled;
  final int? maxLength;
  final String? prefix;
  final int? minLines;
  final bool readOnly;
  final bool isDense;
  final int maxLines;
  final Function()? onTap;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })?
  buildCounter;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  BoxConstraints get _boxConstraints {
    switch (widget.heightType) {
      case .medium:
        return BoxConstraints(
          minHeight: AppThemeBase.buttonHeightMD,
          minWidth: AppThemeBase.buttonHeightMD,
        );
      case .normal:
        return BoxConstraints(
          minHeight: AppThemeBase.buttonHeightNM,
          minWidth: AppThemeBase.buttonHeightNM,
        );
      case .small:
        return BoxConstraints(
          minHeight: AppThemeBase.buttonHeightSM,
          minWidth: AppThemeBase.buttonHeightSM,
        );
    }
  }

  String? _validator(String? input) {
    String? error = widget.validator?.call(input);
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
      case .medium:
        return AppFontSize.bodyMedium.value;
      case .normal:
        return (AppFontSize.bodyMedium.value + AppFontSize.bodySmall.value) / 2;
      case .small:
        return AppFontSize.bodySmall.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        if (widget.inputLabel != null) ...[
          widget.inputLabel!,
          Spacing.xxxs.vertical,
        ],
        Flexible(
          child: Opacity(
            opacity: widget.isEnabled ? 1 : .5,
            child: TextFormField(
              key: widget.key,
              onTap: widget.onTap,
              enabled: widget.isEnabled,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              readOnly: widget.readOnly,
              smartDashesType: .enabled,
              textAlignVertical: .center,
              maxLength: widget.maxLength,
              textAlign: widget.textAlign,
              focusNode: widget.focusNode,
              controller: widget.controller,
              autocorrect: widget.autocorrect,
              keyboardType: widget.keyboardType,
              autofillHints: widget.autofillHints,
              initialValue: widget.initialValue,
              buildCounter: widget.buildCounter,
              onTapOutside: widget.onTapOutside,
              inputFormatters: widget.inputFormatters,
              autovalidateMode: widget.autovalidateMode,
              onFieldSubmitted: widget.onFieldSubmitted,
              cursorRadius: .circular(Spacing.md.value),
              enableSuggestions: widget.enableSuggestions,
              onEditingComplete: widget.onEditingComplete,
              textCapitalization: widget.textCapitalization,
              textInputAction: widget.textInputAction ?? .done,
              enableInteractiveSelection: widget.enableinteractiveSelection,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: AppFontWeight.normal.value,
                fontSize: _fontSize,
              ),
              obscureText: widget.obscureText,
              decoration: InputDecoration(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                isCollapsed: widget.isCollapsed,
                isDense: widget.isDense,
                filled: widget.fillColor != null,
                fillColor: widget.isEnabled
                    ? widget.fillColor ?? context.colorScheme.surface
                    : (widget.fillColor ?? context.colorScheme.surface)
                          .withValues(alpha: .75),
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: AppFontWeight.normal.value,
                  color: context.textTheme.bodyMedium?.color?.withValues(
                    alpha: .75,
                  ),
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
                errorStyle:
                    widget.errorStyle ??
                    context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.error,
                    ),
                contentPadding:
                    widget.contentPadding ??
                    .symmetric(
                      horizontal: _fontSize,
                      vertical: widget.maxLines > 1 ? _fontSize : 0,
                    ),
                errorText: widget.errorText == '' ? null : widget.errorText,
                floatingLabelBehavior: widget.floatingLabelBehavior,
                focusedErrorBorder: _border(context.colorScheme.error),
                errorBorder: _border(context.colorScheme.error),
                disabledBorder: _border(Colors.grey),
                enabledBorder: _border(Colors.grey),
                focusedBorder: _border(Colors.grey),
                border: _border(Colors.grey),
                alignLabelWithHint: true,
              ),
              onChanged: widget.onChanged,
              autofocus: widget.autofocus,
              validator: _validator,
            ),
          ),
        ),
      ],
    );
    if (widget.isExpanded) return child;

    return IntrinsicWidth(child: child);
  }

  InputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? context.theme.borderRadiusXLG,
      borderSide: widget.borderSide ?? BorderSide(color: color, width: .5),
    );
  }
}
