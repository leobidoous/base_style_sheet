import 'package:custom_refresh_indicator/custom_refresh_indicator.dart' as cri;
import 'package:flutter/material.dart';

import '../../core/constants/style_sheet_assets.dart';
import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/typography/typography_constants.dart';
import '../extensions/build_context_extensions.dart';
import 'custom_loading.dart';
import 'image_view/custom_image.dart';

class CustomRefreshIndicator extends StatefulWidget {
  const CustomRefreshIndicator({
    super.key,
    this.logo = StyleSheetAssets.customRefreshIndicatorLogo,
    required this.child,
    required this.onRefresh,
  });
  final Widget child;
  final String? logo;
  final Future<void> Function() onRefresh;

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  final duration = const Duration(seconds: 1);
  late final Animation<double> animation;
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
      offsetToArmed: _offsetToArmed,
      onRefresh: widget.onRefresh,
      onStateChanged: (change) {
        switch (change.currentState) {
          case cri.IndicatorState.dragging:
            animationController.repeat();
            return;
          case cri.IndicatorState.complete:
            animationController.stop();
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
                      opacity: widget.logo != null ? animation : controller,
                      child: Center(
                        child: widget.logo != null
                            ? CustomImage(
                                svgAsset: widget.logo,
                                packageName: 'base_style_sheet',
                                border: context.theme.borderNone,
                                shaddow: const [],
                                backgroundColor: Colors.transparent,
                                imageSize: Size.fromHeight(_offsetToArmed * .4),
                              )
                            : CustomLoading(
                                height: AppFontSize.iconButton.value,
                                width: AppFontSize.iconButton.value,
                              ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
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
