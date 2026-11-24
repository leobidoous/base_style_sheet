import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/themes/app_theme_base.dart';
import '../../../../core/themes/app_theme_factory.dart';
import '../../../../core/themes/spacing/spacing.dart';
import '../../../../core/themes/typography/typography_constants.dart';
import '../../../extensions/build_context_extensions.dart';
import '../custom_input_field.dart';
import '../input_label.dart';

part 'custom_pin_box.dart';
part 'custom_pin_hidden_input.dart';

/// Campo de código (PIN/OTP) em caixas. Um [CustomInputField] invisível
/// recebe a digitação (colar e autofill de SMS incluídos); as caixas só
/// desenham o valor. Valida ao completar, no submit ou no `Form.validate()`,
/// nunca a cada tecla. [hintText] é o placeholder: um caractere por caixa
/// (`'123456'`) ou um único repetido em todas (`'0'`).
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

  /// `disabled` desliga a validação ao completar; qualquer outro valor
  /// valida quando o código fica completo (nunca a cada tecla).
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
    // Voltou a editar: o erro anterior deixa de valer.
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
    if (!_focusNode.hasFocus) return false;
    final length = _controller.text.length;
    return index == length ||
        (index == widget.maxLength - 1 && length == widget.maxLength);
  }

  String _hintAt(int index) {
    final hint = widget.hintText ?? '';
    if (hint.isEmpty) return '';
    if (hint.length == 1) return hint;
    return index < hint.length ? hint[index] : '';
  }

  BorderSide _borderSide(int index) {
    final base = widget.borderSide ?? const BorderSide(color: Colors.grey);
    if (_hasError) {
      return base.copyWith(color: context.colorScheme.error, width: 1);
    }
    if (_isActive(index)) {
      return base.copyWith(color: context.colorScheme.primary, width: 1);
    }
    return base.copyWith(width: widget.borderSide?.width ?? .5);
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
                // Caixas quadradas na altura do input; encolhem se faltar
                // largura, mantendo o mesmo espaço entre elas.
                final size = math.min(
                  _height,
                  (constraints.maxWidth - gap * (count - 1)) / count,
                );
                return SizedBox(
                  height: size,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: IgnorePointer(
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
                      Positioned.fill(child: _input(size)),
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
