part of 'custom_pin_input.dart';

/// Recebe a digitação do [CustomPinField] (teclado, colar, autofill de SMS)
/// sem desenhar nada: um [EditableText] puro, sem decoração do Material,
/// atrás das caixas. As caixas é que mostram valor, foco, erro e
/// desabilitado. O [FormField] liga o campo ao `Form.validate()`.
extension on _CustomPinFieldState {
  Widget _input() {
    return FormField<String>(
      validator: (_) => _formValidator(_controller.text),
      builder: (_) => Opacity(
        opacity: 0,
        child: EditableText(
          controller: _controller,
          focusNode: _focusNode,
          showCursor: false,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: widget.autofocus && widget.isEnabled,
          readOnly: widget.readOnly || !widget.isEnabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction ?? .done,
          textCapitalization: widget.textCapitalization,
          autofillHints: const [AutofillHints.oneTimeCode],
          enableInteractiveSelection: false,
          onChanged: _onChanged,
          onSubmitted: _onSubmitted,
          style: const TextStyle(color: Colors.transparent),
          cursorColor: Colors.transparent,
          backgroundCursorColor: Colors.transparent,
          inputFormatters: [
            ...widget.inputFormatters,
            if (widget.keyboardType == TextInputType.number)
              FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(widget.maxLength),
          ],
        ),
      ),
    );
  }
}
