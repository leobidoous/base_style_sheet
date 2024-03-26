import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../custom_loading.dart';
import '../custom_tooltip.dart';

enum ButtonType { primary, secondary, tertiary, background, noShape }

enum ButtonHeightType { normal, small }

class CustomButton extends StatefulWidget {
  factory CustomButton.text({
    ButtonType type = ButtonType.primary,
    TextStyle? textStyle,
    ButtonHeightType heightType = ButtonHeightType.normal,
    Function()? onPressed,
    required String text,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    EdgeInsets? padding,
    Color? color,
  }) {
    return CustomButton(
      type: type,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.md.value),
      color: color,
      isSafe: isSafe,
      child: _textValue(text, type: type, textStyle: textStyle),
    );
  }

  factory CustomButton.icon({
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
    Function()? onPressed,
    required IconData icon,
    Color? iconColor,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    EdgeInsets? padding = EdgeInsets.zero,
    Color? color,
  }) {
    return CustomButton(
      type: type,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.md.value),
      color: color,
      isSafe: isSafe,
      child: _iconValue(icon, type: type, iconColor: iconColor),
    );
  }

  factory CustomButton.child({
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
    Function()? onPressed,
    required Widget child,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    Color? color,
    EdgeInsets? padding = EdgeInsets.zero,
  }) {
    return CustomButton(
      type: type,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.md.value),
      color: color,
      isSafe: isSafe,
      child: child,
    );
  }

  factory CustomButton.iconText({
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
    TextStyle? textStyle,
    Color? iconColor,
    Function()? onPressed,
    required IconData icon,
    required String text,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    EdgeInsets? padding,
    Color? color,
  }) {
    return CustomButton(
      type: type,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.md.value),
      color: color,
      isSafe: isSafe,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconValue(icon, type: type, iconColor: iconColor),
          Spacing.xs.horizontal,
          Flexible(child: _textValue(text, type: type, textStyle: textStyle)),
        ],
      ),
    );
  }

  factory CustomButton.textIcon({
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.normal,
    TextStyle? textStyle,
    Color? iconColor,
    Function()? onPressed,
    required IconData icon,
    required String text,
    bool isEnabled = true,
    bool isLoading = false,
    bool isSafe = false,
    EdgeInsets? padding,
    Color? color,
  }) {
    return CustomButton(
      type: type,
      onPressed: onPressed,
      heightType: heightType,
      isEnabled: isEnabled,
      isLoading: isLoading,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.md.value),
      color: color,
      isSafe: isSafe,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: _textValue(text, type: type, textStyle: textStyle)),
          Spacing.xs.horizontal,
          _iconValue(icon, type: type, iconColor: iconColor),
        ],
      ),
    );
  }
  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isEnabled = true,
    this.padding = EdgeInsets.zero,
    this.isLoading = false,
    this.isSafe = false,
    this.color,
    this.type = ButtonType.primary,
    this.heightType = ButtonHeightType.normal,
  }) : assert(
          color != null && type == ButtonType.background || color == null,
          '[type] must be background',
        );
  final Color? color;
  final ButtonType type;
  final ButtonHeightType heightType;
  final Function()? onPressed;
  final Widget child;
  final bool isEnabled;
  final bool isLoading;
  final bool isSafe;
  final EdgeInsets padding;

  @override
  State<CustomButton> createState() => _CustomButtonState();

  static Widget _iconValue(
    IconData iconData, {
    Color? iconColor,
    ButtonType type = ButtonType.primary,
  }) {
    return Builder(
      builder: (context) {
        return Icon(
          iconData,
          size: AppFontSize.iconButton.value,
          color: iconColor ??
              (context.isDarkMode
                  ? context.colorScheme.onBackground
                  : switch (type) {
                      ButtonType.secondary => context.colorScheme.onSecondary,
                      ButtonType.tertiary => context.colorScheme.onTertiary,
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
        double? fontSize;
        switch (heightType) {
          case ButtonHeightType.normal:
            fontSize = context.textTheme.bodyMedium?.fontSize;
            break;
          case ButtonHeightType.small:
            fontSize = context.textTheme.bodySmall?.fontSize;
            break;
        }
        return CustomTooltip(
          message: text,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                text,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: textStyle ??
                    context.textTheme.bodyMedium?.copyWith(
                      fontWeight: context.textTheme.fontWeightBold,
                      fontSize: fontSize,
                      color: (context.isDarkMode
                          ? context.colorScheme.onBackground
                          : switch (type) {
                              ButtonType.secondary =>
                                context.colorScheme.onSecondary,
                              ButtonType.tertiary =>
                                context.colorScheme.onTertiary,
                              ButtonType() =>
                                context.textTheme.bodyMedium?.color,
                            }),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomButtonState extends State<CustomButton> {
  Size get minimumSize {
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
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: context.theme.borderRadiusXLG.topLeft,
                  topRight: context.theme.borderRadiusXLG.topRight,
                  bottomLeft: widget.isSafe
                      ? Radius.zero
                      : context.theme.borderRadiusXLG.bottomLeft,
                  bottomRight: widget.isSafe
                      ? Radius.zero
                      : context.theme.borderRadiusXLG.bottomRight,
                ),
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color: _borderColor,
                width: context.theme.borderWidthXS,
              ),
            ),
            elevation: MaterialStateProperty.all(5),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: MaterialStateProperty.all(widget.padding),
            minimumSize: MaterialStateProperty.all(minimumSize),
            overlayColor: MaterialStateProperty.all(_overlayColor),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(_backgroundColor),
            surfaceTintColor: MaterialStateProperty.all(_surfaceTintColor),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: SafeArea(
            bottom: widget.isSafe,
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minimumSize.height),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: widget.isLoading
                    ? CustomLoading(
                        height: const Spacing(1).value,
                        width: const Spacing(1).value,
                      )
                    : widget.child,
              ),
            ),
          ),
        ),
      ),
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
        return context.colorScheme.background;
      case ButtonType.tertiary:
        return context.colorScheme.tertiary;
      case ButtonType.noShape:
        return Colors.transparent;
    }
  }

  Color get _overlayColor {
    if (widget.color != null) return widget.color!.withOpacity(.1);
    switch (widget.type) {
      case ButtonType.primary:
        return context.colorScheme.onPrimary.withOpacity(.1);
      case ButtonType.secondary:
        return context.colorScheme.onSecondary.withOpacity(.1);
      case ButtonType.background:
        return context.colorScheme.onBackground.withOpacity(.1);
      case ButtonType.noShape:
        return Colors.transparent.withOpacity(.1);
      case ButtonType.tertiary:
        return context.colorScheme.tertiary.withOpacity(.1);
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
