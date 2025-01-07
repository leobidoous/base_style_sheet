import 'package:flutter/material.dart';

import '../../../core/themes/spacing/spacing.dart';
import '../containers/custom_card.dart';
import '../containers/custom_shimmer.dart';

class ExpansionShimmer extends StatelessWidget {
  const ExpansionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.all(const Spacing(3).value),
      color: Colors.grey.withValues(alpha: .1),
      child: Row(
        children: [
          CustomShimmer(
            height: const Spacing(6).value,
            width: const Spacing(6).value,
          ),
          Spacing.sm.horizontal,
          Expanded(
            child: CustomShimmer(
              height: const Spacing(2.5).value,
            ),
          ),
          Spacing.sm.horizontal,
          CustomShimmer(
            height: const Spacing(3).value,
            width: const Spacing(3).value,
          ),
        ],
      ),
    );
  }
}
