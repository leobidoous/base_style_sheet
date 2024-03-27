import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../containers/custom_shimmer.dart';

class ColumnLabelValueShimmer extends StatelessWidget {
  const ColumnLabelValueShimmer({
    super.key,
    this.nLabelLines = 1,
    this.nValueLines = 1,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final int nLabelLines;
  final int nValueLines;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemCount: nLabelLines,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => Spacing.xxs.vertical,
              itemBuilder: (_, index) {
                final factor = Random().nextInt(10);
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: index == nLabelLines - 1 ? 0 : Spacing.xxs.value,
                    ),
                    child: CustomShimmer(
                      height: AppFontSize.bodyMedium.value,
                      width: index == nLabelLines - 1
                          ? constrains.maxWidth *
                              (factor < 3 ? .5 : factor / 10)
                          : double.infinity,
                    ),
                  ),
                );
              },
            ),
            Spacing.sm.vertical,
            ListView.separated(
              shrinkWrap: true,
              itemCount: nValueLines,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => Spacing.xxs.vertical,
              itemBuilder: (_, index) {
                final factor = Random().nextInt(10);
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: index == nValueLines - 1 ? 0 : Spacing.xxs.value,
                    ),
                    child: CustomShimmer(
                      height: AppFontSize.bodyMedium.value,
                      width: index == nValueLines - 1
                          ? constrains.maxWidth *
                              (factor < 3 ? .5 : factor / 10)
                          : double.infinity,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
