import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../containers/custom_shimmer.dart';

class RowLabelValueShimmer extends StatelessWidget {
  const RowLabelValueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 4,
          child: LayoutBuilder(
            builder: (context, constrains) {
              final factor = Random().nextInt(10);
              return CustomShimmer(
                height: const Spacing(1.5).value,
                width: constrains.maxWidth * (factor < 3 ? .5 : factor / 10),
              );
            },
          ),
        ),
        Spacing.xs.horizontal,
        Flexible(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constrains) {
              final factor = Random().nextInt(10);
              return CustomShimmer(
                height: const Spacing(1.5).value,
                width: constrains.maxWidth * (factor < 3 ? .5 : factor / 10),
              );
            },
          ),
        ),
      ],
    );
  }
}
