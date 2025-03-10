import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../extensions/build_context_extensions.dart';
import 'custom_refresh_indicator.dart';

class CustomScrollContent extends StatelessWidget {
  const CustomScrollContent({
    super.key,
    this.physics,
    this.onRefresh,
    this.refreshLogo,
    required this.child,
    this.reverse = false,
    this.expanded = false,
    this.scrollController,
    this.alwaysScrollable = false,
    this.padding = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.scrollDirection = Axis.vertical,
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
  Widget build(BuildContext context) {
    Widget scroll = NotificationListener(
      onNotification: (notification) {
        return false;
      },
      child: SingleChildScrollView(
        physics: physics ??
            (alwaysScrollable ? const AlwaysScrollableScrollPhysics() : null),
        scrollDirection: scrollDirection,
        controller: scrollController,
        clipBehavior: clipBehavior,
        reverse: reverse,
        padding: padding,
        child: child,
      ),
    );

    if (expanded) {
      if (scrollDirection == Axis.vertical) {
        scroll = RawScrollbar(
          padding: EdgeInsets.zero,
          thickness: switch (defaultTargetPlatform) {
            TargetPlatform.android => null,
            TargetPlatform.iOS => null,
            TargetPlatform() => 0,
          },
          controller: scrollController,
          thumbColor: context.colorScheme.primary,
          radius: context.theme.borderRadiusXLG.bottomLeft,
          child: scroll,
        );
        if (onRefresh != null) {
          return CustomRefreshIndicator(
            refreshLogo: refreshLogo,
            onRefresh: onRefresh!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Expanded(child: scroll)],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: scroll)],
        );
      }
      return scroll;
    } else if (onRefresh != null) {
      return CustomRefreshIndicator(
        refreshLogo: refreshLogo,
        onRefresh: onRefresh!,
        child: scroll,
      );
    }
    return scroll;
  }
}
