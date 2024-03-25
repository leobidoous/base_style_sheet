import 'package:flutter/material.dart';

import '../app_theme_base.dart';
import 'typography_constants.dart';
import 'typography_extension.dart';

///
/// Builder class to construct styles related to Typography.
///
abstract class TypographyBuilder {
  ///
  /// Creates the app default text styles, defined by our UX Team.
  ///
  static AppTextStyle buildAppTextStyle(ColorScheme base) {
    return AppTextStyle(
      bodyLarge: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.bodyLarge.value,
        fontWeight: AppFontWeight.normal.value,
        color: base.onBackground,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.bodyMedium.value,
        fontWeight: AppFontWeight.normal.value,
        color: base.onBackground,
      ),
      bodySmall: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.bodySmall.value,
        fontWeight: AppFontWeight.normal.value,
        color: base.onBackground,
      ),
      titleLarge: TextStyle(
        fontFamily: AppThemeBase.secodaryFontFamily,
        fontSize: AppFontSize.titleLarge.value,
        fontWeight: AppFontWeight.bold.value,
        color: base.onBackground,
      ),
      titleMedium: TextStyle(
        fontFamily: AppThemeBase.secodaryFontFamily,
        fontSize: AppFontSize.titleMedium.value,
        fontWeight: AppFontWeight.bold.value,
        color: base.onBackground,
      ),
      titleSmall: TextStyle(
        fontFamily: AppThemeBase.secodaryFontFamily,
        fontSize: AppFontSize.titleSmall.value,
        fontWeight: AppFontWeight.bold.value,
        color: base.onBackground,
      ),
      displayLarge: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.displayLarge.value,
        fontWeight: AppFontWeight.normal.value,
        color: base.onBackground,
      ),
      displayMedium: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.displayMedium.value,
        fontWeight: AppFontWeight.normal.value,
        color: base.onBackground,
      ),
      displaySmall: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.displaySmall.value,
        fontWeight: AppFontWeight.normal.value,
        color: base.onBackground,
      ),
      headlineLarge: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.headlineLarge.value,
        fontWeight: AppFontWeight.bold.value,
        color: base.onBackground,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.headlineMedium.value,
        fontWeight: AppFontWeight.normal.value,
        color: base.onBackground,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.headlineSmall.value,
        fontWeight: AppFontWeight.normal.value,
        color: base.onBackground,
      ),
      labelLarge: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.labelLarge.value,
        fontWeight: AppFontWeight.light.value,
        color: base.onBackground,
      ),
      labelMedium: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.labelMedium.value,
        fontWeight: AppFontWeight.light.value,
        color: base.onBackground,
      ),
      labelSmall: TextStyle(
        fontFamily: AppThemeBase.primaryFontFamily,
        fontSize: AppFontSize.labelSmall.value,
        fontWeight: AppFontWeight.light.value,
        color: base.onBackground,
      ),
    );
  }
}
