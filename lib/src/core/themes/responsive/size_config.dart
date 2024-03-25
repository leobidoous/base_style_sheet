import 'package:flutter/material.dart';

/// Class to initialize calculation for responsiveness
/// must be called when the app is started
class SizeConfig {
  SizeConfig._({
    required this.designScreenHeight,
    required this.designScreenWidth,
  });

  ///
  /// Initializes SizeConfig with correct design screen sizes.
  ///
  factory SizeConfig.init({
    required Size size,
    required BoxConstraints constraints,
    required Orientation orientation,
  }) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    if (orientation == Orientation.portrait) {
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      isPortrait = false;
      isMobilePortrait = false;
    }
    final config = SizeConfig._(
      designScreenHeight: size.height.round(),
      designScreenWidth: size.width.round(),
    );
    return config;
  }

  /// the value of [screen width] of design given by [designer]
  final int designScreenWidth;

  /// the value of [screen height] of design given by [designer]
  final int designScreenHeight;

  /// [width] of current device
  static late double _screenWidth;

  /// [height] of current device
  static late double _screenHeight;

  /// value to initialize [fontSize]
  static double textMultiplier = 1;

  /// value to initialize [image sizes]
  static double imageSizeMultiplier = 1;

  /// value to initialize [height] values
  static double heightMultiplier = 1;

  /// value to initialize [width] values
  static double widthMultiplier = 1;

  /// value to get information about [orientation]
  static bool isPortrait = true;

  /// value to get information about [portrait] in in [mobile] or [not]
  static bool isMobilePortrait = false;

  /// the method to initialize [SizeConfig] for responsive calculation
  void config(BoxConstraints constraints, Orientation orientation) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    if (orientation == Orientation.portrait) {
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      isPortrait = false;
      isMobilePortrait = false;
    }
    imageSizeMultiplier = heightMultiplier = _screenHeight / designScreenHeight;
    widthMultiplier = textMultiplier = _screenWidth / designScreenWidth;
  }
}
