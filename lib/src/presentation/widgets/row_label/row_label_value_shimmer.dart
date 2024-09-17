import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../containers/custom_shimmer.dart';

class RowLabelValueShimmer extends StatelessWidget {
  const RowLabelValueShimmer({super.key});

  Random get _random => Random();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final factor1 = _random.nextInt(4);
      final factor2 = _random.nextInt(6);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: CustomShimmer(
              height: const Spacing(1.5).value,
              width: constrains.maxWidth * (factor1 < 3 ? .5 : factor1 / 10),
            ),
          ),
          Spacing.xs.horizontal,
          Flexible(
            flex: 6,
            child: CustomShimmer(
              height: const Spacing(1.5).value,
              width: constrains.maxWidth * (factor2 < 3 ? .5 : factor2 / 10),
            ),
          ),
        ],
      );
    });
  }
}
