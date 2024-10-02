import 'dart:async';

import 'package:flutter/material.dart'
    show
        AnimatedBuilder,
        Animation,
        AnimationController,
        BoxDecoration,
        BuildContext,
        Center,
        Colors,
        CurvedAnimation,
        Curves,
        EdgeInsets,
        FadeTransition,
        FilterQuality,
        Icon,
        Icons,
        ImageProvider,
        InkWell,
        Navigator,
        Offset,
        PageRouteBuilder,
        PreferredSize,
        Scaffold,
        Semantics,
        SingleTickerProviderStateMixin,
        Size,
        SizeTransition,
        SlideTransition,
        State,
        StatefulWidget,
        Tween,
        Widget;
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;
import 'package:photo_view/photo_view.dart';

import '../../../../core/themes/app_theme_factory.dart';
import '../../../../core/themes/spacing/spacing.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../custom_app_bar.dart';
import '../../errors/custom_request_error.dart';

class CustomPhotoView extends StatefulWidget {
  const CustomPhotoView({
    super.key,
    this.url,
    required this.image,
    this.actions = const [],
  });

  final String? url;
  final ImageProvider image;
  final List<Widget> actions;

  @override
  State<CustomPhotoView> createState() => _CustomPhotoViewState();

  Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const curve = Curves.decelerate;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return CustomPhotoView(
            actions: actions,
            image: image,
            url: url,
          );
        },
      ),
    );
  }
}

class _CustomPhotoViewState extends State<CustomPhotoView>
    with SingleTickerProviderStateMixin {
  late final Animation<double> animation;
  late final AnimationController controller;
  final photoController = PhotoViewController();
  final duration = const Duration(milliseconds: 250);
  final scaleStateController = PhotoViewScaleStateController();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);
    animation = Tween<double>(begin: 1, end: 0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    photoController.dispose();
    scaleStateController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          context.theme.appBarTheme.appBarHeight,
        ),
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, child) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                child: CustomAppBar(
                  actions: widget.actions,
                  leadingIcon: const Icon(Icons.close_rounded),
                ),
              ),
            );
          },
        ),
      ),
      body: Semantics(
        button: true,
        child: InkWell(
          onTap: () {
            if (controller.isDismissed) {
              controller.forward();
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
            } else {
              controller.reverse();
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            }
          },
          child: PhotoView(
            scaleStateController: scaleStateController,
            imageProvider: widget.image,
            backgroundDecoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
            ),
            controller: photoController,
            filterQuality: FilterQuality.high,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.contained * 5,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.image),
            errorBuilder: (_, error, stackTrace) {
              return Center(
                child: CustomRequestError(
                  message: stackTrace.toString(),
                  padding: EdgeInsets.symmetric(
                    horizontal: const Spacing(3).value,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
