import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../extensions/build_context_extensions.dart';
import 'custom_input_field.dart';
import 'input_label.dart';

/// Campo de código (PIN/OTP) em caixas, feito sobre o [CustomInputField].
///
/// Um único [CustomInputField] invisível recebe a digitação (teclado,
/// colar, autofill de SMS e apagar funcionam como num input comum) e as
/// caixas só desenham o valor atual.
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
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String? _validationError;

  double get _boxSize => const Spacing(7).value;

  String? get _errorMessage {
    if (widget.errorText?.isNotEmpty ?? false) return widget.errorText;
    if (_validationError?.isNotEmpty ?? false) return _validationError;
    return null;
  }

  bool get _hasError => _errorMessage != null;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_onControllerChanged);
    _focusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _focusNode.removeListener(_refresh);
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
    widget.onChanged?.call(value);
    if (value.length == widget.maxLength) {
      _focusNode.unfocus();
      widget.onComplete?.call(value);
    }
  }

  String? _validator(String? input) {
    String? error = widget.validator?.call(input);
    for (final validator in widget.validators ?? const []) {
      error ??= validator(input);
    }
    // Guarda o erro para pintar as caixas e mostrar a mensagem.
    if (error != _validationError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _validationError = error);
      });
    }
    return error;
  }

  Color _borderColor(int index) {
    if (_hasError) return context.colorScheme.error;
    final isCurrent =
        _focusNode.hasFocus &&
        (index == _controller.text.length ||
            (index == widget.maxLength - 1 &&
                _controller.text.length == widget.maxLength));
    if (isCurrent) return context.colorScheme.primary;
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    final fillColor = widget.fillColor ?? context.colorScheme.surface;
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
            child: SizedBox(
              height: _boxSize,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: List.generate(widget.maxLength, (index) {
                          final char = index < text.length ? text[index] : '';
                          return AnimatedContainer(
                            width: _boxSize,
                            height: _boxSize,
                            alignment: .center,
                            duration: Durations.short3,
                            decoration: BoxDecoration(
                              color: fillColor,
                              borderRadius: context.theme.borderRadiusXSM,
                              border: .all(color: _borderColor(index)),
                            ),
                            child: AnimatedSwitcher(
                              duration: Durations.short3,
                              child: Text(
                                widget.obscureText && char.isNotEmpty
                                    ? '•'
                                    : char,
                                key: ValueKey('$index$char'),
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      context.textTheme.fontWeightMedium,
                                  color: const Color(0xFF4E4B59),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomInputField(
                      showCursor: false,
                      focusNode: _focusNode,
                      controller: _controller,
                      readOnly: widget.readOnly,
                      autofocus: widget.autofocus,
                      isEnabled: widget.isEnabled,
                      validator: _validator,
                      onChanged: _onChanged,
                      errorText: widget.errorText ?? '',
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      onFieldSubmitted: widget.onFieldSubmitted,
                      autovalidateMode: widget.autovalidateMode,
                      textCapitalization: widget.textCapitalization,
                      enableinteractiveSelection: false,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      fillColor: Colors.transparent,
                      cursorColor: Colors.transparent,
                      borderSide: BorderSide.none,
                      contentPadding: .zero,
                      opacityDisabled: 1,
                      // O erro é desenhado abaixo das caixas.
                      errorStyle: const TextStyle(fontSize: 0, height: 0),
                      textStyle: TextStyle(
                        color: Colors.transparent,
                        fontSize: _boxSize * .5,
                      ),
                      inputFormatters: [
                        ...widget.inputFormatters,
                        if (widget.keyboardType == TextInputType.number)
                          FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(widget.maxLength),
                      ],
                      prefixIcon: const SizedBox.shrink(),
                      suffixIcon: const SizedBox.shrink(),
                      heightType: .medium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_errorMessage case final message?)
            Padding(
              padding: .only(top: const Spacing(1).value),
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
