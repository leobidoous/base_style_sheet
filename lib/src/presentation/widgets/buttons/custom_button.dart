import 'package:flutter/material.dart';

import '../../../../base_style_sheet.dart';

enum ButtonType { primary, secondary, tertiary, background, noShape }

enum ButtonHeightType { medium, normal, small }

class CustomButton extends StatefulWidget {
  factory CustomButton.text({
    Color? color,
    Color? textColor,
    Color? borderColor,
    EdgeInsets? padding,
    bool isSafe = false,
    required String text,
    Alignment? alignment,
    TextStyle? textStyle,
    Function()? onPressed,
    bool isEnabled = true,
    bool isLoading = false,
    Decoration? decoration,
    BorderRadius? borderRadius,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.medium,
  }) {
    return CustomButton(
      type: type,
      color: color,
      isSafe: isSafe,
      alignment: alignment,
      onPressed: onPressed,
      isEnabled: isEnabled,
      isLoading: isLoading,
      decoration: decoration,
      heightType: heightType,
      borderColor: borderColor,
      borderRadius: borderRadius,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      child: CustomTooltip(
        verticalOffset: switch (heightType) {
          ButtonHeightType.medium => Spacing.md.value,
          ButtonHeightType.normal => Spacing.nm.value,
          ButtonHeightType.small => Spacing.sm.value,
        },
        message: text,
        child: _textValue(
          text,
          type: type,
          textStyle: textStyle,
          textColor: textColor,
        ),
      ),
    );
  }

  factory CustomButton.icon({
    Color? color,
    Color? iconColor,
    Color? borderColor,
    bool isSafe = false,
    Alignment? alignment,
    bool isEnabled = true,
    Function()? onPressed,
    required IconData icon,
    bool isLoading = false,
    Decoration? decoration,
    BorderRadius? borderRadius,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
    ButtonType type = ButtonType.primary,
    EdgeInsets? padding = EdgeInsets.zero,
    ButtonHeightType heightType = ButtonHeightType.medium,
  }) {
    return CustomButton(
      type: type,
      color: color,
      isSafe: isSafe,
      alignment: alignment,
      onPressed: onPressed,
      isEnabled: isEnabled,
      isLoading: isLoading,
      heightType: heightType,
      decoration: decoration,
      borderColor: borderColor,
      borderRadius: borderRadius,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      child: _iconValue(
        icon,
        type: type,
        iconColor: iconColor,
        heightType: heightType,
      ),
    );
  }

  factory CustomButton.child({
    Color? color,
    Color? borderColor,
    bool isSafe = false,
    Alignment? alignment,
    Function()? onPressed,
    required Widget child,
    bool isEnabled = true,
    bool isLoading = false,
    Decoration? decoration,
    Color? loadingPrimaryColor,
    BorderRadius? borderRadius,
    Color? loadingSecondaryColor,
    ButtonType type = ButtonType.primary,
    EdgeInsets? padding = EdgeInsets.zero,
    ButtonHeightType heightType = ButtonHeightType.medium,
  }) {
    return CustomButton(
      type: type,
      color: color,
      isSafe: isSafe,
      alignment: alignment,
      onPressed: onPressed,
      isEnabled: isEnabled,
      isLoading: isLoading,
      decoration: decoration,
      heightType: heightType,
      borderColor: borderColor,
      borderRadius: borderRadius,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      child: child,
    );
  }

