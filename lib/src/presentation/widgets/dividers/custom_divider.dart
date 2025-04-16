import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.color,
    this.height,
    this.thickness,
    this.borderRadius,
  });

  final BorderRadius? borderRadius;
  final double? thickness;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height != null ? height! * 2 : Spacing.sm.value,
      color: color ?? Colors.grey.shade300,
      thickness: thickness,
    );
  }
}
