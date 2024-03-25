import 'package:flutter/material.dart';

///
/// Extensions for [BuildContext] class
///
extension BuildContextExt on BuildContext {
  ///
  /// Get [MediaQueryData] from current context
  ///
  MediaQueryData get mediaQuery {
    return MediaQuery.of(this);
  }

  ///
  /// Get [MediaQueryData] from current context
  ///
  Size get kSize {
    return MediaQuery.of(this).size;
  }

  ///
  /// Get current screen width, based on current context
  ///
  double get screenWidth {
    return mediaQuery.size.width;
  }

  ///
  /// Get current screen height, based on current context
  ///
  double get screenHeight {
    return mediaQuery.size.height;
  }

  ///
  /// Get a fraction of the total available width.
  /// [widthFactor] must be greater than 0.0.
  ///
  double fractionallyScreenWidth(double widthFactor) {
    assert(widthFactor > 0.0);

    return screenWidth * widthFactor;
  }

  ///
  /// Get a fraction of the total available height.
  /// [heightFactor] must be greater than 0.0.
  ///
  double fractionallyScreenHeight(double heightFactor) {
    assert(heightFactor > 0.0);

    return screenHeight * heightFactor;
  }

  ///
  /// App default text styles defined by our UX Team.
  ///
  /// Each style has four variations: normal, light, medium and bold,
  /// accordingly to it's FontWeight.
  ///
  /// Other modifications can be done using `copyWith` method.
  ///
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness != Brightness.light;
}
