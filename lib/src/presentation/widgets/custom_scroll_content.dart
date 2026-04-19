import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../extensions/build_context_extensions.dart';
import 'custom_refresh_indicator.dart';

class CustomScrollContent extends StatefulWidget {
  const CustomScrollContent({
    super.key,
    required this.child,
    this.physics,
    this.onRefresh,
    this.refreshLogo,
    this.reverse = false,
    this.expanded = false,
    this.scrollController,
    this.padding = .zero,
    this.clipBehavior = .hardEdge,
    this.alwaysScrollable = false,
    this.scrollDirection = .vertical,
  });

  final Widget child;
  final bool reverse;
  final bool expanded;
  final Clip clipBehavior;
  final EdgeInsets padding;
  final String? refreshLogo;
  final Axis scrollDirection;
  final bool alwaysScrollable;
  final ScrollPhysics? physics;
  final Future<void> Function()? onRefresh;
  final ScrollController? scrollController;

  @override
  State<CustomScrollContent> createState() => _CustomScrollContentState();
}

class _CustomScrollContentState extends State<CustomScrollContent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget scroll = NotificationListener(
      onNotification: (notification) {
        return false;
      },
      child: SingleChildScrollView(
        physics:
            widget.physics ??
            (widget.alwaysScrollable
                ? const AlwaysScrollableScrollPhysics()
                : null),
        scrollDirection: widget.scrollDirection,
        clipBehavior: widget.clipBehavior,
        controller: _scrollController,
        reverse: widget.reverse,
        padding: widget.padding,
        child: widget.child,
      ),
    );

    if (widget.expanded) {
      if (widget.scrollDirection == .vertical) {
        scroll = RawScrollbar(
          padding: .zero,
          thickness: switch (defaultTargetPlatform) {
            .android => null,
            .iOS => null,
            _ => 0,
          },
          controller: _scrollController,
          thumbColor: context.colorScheme.primary,
          radius: context.theme.borderRadiusXLG.bottomLeft,
          child: scroll,
        );
        if (widget.onRefresh != null) {
          return CustomRefreshIndicator(
            refreshLogo: widget.refreshLogo,
            onRefresh: widget.onRefresh!,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [Expanded(child: scroll)],
            ),
          );
        }
        return Column(
          crossAxisAlignment: .stretch,
          children: [Expanded(child: scroll)],
        );
      }
      return scroll;
    } else if (widget.onRefresh != null) {
      return CustomRefreshIndicator(
        refreshLogo: widget.refreshLogo,
        onRefresh: widget.onRefresh!,
        child: scroll,
      );
    }
    return scroll;
  }
}
