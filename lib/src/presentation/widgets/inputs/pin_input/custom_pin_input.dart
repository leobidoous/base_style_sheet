import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../../../../core/themes/app_theme_base.dart';
import '../../../../core/themes/app_theme_factory.dart';
import '../../../../core/themes/spacing/spacing.dart';
import '../../../../core/themes/typography/typography_constants.dart';
import '../../../extensions/build_context_extensions.dart';
import '../custom_input_field.dart' show InputHeightType;
import '../input_label.dart';

part 'custom_pin_box.dart';
part 'custom_pin_hidden_input.dart';

/// Campo de código (PIN/OTP) em caixas sobre um [EditableText] invisível.
/// Valida ao completar/submit/`Form.validate()`, nunca a cada tecla.
/// [hintText]: um caractere por caixa (`'123456'`) ou um repetido (`'0'`).
class CustomPinField extends StatefulWidget {
  const CustomPinField({
    super.key,
    this.hintText,
    this.fillColor,
    this.errorText,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.borderSide,
    this.controller,
    this.validators,
    this.onComplete,
    this.labelWidget,
    this.initialValue,
    this.borderRadius,
    this.maxLength = 4,
    this.labelText = '',
    this.padding = .zero,
    this.textInputAction,
    this.autofocus = true,
    this.isEnabled = true,
    this.readOnly = false,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.heightType = .medium,
    this.spacing = Spacing.xs,
    this.keyboardType = .number,
    this.inputFormatters = const [],
    this.textCapitalization = .sentences,
    this.autovalidateMode = .onUserInteraction,
  });

  final int maxLength;
  final bool readOnly;
  final bool autofocus;
  final bool isEnabled;
  final Spacing spacing;
  final Color? fillColor;
  final String? hintText;
  final bool obscureText;
  final String? labelText;
  final String? errorText;
  final EdgeInsets padding;
  final FocusNode? focusNode;
  final String? initialValue;
  final BorderSide? borderSide;
  final InputLabel? labelWidget;
  final BorderRadius? borderRadius;
  final TextInputType keyboardType;
  final InputHeightType heightType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final Function(String input)? onComplete;

  /// `disabled` não valida ao completar (nunca valida a cada tecla).
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

class _CustomPinFieldState extends State<CustomPinField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _cursor;
  String? _validationError;

  double get _height => switch (widget.heightType) {
    .medium => AppThemeBase.buttonHeightMD,
    .normal => AppThemeBase.buttonHeightNM,
    .small => AppThemeBase.buttonHeightSM,
  };

  double get _fontSize => switch (widget.heightType) {
    .medium => AppFontSize.titleMedium.value,
    .normal => AppFontSize.bodyLarge.value,
    .small => AppFontSize.bodyMedium.value,
  };

  String? get _errorMessage {
    if (widget.errorText?.isNotEmpty ?? false) return widget.errorText;
    if (_validationError?.isNotEmpty ?? false) return _validationError;
    return null;
  }

  bool get _hasError => _errorMessage != null;

  bool get _validatesOnComplete =>
      widget.autovalidateMode != AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _cursor = AnimationController(vsync: this, duration: Durations.long4)
      ..repeat(reverse: true);
    _controller.addListener(_onControllerChanged);
    _focusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _focusNode.removeListener(_refresh);
    _cursor.dispose();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomPinField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnabled && !widget.isEnabled) _focusNode.unfocus();
  }

  void _requestFocus() {
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  /// O cursor fica sempre no fim: as caixas são preenchidas em ordem.
  void _onControllerChanged() {
    final end = _controller.text.length;
    final selection = _controller.selection;
    if (selection.baseOffset != end || selection.extentOffset != end) {
      _controller.selection = TextSelection.collapsed(offset: end);
    }
    _refresh();
  }

  void _onChanged(String value) {
    if (value.length < widget.maxLength && _validationError != null) {
      setState(() => _validationError = null);
    }
    widget.onChanged?.call(value);
    if (value.length == widget.maxLength) {
      _validate(value);
      _focusNode.unfocus();
      widget.onComplete?.call(value);
    }
  }

  void _validate(String value) {
    if (_validatesOnComplete) setState(() => _validationError = _run(value));
  }

  void _onSubmitted(String value) {
    _validate(value);
    widget.onFieldSubmitted?.call(value);
  }

  String? _run(String? input) {
    String? error = widget.validator?.call(input);
    for (final validator in widget.validators ?? const []) {
      error ??= validator(input);
    }
    return error;
  }

  /// Chamado só pelo `Form.validate()` (o input interno não autovalida).
  String? _formValidator(String? input) {
    final error = _run(input);
    if (error != _validationError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _validationError = error);
      });
    }
    return error;
  }

  bool _isActive(int index) {
    if (!widget.isEnabled || !_focusNode.hasFocus) return false;
    final length = _controller.text.length;
    return index == length ||
        (index == widget.maxLength - 1 && length == widget.maxLength);
  }

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
          Opacity(
            opacity: widget.isEnabled ? 1 : .5,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gap = widget.spacing.value;
                final count = widget.maxLength;
                // Quadradas; encolhem se faltar largura, com o mesmo espaço.
                final size = math.min(
                  _height,
                  (constraints.maxWidth - gap * (count - 1)) / count,
                );
                return SizedBox(
                  height: size,
                  child: Stack(
                    children: [
                      Positioned.fill(child: _input()),
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: .opaque,
                          onTap: widget.isEnabled ? _requestFocus : null,
                          child: Row(
                            mainAxisAlignment: .center,
                            spacing: gap,
                            children: List.generate(
                              count,
                              (index) => _PinBox(
                                size: size,
                                fontSize: _fontSize,
                                cursor: _cursor,
                                active: _isActive(index),
                                hint: _hintAt(index),
                                obscureText: widget.obscureText,
                                borderSide: _borderSide(index),
                                fillColor: widget.fillColor,
                                borderRadius: widget.borderRadius,
                                char: index < _controller.text.length
                                    ? _controller.text[index]
                                    : '',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_errorMessage case final message?)
            Padding(
              padding: .only(top: Spacing.xs.value),
              child: AutoSizeText(
                message,
                maxLines: 2,
                overflow: .ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
