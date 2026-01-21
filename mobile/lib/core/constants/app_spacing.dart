import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Base spacing unit
  static const double unit = 4.0;

  // Spacing values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Padding
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);

  // Border radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));

  // Common gaps
  static const SizedBox verticalGapXs = SizedBox(height: xs);
  static const SizedBox verticalGapSm = SizedBox(height: sm);
  static const SizedBox verticalGapMd = SizedBox(height: md);
  static const SizedBox verticalGapLg = SizedBox(height: lg);
  static const SizedBox verticalGapXl = SizedBox(height: xl);

  static const SizedBox horizontalGapXs = SizedBox(width: xs);
  static const SizedBox horizontalGapSm = SizedBox(width: sm);
  static const SizedBox horizontalGapMd = SizedBox(width: md);
  static const SizedBox horizontalGapLg = SizedBox(width: lg);
}
