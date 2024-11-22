import 'package:flutter/material.dart';

import '../responsive/responsive_extension.dart';

enum AppFontWeight {
  bold(FontWeight.bold),
  semiBold(FontWeight.w600),
  medium(FontWeight.w500),
  normal(FontWeight.w400),
  light(FontWeight.w300);

  const AppFontWeight(this.value);
  final FontWeight value;
}

enum AppLineHeight {
  xs(0.5),
  sm(1),
  md(1.5),
  lg(2);

  const AppLineHeight(this.value);
  final double value;
}

enum AppFontSize {
  bodyLarge(16),
  bodyMedium(14),
  bodySmall(12),
  titleLarge(22),
  titleMedium(18),
  titleSmall(14),
  displayLarge(57),
  displayMedium(45),
  displaySmall(36),
  headlineLarge(32),
  headlineMedium(28),
  headlineSmall(24),
  labelLarge(14),
  labelMedium(12),
  labelSmall(10),
  iconButton(24);

  const AppFontSize(this._value);
  final int _value;
  double get value => _value.fontSize;
}
