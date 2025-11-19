import 'package:custom_refresh_indicator/custom_refresh_indicator.dart' as cri;
import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../extensions/build_context_extensions.dart';
import 'custom_loading.dart';
import 'image_view/custom_image.dart';

class CustomRefreshIndicator extends StatefulWidget {
  const CustomRefreshIndicator({
    super.key,
    this.refreshLogo,
    required this.child,
    this.reverse = false,
    required this.onRefresh,
  });
  final Widget child;
  final bool reverse;
  final String? refreshLogo;
  final Future<void> Function() onRefresh;

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final _duration = const Duration(seconds: 1);
  late final Animation<double> _animation;
  double get _offsetToArmed => 40;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _animation = Tween<double>(
      begin: 1,
      end: .25,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cri.CustomRefreshIndicator(
      autoRebuild: false,
      onRefresh: widget.onRefresh,
      offsetToArmed: _offsetToArmed,
      triggerMode: cri.IndicatorTriggerMode.anywhere,
      onStateChanged: (change) {
        switch (change.currentState) {
          case cri.IndicatorState.dragging:
            _animationController.repeat();
            return;
          case cri.IndicatorState.complete:
            _animationController.stop();
            return;
          default:
            break;
        }
      },
      builder: (context, child, controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Stack(
              alignment:
                  !widget.reverse
                      ? Alignment.topCenter
                      : Alignment.bottomCenter,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: _offsetToArmed),
                  child: SizeTransition(
                    axisAlignment: widget.reverse ? -1 : 1,
                    sizeFactor: controller,
                    child: FadeTransition(
                      opacity:
                          widget.refreshLogo != null ? _animation : controller,
                      child: Center(
                        child:
                            widget.refreshLogo != null
                                ? CustomImage(
                                  shaddow: const [],
                                  svgAsset: widget.refreshLogo,
                                  border: context.theme.borderNone,
                                  backgroundColor: Colors.transparent,
                                  borderRadius: context.theme.borderRadiusNone,
                                  imageSize: Size.fromHeight(
                                    _offsetToArmed * .4,
                                  ),
                                )
                                : CustomLoading(
                                  width: _offsetToArmed,
                                  height: _offsetToArmed,
                                ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  child: Transform.translate(
                    offset: Offset(
                      0.0,
                      widget.reverse
                          ? -(_offsetToArmed * controller.value)
                          : _offsetToArmed * controller.value,
                    ),
                    child: child,
                  ),
                ),
              ],
            );
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
