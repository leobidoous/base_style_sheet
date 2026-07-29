import 'dart:async';

import 'package:flutter/material.dart';

import '../../../base_style_sheet.dart';

class InAppNotificationBanner {
  InAppNotificationBanner._();

  static OverlayEntry? _currentEntry;
  static Timer? _autoDismissTimer;

  /// Exibe um banner de notificação no topo da tela como overlay.
  ///
  /// [title] - Título da notificação.
  /// [body] - Corpo/descrição da notificação.
  /// [onTap] - Ação ao tocar no banner.
  /// [onDismiss] - Ação ao dispensar o banner.
  /// [actions] - Lista de widgets de ação (botões).
  /// [duration] - Duração antes do auto-dismiss (padrão: 5s).
  /// [icon] - Ícone à esquerda do banner.
  static void show(
    BuildContext context, {
    required String title,
    String? body,
    VoidCallback? onTap,
    List<Widget>? actions,
    VoidCallback? onDismiss,
    IconData icon = Icons.notifications_rounded,
    Duration duration = const Duration(seconds: 5),
  }) {
    dismiss();

    final navigatorState = Navigator.maybeOf(context, rootNavigator: true);
    final overlay = navigatorState?.overlay;
    if (overlay == null) return;

    _currentEntry = OverlayEntry(
      builder: (context) => _InAppNotificationBannerView(
        title: title,
        body: body,
        icon: icon,
        onTap: () {
          dismiss();
          onTap?.call();
        },
        onDismiss: () {
          dismiss();
          onDismiss?.call();
        },
        actions: actions,
      ),
    );

    overlay.insert(_currentEntry!);

    if (actions == null || actions.isEmpty) {
      _autoDismissTimer = Timer(duration, dismiss);
    }
  }

  /// Remove o banner atual.
  static void dismiss() {
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _InAppNotificationBannerView extends StatefulWidget {
  const _InAppNotificationBannerView({
    required this.title,
    required this.icon,
    this.body,
    this.onTap,
    this.onDismiss,
    this.actions,
  });

  final String title;
  final String? body;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final List<Widget>? actions;

  @override
  State<_InAppNotificationBannerView> createState() =>
      _InAppNotificationBannerViewState();
}

class _InAppNotificationBannerViewState
    extends State<_InAppNotificationBannerView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Durations.long2,
      reverseDuration: Durations.long2,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          onVerticalDragEnd: (details) {
            if ((details.primaryVelocity ?? 0) < 0) {
              _controller.reverse().then((onValue) {
                widget.onDismiss?.call();
              });
            }
          },
          child: Material(
            color: Colors.transparent,
            child: CustomCard(
              shaddow: [],
              padding: .all(Spacing.sm.value),
              color: context.textTheme.bodyMedium?.color,
              borderRadius: context.theme.borderRadiusNone,
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      spacing: Spacing.xxs.value,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            maxLines: 1,
                            widget.title,
                            overflow: .ellipsis,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: AppFontWeight.bold.value,
                              color: context.colorScheme.surface,
                            ),
                          ),
                        ),
                        if (widget.actions?.isEmpty == null)
                          CustomButton.icon(
                            type: .noShape,
                            heightType: .small,
                            icon: Icons.close_rounded,
                            onPressed: widget.onDismiss,
                            iconColor: context.colorScheme.surface,
                          ),
                      ],
                    ),
                    if (widget.body != null && widget.body!.isNotEmpty) ...[
                      Spacing.xxs.vertical,
                      AutoSizeText(
                        widget.body!,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.colorScheme.surface,
                        ),
                      ),
                    ],
                    if (widget.actions?.isNotEmpty == true) ...[
                      Spacing.xs.vertical,
                      Row(
                        spacing: Spacing.xs.value,
                        mainAxisAlignment: .end,
                        children: widget.actions!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
