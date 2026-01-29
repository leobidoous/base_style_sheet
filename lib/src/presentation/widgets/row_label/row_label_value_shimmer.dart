import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../containers/custom_shimmer.dart';

class RowLabelValueShimmer extends StatefulWidget {
  const RowLabelValueShimmer({super.key});

  @override
  State<RowLabelValueShimmer> createState() => _RowLabelValueShimmerState();
}

class _RowLabelValueShimmerState extends State<RowLabelValueShimmer> {
  final _random = Random();

  int get factor1 => _random.nextInt(4);
  int get factor2 => _random.nextInt(6);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: CustomShimmer(
                height: AppFontSize.bodyMedium.value,
                width: constrains.maxWidth * (factor1 < 3 ? .5 : factor1 / 10),
              ),
            ),
            Spacing.xs.horizontal,
            Flexible(
              flex: 6,
              child: CustomShimmer(
                height: AppFontSize.bodyMedium.value,
                width: constrains.maxWidth * (factor2 < 3 ? .5 : factor2 / 10),
              ),
            ),
          ],
        );
      },
    );
  }
}
