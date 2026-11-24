part of 'custom_pin_input.dart';

/// Input invisível que recebe a digitação do [CustomPinField] (teclado,
/// colar, autofill de SMS); as caixas só desenham o valor.
extension on _CustomPinFieldState {
  Widget _input(double size) {
    return CustomInputField(
      showCursor: false,
      focusNode: _focusNode,
      controller: _controller,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      isEnabled: widget.isEnabled,
      validator: _formValidator,
      onChanged: _onChanged,
      heightType: widget.heightType,
      borderRadius: widget.borderRadius,
      errorText: widget.errorText ?? '',
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: _onSubmitted,
      // Nada de erro durante a digitação.
      autovalidateMode: .disabled,
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
      textStyle: TextStyle(color: Colors.transparent, fontSize: size * .5),
      inputFormatters: [
        ...widget.inputFormatters,
        if (widget.keyboardType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      prefixIcon: const SizedBox.shrink(),
      suffixIcon: const SizedBox.shrink(),
    );
  }
}
