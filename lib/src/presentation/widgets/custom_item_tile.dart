import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../../core/themes/typography/typography_constants.dart';
import '../extensions/build_context_extensions.dart';
import 'containers/custom_card.dart';

class CustomItemTile extends StatelessWidget {
  const CustomItemTile({super.key, this.icon, required this.title, this.onTap});

  final String title;
  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.all(const Spacing(2).value),
      child: Row(
        children: [
          Icon(icon, size: AppFontSize.iconButton.value),
          Spacing.sm.horizontal,
          Expanded(
            child: Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontFamily: context.textTheme.primaryFontFamily,
                fontWeight: AppFontWeight.medium.value,
                color: Colors.grey,
              ),
            ),
          ),
          if (icon != null) ...[
            Spacing.sm.horizontal,
            Icon(
              Icons.chevron_right_rounded,
              size: AppFontSize.iconButton.value,
            ),
          ],
        ],
      ),
    );
  }
}
