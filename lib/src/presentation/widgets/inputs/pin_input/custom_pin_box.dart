part of 'custom_pin_input.dart';

/// Uma caixa do [CustomPinField]: mostra o caractere, o traço piscando
/// (quando ativa e vazia) ou o placeholder.
class _PinBox extends StatelessWidget {
  const _PinBox({
    this.fillColor,
    this.borderRadius,
    required this.char,
    required this.hint,
    required this.size,
    required this.active,
    required this.cursor,
    required this.fontSize,
    required this.borderSide,
    required this.obscureText,
  });

  final String char;
  final String hint;
  final double size;
  final bool active;
  final double fontSize;
  final bool obscureText;
  final Color? fillColor;
  final BorderSide borderSide;
  final BorderRadius? borderRadius;
  final Animation<double> cursor;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyLarge?.copyWith(
      fontSize: fontSize,
      fontWeight: context.textTheme.fontWeightMedium,
      color: const Color(0xFF4E4B59),
    );

    final Widget content;
    if (char.isNotEmpty) {
      content = Text(
        obscureText ? '•' : char,
        key: ValueKey('c$char'),
        style: style,
      );
    } else if (active) {
      content = FadeTransition(
        key: const ValueKey('cursor'),
        opacity: cursor,
        child: Container(
          width: 2,
          height: fontSize,
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: .circular(1),
          ),
        ),
      );
    } else {
      content = Text(
        hint,
        key: const ValueKey('hint'),
        style: style?.copyWith(color: Colors.grey.shade400),
      );
    }

    return AnimatedContainer(
      width: size,
      height: size,
      alignment: .center,
      duration: Durations.short3,
      decoration: BoxDecoration(
        color: fillColor ?? context.colorScheme.surface,
        border: .fromBorderSide(borderSide),
        borderRadius: borderRadius ?? context.theme.borderRadiusXLG,
      ),
      child: AnimatedSwitcher(duration: Durations.short3, child: content),
    );
  }
}
