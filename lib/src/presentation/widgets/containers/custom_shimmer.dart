import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/themes/app_theme_base.dart';
import '../../extensions/build_context_extensions.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade500,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: borderRadius ?? AppThemeBase.borderRadiusXSM,
        ),
        width: width,
        height: height,
      ),
    );
  }
}
