import 'package:flutter/material.dart';

import 'app_theme_base.dart';
import 'typography/typography_constants.dart';

extension ThemeModeExtension on ThemeMode {
  ThemeMode fromJson(String? mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return this;
    }
  }
}

extension TextThemeExtension on TextTheme {
  ///Family: Poppins
  String get primaryFontFamily => AppThemeBase.primaryFontFamily;

  ///Family: Inter
  String get secodaryFontFamily => AppThemeBase.secodaryFontFamily;
  FontWeight get fontWeightBold => AppFontWeight.bold.value;
  FontWeight get fontWeightSemiBold => AppFontWeight.semiBold.value;
  FontWeight get fontWeightMedium => AppFontWeight.medium.value;
  FontWeight get fontWeightRegular => AppFontWeight.normal.value;
  FontWeight get fontWeightLight => AppFontWeight.light.value;
  double get lineHeightTight => AppThemeBase.lineHeightTight;
  double get lineHeightRegular => AppThemeBase.lineHeightRegular;
  double get lineHeightMedium => AppThemeBase.lineHeightMedium;
  double get lineHeightDistant => AppThemeBase.lineHeightDistant;
  double get lineHeightSuperDistant => AppThemeBase.lineHeightSuperDistant;
}

extension ThemeDataExtension on ThemeData {
  BorderRadius get borderRadiusNone => AppThemeBase.borderRadiusNone;
  BorderRadius get borderRadiusXSM => AppThemeBase.borderRadiusXSM;
  BorderRadius get borderRadiusSM => AppThemeBase.borderRadiusSM;
  BorderRadius get borderRadiusNM => AppThemeBase.borderRadiusNM;
  BorderRadius get borderRadiusMD => AppThemeBase.borderRadiusMD;
  BorderRadius get borderRadiusLG => AppThemeBase.borderRadiusLG;
  BorderRadius get borderRadiusXLG => AppThemeBase.borderRadiusXLG;

  double get borderWidthSM => AppThemeBase.borderWidthSM;
  double get borderWidthXS => AppThemeBase.borderWidthXS;
  double get opacityLevelSemiopaque => AppThemeBase.opacityLevelSemiopaque;
  double get opacityLevelIntense => AppThemeBase.opacityLevelIntense;
  double get opacityLevelMedium => AppThemeBase.opacityLevelMedium;
  double get opacityLevelLight => AppThemeBase.opacityLevelLight;
  double get opacityLevelSemiTransparent =>
      AppThemeBase.opacityLevelSemiTransparent;

  BoxShadow get shadowLightmodeLevel0 => AppThemeBase.shadowLightmodeLevel0;
  BoxShadow get shadowLightmodeLevel1 => AppThemeBase.shadowLightmodeLevel1;
  BoxShadow get shadowLightmodeLevel2 => AppThemeBase.shadowLightmodeLevel2;
  BoxShadow get shadowLightmodeLevel3 => AppThemeBase.shadowLightmodeLevel3;
  BoxShadow get shadowLightmodeLevel4 => AppThemeBase.shadowLightmodeLevel4;
  BoxShadow get shadowLightmodeLevel5 => AppThemeBase.shadowLightmodeLevel5;

  double get customRadioCircleSize => AppThemeBase.customRadioCircleSize;
  double get disclaimerIconSize => AppThemeBase.disclaimerIconSize;

  Border get borderNone => Border.all(width: 0, color: Colors.transparent);

  Color get infoBoxBackground => AppThemeBase.infoBoxBackground;
  Color get infoBoxIcon => AppThemeBase.infoBoxIcon;
  Color get infoBoxText => AppThemeBase.infoBoxText;
  Color get reviewItemLabel => AppThemeBase.reviewItemLabel;
}

extension InputDecorationThemeExtension on InputDecorationTheme {
  TextStyle? get floatingLabelStyle => labelStyle?.copyWith(
    height: AppThemeBase.lineHeightTight,
    fontWeight: AppFontWeight.bold.value,
  );
}

extension ElevatedButtonThemeDataExtension on ElevatedButtonThemeData {
  double get heightDefault => AppThemeBase.buttonHeight;
  double get heightSmall => AppThemeBase.buttonHeightSM;
  double get heightMedium => AppThemeBase.buttonHeightMD;
  double get heightLarge => AppThemeBase.buttonHeightLG;
}

extension AppBarThemeDataExtension on AppBarThemeData {
  double get appBarHeight => AppThemeBase.appBarHeight;
}

class AppThemeFactory {
  AppThemeFactory._();
  static final AppThemeFactory _instance = AppThemeFactory._();
  static AppThemeFactory get instance => _instance;

  ThemeData? _currentLightTheme;
  ThemeData get currentLightTheme => _currentLightTheme!;

  set currentLightTheme(ThemeData value) {
    _currentLightTheme = value;
  }

  ThemeData? _currentDarkTheme;
  ThemeData get currentDarkTheme => _currentDarkTheme!;

  set currentDarkTheme(ThemeData value) {
    _currentDarkTheme = value;
  }
}
