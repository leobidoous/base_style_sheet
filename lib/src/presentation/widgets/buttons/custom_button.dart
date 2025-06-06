import 'package:flutter/material.dart';

import '../../../../base_style_sheet.dart';

enum ButtonType { primary, secondary, tertiary, background, noShape }

enum ButtonHeightType { normal, small }

class CustomButton extends StatefulWidget {
  factory CustomButton.text({
    ButtonType type = ButtonType.primary,
    TextStyle? textStyle,
    ButtonHeightType heightType = ButtonHeightType.normal,
    Function()? onPressed,
    required String text,
    Alignment? alignment,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Color? color,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
  }) {
    return CustomButton(
      type: type,
      alignment: alignment,
      borderRadius: borderRadius,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      color: color,
      isSafe: isSafe,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      child: CustomTooltip(
        verticalOffset: switch (heightType) {
          ButtonHeightType.normal => Spacing.md.value,
          ButtonHeightType.small => Spacing.sm.value,
        },
        message: text,
        child: _textValue(text, type: type, textStyle: textStyle),
      ),
    );
  }

  factory CustomButton.icon({
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
    Function()? onPressed,
    required IconData icon,
    Alignment? alignment,
    Color? iconColor,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    EdgeInsets? padding = EdgeInsets.zero,
    BorderRadius? borderRadius,
    Color? color,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
  }) {
    return CustomButton(
      type: type,
      alignment: alignment,
      borderRadius: borderRadius,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      color: color,
      isSafe: isSafe,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      child: _iconValue(
        icon,
        type: type,
        iconColor: iconColor,
        heightType: heightType,
      ),
    );
  }

  factory CustomButton.child({
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
    Function()? onPressed,
    Alignment? alignment,
    required Widget child,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    Color? color,
    BorderRadius? borderRadius,
    EdgeInsets? padding = EdgeInsets.zero,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
  }) {
    return CustomButton(
      type: type,
      alignment: alignment,
      borderRadius: borderRadius,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      color: color,
      isSafe: isSafe,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      child: child,
    );
  }

  factory CustomButton.iconText({
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
    TextStyle? textStyle,
    Alignment? alignment,
    Color? iconColor,
    Function()? onPressed,
    required IconData icon,
    required String text,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Color? color,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
  }) {
    return CustomButton(
      type: type,
      alignment: alignment,
      borderRadius: borderRadius,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      color: color,
      isSafe: isSafe,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      child: CustomTooltip(
        verticalOffset: switch (heightType) {
          ButtonHeightType.normal => Spacing.md.value,
          ButtonHeightType.small => Spacing.sm.value,
        },
        message: text,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconValue(
              icon,
              type: type,
              iconColor: iconColor,
              heightType: heightType,
            ),
            Spacing.xxs.horizontal,
            Flexible(child: _textValue(text, type: type, textStyle: textStyle)),
          ],
        ),
      ),
    );
  }

  factory CustomButton.textIcon({
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
    TextStyle? textStyle,
    Color? iconColor,
    Alignment? alignment,
    Function()? onPressed,
    required IconData icon,
    required String text,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    EdgeInsets? padding,
    Color? color,
    BorderRadius? borderRadius,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
  }) {
    return CustomButton(
      type: type,
      alignment: alignment,
      borderRadius: borderRadius,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      color: color,
      isSafe: isSafe,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      child: CustomTooltip(
        verticalOffset: switch (heightType) {
          ButtonHeightType.normal => Spacing.md.value,
          ButtonHeightType.small => Spacing.sm.value,
        },
        message: text,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: _textValue(text, type: type, textStyle: textStyle)),
            Spacing.xxs.horizontal,
            _iconValue(
              icon,
              type: type,
              iconColor: iconColor,
              heightType: heightType,
            ),
          ],
        ),
      ),
    );
  }

  const CustomButton({
    super.key,
    this.color,
    this.alignment,
    this.borderRadius,
    required this.child,
    this.isSafe = false,
    this.isEnabled = true,
    this.isLoading = false,
    required this.onPressed,
    this.loadingPrimaryColor,
    this.loadingSecondaryColor,
    this.padding = EdgeInsets.zero,
    this.type = ButtonType.primary,
    this.heightType = ButtonHeightType.normal,
  }) : assert(
          color != null && type == ButtonType.background || color == null,
          '[type] must be background',
        );

  final Color? color;
  final bool isSafe;
  final Widget child;
  final bool isEnabled;
  final bool isLoading;
  final ButtonType type;
  final EdgeInsets padding;
  final Alignment? alignment;
  final Function()? onPressed;
  final Color? loadingPrimaryColor;
  final BorderRadius? borderRadius;
  final ButtonHeightType heightType;
  final Color? loadingSecondaryColor;

  @override
  State<CustomButton> createState() => _CustomButtonState();

  static Widget _iconValue(
    IconData iconData, {
    Color? iconColor,
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
  }) {
    return Builder(
      builder: (context) {
        return Icon(
          iconData,
          size: switch (heightType) {
            ButtonHeightType.normal => AppFontSize.iconButton.value,
            ButtonHeightType.small => AppFontSize.iconButton.value * .9,
          },
          color: iconColor ??
              (context.isDarkMode
                  ? context.colorScheme.onSurface
                  : switch (type) {
                      ButtonType.secondary => context.colorScheme.onSecondary,
                      ButtonType.tertiary => context.colorScheme.onTertiary,
                      ButtonType.primary => context.colorScheme.onPrimary,
                      ButtonType() => context.textTheme.bodyMedium?.color,
                    }),
        );
      },
    );
  }

  static Widget _textValue(
    String text, {
    TextStyle? textStyle,
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
  }) {
    return Builder(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              text,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              minFontSize: 8,
              style: textStyle ??
                  context.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppFontWeight.bold.value,
                    fontSize: switch (heightType) {
                      ButtonHeightType.small => AppFontSize.bodySmall.value,
                      ButtonHeightType.normal => AppFontSize.bodyMedium.value,
                    },
                    color: (context.isDarkMode
                        ? context.colorScheme.onSurface
                        : switch (type) {
                            ButtonType.secondary =>
                              context.colorScheme.onSecondary,
                            ButtonType.tertiary =>
                              context.colorScheme.onTertiary,
                            ButtonType.primary => context.colorScheme.onPrimary,
                            ButtonType() => context.textTheme.bodyMedium?.color,
                          }),
                  ),
            ),
          ],
        );
      },
    );
  }
}

