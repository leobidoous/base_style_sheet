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
    required this.onRefresh,
  });
  final Widget child;
  final String? refreshLogo;
  final Future<void> Function() onRefresh;

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  final duration = const Duration(seconds: 1);
  late final Animation<double> animation;
  cri.IndicatorState? _indicatorState;
  double get _offsetToArmed => 40;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: duration);
    animation = Tween<double>(begin: 1, end: .25).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
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
            animationController.repeat();
            return;
          case cri.IndicatorState.complete:
            animationController.stop();
            return;
          case cri.IndicatorState.armed:
            _indicatorState = change.currentState;
            return;
          case cri.IndicatorState.settling:
            _indicatorState = change.currentState;
            return;
          default:
            break;
        }
      },
      builder: (context, child, controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: _offsetToArmed),
                  child: SizeTransition(
                    axisAlignment: 1,
                    sizeFactor: controller,
                    child: FadeTransition(
                      opacity:
                          widget.refreshLogo != null ? animation : controller,
                      child: Center(
                        child: widget.refreshLogo != null
                            ? CustomImage(
                                shaddow: const [],
                                svgAsset: widget.refreshLogo,
                                border: context.theme.borderNone,
                                backgroundColor: Colors.transparent,
                                imageSize: Size.fromHeight(_offsetToArmed * .4),
                              )
                            : CustomLoading(
                                height: _offsetToArmed,
                                width: _offsetToArmed,
                              ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  key: ObjectKey(_indicatorState),
                  offset: Offset(0.0, _offsetToArmed * controller.value),
                  child: child,
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