  factory CustomButton.iconText({
    Color? color,
    Color? iconColor,
    Color? textColor,
    Color? borderColor,
    bool isSafe = false,
    EdgeInsets? padding,
    required String text,
    Alignment? alignment,
    TextStyle? textStyle,
    Function()? onPressed,
    bool isEnabled = true,
    required IconData icon,
    bool isLoading = false,
    Decoration? decoration,
    BorderRadius? borderRadius,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.medium,
  }) {
    return CustomButton(
      type: type,
      alignment: alignment,
      onPressed: onPressed,
      isEnabled: isEnabled,
      isLoading: isLoading,
      heightType: heightType,
      decoration: decoration,
      borderColor: borderColor,
      borderRadius: borderRadius,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      color: color,
      isSafe: isSafe,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      child: CustomTooltip(
        verticalOffset: switch (heightType) {
          ButtonHeightType.medium => Spacing.md.value,
          ButtonHeightType.normal => Spacing.nm.value,
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
            Flexible(
              child: _textValue(
                text,
                type: type,
                textStyle: textStyle,
                textColor: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  factory CustomButton.textIcon({
    Color? color,
    Color? iconColor,
    Color? textColor,
    Color? borderColor,
    bool isSafe = false,
    EdgeInsets? padding,
    Alignment? alignment,
    TextStyle? textStyle,
    required String text,
    bool isEnabled = true,
    Function()? onPressed,
    bool isLoading = false,
    required IconData icon,
    Decoration? decoration,
    BorderRadius? borderRadius,
    Color? loadingPrimaryColor,
    Color? loadingSecondaryColor,
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.medium,
  }) {
    return CustomButton(
      type: type,
      color: color,
      isSafe: isSafe,
      alignment: alignment,
      onPressed: onPressed,
      isEnabled: isEnabled,
      isLoading: isLoading,
      decoration: decoration,
      heightType: heightType,
      borderColor: borderColor,
      borderRadius: borderRadius,
      loadingPrimaryColor: loadingPrimaryColor,
      loadingSecondaryColor: loadingSecondaryColor,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Spacing.sm.value),
      child: CustomTooltip(
        verticalOffset: switch (heightType) {
          ButtonHeightType.medium => Spacing.md.value,
          ButtonHeightType.normal => Spacing.nm.value,
          ButtonHeightType.small => Spacing.sm.value,
        },
        message: text,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: _textValue(
                text,
                type: type,
                textStyle: textStyle,
                textColor: textColor,
              ),
            ),
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
    this.decoration,
    this.borderColor,
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
  final Color? borderColor;
  final EdgeInsets padding;
  final Alignment? alignment;
  final Function()? onPressed;
  final Decoration? decoration;
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
    ButtonHeightType heightType = ButtonHeightType.medium,
  }) {
    return Builder(
      builder: (context) {
        return Icon(
          iconData,
          size: switch (heightType) {
            ButtonHeightType.medium => AppFontSize.iconButton.value,
            ButtonHeightType.normal => AppFontSize.iconButton.value * .95,
            ButtonHeightType.small => AppFontSize.iconButton.value * .9,
          },
          color: iconColor ?? _color(context, type),
        );
      },
    );
  }

  static Color? _color(BuildContext context, ButtonType type) {
    if (context.isDarkMode) return context.colorScheme.onSurface;
    switch (type) {
      case ButtonType.background:
        return context.colorScheme.primary;
      case ButtonType.secondary:
        return context.colorScheme.onSecondary;
      case ButtonType.tertiary:
        return context.colorScheme.onTertiary;
      case ButtonType.primary:
        return context.colorScheme.onPrimary;
      default:
        return context.textTheme.bodyMedium?.color;
    }
  }

  static double _fontSize(ButtonHeightType heightType) {
    switch (heightType) {
      case ButtonHeightType.medium:
        return AppFontSize.bodyMedium.value;
      case ButtonHeightType.normal:
        return (AppFontSize.bodyMedium.value + AppFontSize.bodySmall.value) / 2;
      case ButtonHeightType.small:
        return AppFontSize.bodySmall.value;
    }
  }

  static Widget _textValue(
    String text, {
    Color? textColor,
    TextStyle? textStyle,
    ButtonType type = ButtonType.primary,
    ButtonHeightType heightType = ButtonHeightType.medium,
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
              style:
                  textStyle ??
                  context.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppFontWeight.semiBold.value,
                    fontSize: _fontSize(heightType),
                    color: textColor ?? _color(context, type),
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
      case ButtonHeightType.medium:
        return Size(AppThemeBase.buttonHeightMD, AppThemeBase.buttonHeightMD);
      case ButtonHeightType.normal:
        return Size(AppThemeBase.buttonHeightNM, AppThemeBase.buttonHeightNM);
      case ButtonHeightType.small:
        return Size(AppThemeBase.buttonHeightSM, AppThemeBase.buttonHeightSM);
    }
  }

  Color get _surfaceTintColor {
    switch (widget.type) {
      case ButtonType.primary:
        return context.colorScheme.surface.withValues(alpha: .1);
      case ButtonType.secondary:
        return context.colorScheme.onSecondary.withValues(alpha: .1);
      case ButtonType.background:
        return context.colorScheme.primary.withValues(alpha: .1);
      case ButtonType.tertiary:
        return context.colorScheme.onTertiary.withValues(alpha: .1);
      case ButtonType.noShape:
        return context.colorScheme.onSurface.withValues(alpha: .1);
    }
  }

  Color get _borderColor {
    if (widget.borderColor != null) return widget.borderColor!;

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
              return DecoratedBox(
                decoration: widget.decoration ?? BoxDecoration(),
                child: child ?? SizedBox(),
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
                  bottomLeft:
                      widget.isSafe
                          ? Radius.zero
                          : (widget.borderRadius ??
                                  context.theme.borderRadiusXLG)
                              .bottomLeft,
                  bottomRight:
                      widget.isSafe
                          ? Radius.zero
                          : (widget.borderRadius ??
                                  context.theme.borderRadiusXLG)
                              .bottomRight,
                ),
              ),
            ),
            side: WidgetStateProperty.all(
              BorderSide(color: _borderColor, width: .5),
            ),
            visualDensity: VisualDensity.compact,
            elevation: WidgetStateProperty.all(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: WidgetStateProperty.all(widget.padding),
            minimumSize: WidgetStateProperty.all(_minimumSize),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            backgroundColor: WidgetStateProperty.all(_backgroundColor),
            surfaceTintColor: WidgetStateProperty.all(_surfaceTintColor),
            overlayColor: WidgetStateProperty.all(_surfaceTintColor),
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
              child:
                  widget.alignment == null
                      ? _child
                      : Align(alignment: widget.alignment!, child: _child),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedSwitcher get _child {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child:
          widget.isLoading
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
        return context.colorScheme.surface;
      case ButtonType.noShape:
        return Colors.transparent;
      case ButtonType.tertiary:
        return context.colorScheme.tertiary;
    }
  }
}