class _CustomButtonState extends State<CustomButton> {
  Size get _minimumSize {
    switch (widget.heightType) {
      case ButtonHeightType.normal:
        return Size(
          AppThemeBase.buttonHeightMD,
          AppThemeBase.buttonHeightMD,
        );
      case ButtonHeightType.small:
        return Size(
          AppThemeBase.buttonHeightSM,
          AppThemeBase.buttonHeightSM,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: !widget.isEnabled ? 0.5 : 1,
      child: AbsorbPointer(
        absorbing: widget.isLoading || !widget.isEnabled,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ButtonStyle(
            backgroundBuilder: (context, states, child) {
              return ColoredBox(
                color: switch (widget.type) {
                  ButtonType.background => context.colorScheme.surface,
                  ButtonType() => Colors.transparent
                },
                child: ColoredBox(color: _backgroundColor, child: child),
              );
            },
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft:
                      (widget.borderRadius ?? context.theme.borderRadiusXLG)
                          .topLeft,
                  topRight:
                      (widget.borderRadius ?? context.theme.borderRadiusXLG)
                          .topRight,
                  bottomLeft: widget.isSafe
                      ? Radius.zero
                      : (widget.borderRadius ?? context.theme.borderRadiusXLG)
                          .bottomLeft,
                  bottomRight: widget.isSafe
                      ? Radius.zero
                      : (widget.borderRadius ?? context.theme.borderRadiusXLG)
                          .bottomRight,
                ),
              ),
            ),
            side: WidgetStateProperty.all(
              BorderSide(color: _borderColor, width: .5),
            ),
            elevation: WidgetStateProperty.all(4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: WidgetStateProperty.all(widget.padding),
            minimumSize: WidgetStateProperty.all(_minimumSize),
            overlayColor: WidgetStateProperty.all(_overlayColor),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            backgroundColor: WidgetStateProperty.all(_backgroundColor),
            surfaceTintColor: WidgetStateProperty.all(_surfaceTintColor),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: SafeArea(
            bottom: widget.isSafe,
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: _minimumSize.height,
                minWidth: _minimumSize.width,
              ),
              child: widget.alignment == null
                  ? _child
                  : Align(
                      alignment: widget.alignment!,
                      child: _child,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _child {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: widget.isLoading
          ? CustomLoading(
              primaryColor: widget.loadingPrimaryColor,
              secondaryColor: widget.loadingSecondaryColor,
              height: const Spacing(1).value,
              width: const Spacing(1).value,
            )
          : widget.child,
    );
  }

  Color get _backgroundColor {
    if (widget.color != null) return widget.color!;
    switch (widget.type) {
      case ButtonType.primary:
        return context.colorScheme.primary;
      case ButtonType.secondary:
        return context.colorScheme.secondary;
      case ButtonType.background:
        return Colors.transparent;
      case ButtonType.noShape:
        return Colors.transparent;
      case ButtonType.tertiary:
        return context.colorScheme.tertiary;
    }
  }

  Color get _surfaceTintColor {
    if (widget.color != null) return widget.color!;
    switch (widget.type) {
      case ButtonType.primary:
        return context.colorScheme.primary;
      case ButtonType.secondary:
        return context.colorScheme.secondary;
      case ButtonType.background:
        return context.colorScheme.surface;
      case ButtonType.tertiary:
        return context.colorScheme.tertiary;
      case ButtonType.noShape:
        return Colors.transparent;
    }
  }

  Color get _overlayColor {
    if (widget.color != null) return widget.color!.withValues(alpha: .1);
    switch (widget.type) {
      case ButtonType.primary:
        return context.colorScheme.onPrimary.withValues(alpha: .1);
      case ButtonType.secondary:
        return context.colorScheme.onSecondary.withValues(alpha: .1);
      case ButtonType.background:
        return context.colorScheme.onSurface.withValues(alpha: .1);
      case ButtonType.noShape:
        return Colors.transparent.withValues(alpha: .1);
      case ButtonType.tertiary:
        return context.colorScheme.tertiary.withValues(alpha: .1);
    }
  }

  Color get _borderColor {
    if (widget.color != null) return widget.color!;
    switch (widget.type) {
      case ButtonType.primary:
        return context.colorScheme.primary;
      case ButtonType.secondary:
        return context.colorScheme.secondary;
      case ButtonType.background:
        return context.colorScheme.primary;
      case ButtonType.tertiary:
        return context.colorScheme.tertiary;
      case ButtonType.noShape:
        return Colors.transparent;
    }
  }
}
