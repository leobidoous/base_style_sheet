import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../core/themes/app_theme_base.dart';
import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/typography/typography_constants.dart';
import '../extensions/build_context_extensions.dart';
import 'buttons/custom_button.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  factory CustomAppBar.zero({
    bool enableShadow = false,
    Color? backgroundColor,
    final EdgeInsets? linearProgressPadding,
  }) {
    return CustomAppBar(
      toolbarHeight: 0,
      enableShadow: enableShadow,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      linearProgressPadding: linearProgressPadding,
    );
  }
  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.progress,
    this.onBackTap,
    this.titleColor,
    this.titleWidget,
    this.leadingIcon,
    this.titleSpacing,
    this.leadingWidth,
    this.toolbarHeight,
    this.backgroundColor,
    this.centerTitle = true,
    this.enableShadow = true,
    this.linearProgressPadding,
    this.scrolledUnderElevation,
    this.titlePadding = .zero,
    this.automaticallyImplyLeading = true,
  });

  final String? title;
  final double? progress;
  final bool centerTitle;
  final Color? titleColor;
  final bool enableShadow;
  final Widget? titleWidget;
  final Widget? leadingIcon;
  final double? titleSpacing;
  final double? leadingWidth;
  final List<Widget>? actions;
  final double? toolbarHeight;
  final Color? backgroundColor;
  final VoidCallback? onBackTap;
  final EdgeInsets titlePadding;
  final double? scrolledUnderElevation;
  final bool automaticallyImplyLeading;
  final EdgeInsets? linearProgressPadding;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize =>
      Size(double.infinity, toolbarHeight ?? AppThemeBase.appBarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Duration _duration = Durations.long1;
  late Animation<double> _progressAnimation;
  late Animation<double> _heightAnimation;
  double _currentProgress = 0;
  double _currentHeight = 0;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.toolbarHeight ?? widget.preferredSize.height;
    _animationController = AnimationController(
      reverseDuration: _duration,
      duration: _duration,
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: widget.progress ?? 0)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    _heightAnimation =
        Tween<double>(
          begin: _currentHeight,
          end: widget.toolbarHeight ?? 0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    if (widget.progress != null || widget.toolbarHeight != null) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation =
          Tween<double>(
            begin: _currentProgress,
            end: widget.progress ?? 0,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );
      _currentProgress = widget.progress ?? 0;
      _animationController.reset();
      _animationController.forward();
    }

    if (oldWidget.toolbarHeight != widget.toolbarHeight) {
      _heightAnimation =
          Tween<double>(
            begin: _currentHeight,
            end: widget.toolbarHeight ?? widget.preferredSize.height,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );
      _currentHeight = widget.toolbarHeight ?? widget.preferredSize.height;
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Flexible(
          child: AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: widget.enableShadow
                      ? Border(
                          bottom: BorderSide(
                            width: .1,
                            color: context.colorScheme.onSurface.withValues(
                              alpha: .1,
                            ),
                          ),
                        )
                      : null,
                  boxShadow: widget.enableShadow
                      ? [context.theme.shadowLightmodeLevel1]
                      : null,
                ),
                child: AnimatedSize(
                  duration: _duration,
                  curve: Curves.easeInOut,
                  reverseDuration: _duration,
                  child: SizedBox(
                    height: widget.toolbarHeight == null
                        ? null
                        : _heightAnimation.value,
                    child: _appBar,
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.progress != null)
          Padding(
            padding: widget.linearProgressPadding ?? .zero,
            child: ClipRRect(
              borderRadius: context.theme.borderRadiusXLG,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    borderRadius: context.theme.borderRadiusMD,
                    backgroundColor: Colors.grey.shade300,
                    color: context.colorScheme.primary,
                    value: _progressAnimation.value,
                    minHeight: 2,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget get _appBar {
    return AppBar(
      elevation: 0,
      actions: widget.actions,
      centerTitle: widget.centerTitle,
      titleSpacing: widget.titleSpacing,
      shadowColor: Colors.transparent,
      toolbarHeight: widget.toolbarHeight,
      foregroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: widget.scrolledUnderElevation ?? 0,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      backgroundColor: widget.backgroundColor ?? context.colorScheme.surface,
      shape: widget.enableShadow
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.colorScheme.onSurface.withValues(alpha: .1),
                width: .1,
              ),
            )
          : null,
      title: Padding(
        padding: widget.titlePadding,
        child:
            widget.titleWidget ??
            AutoSizeText(
              widget.title ?? '',
              maxLines: 1,
              overflow: .ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                fontFamily: context.textTheme.secodaryFontFamily,
                fontWeight: context.textTheme.fontWeightMedium,
                color: widget.titleColor,
              ),
            ),
      ),
      leadingWidth:
          widget.leadingWidth ??
          (widget.automaticallyImplyLeading && Navigator.of(context).canPop() ||
                  widget.leadingIcon != null ||
                  widget.onBackTap != null
              ? null
              : 0),
      leading:
          widget.automaticallyImplyLeading && Navigator.of(context).canPop() ||
              widget.leadingIcon != null ||
              widget.onBackTap != null
          ? Align(
              child: CustomButton.child(
                type: .noShape,
                padding: .zero,
                heightType: .small,
                onPressed:
                    widget.onBackTap ??
                    () {
                      setState(() {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                child:
                    widget.leadingIcon ??
                    Icon(
                      Icons.chevron_left_rounded,
                      size: AppFontSize.iconButton.value,
                    ),
              ),
            )
          : const SizedBox(),
    );
  }
}
