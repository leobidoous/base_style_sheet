import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.height, this.color});

  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? Colors.grey.shade300,
      height: height != null ? height! * 2 : Spacing.md.value,
    );
  }
}
