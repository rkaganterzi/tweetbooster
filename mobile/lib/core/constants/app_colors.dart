import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const primary = Color(0xFF1D9BF0);
  static const primaryDark = Color(0xFF1A8CD8);

  // Background
  static const background = Color(0xFF000000);
  static const surface = Color(0xFF16181C);
  static const surfaceLight = Color(0xFF1D1F23);

  // Text
  static const textPrimary = Color(0xFFE7E9EA);
  static const textSecondary = Color(0xFF71767B);
  static const textMuted = Color(0xFF536471);

  // Border
  static const border = Color(0xFF2F3336);
  static const borderLight = Color(0xFF38444D);

  // Semantic
  static const success = Color(0xFF00BA7C);
  static const warning = Color(0xFFFFD400);
  static const error = Color(0xFFF4212E);
  static const info = Color(0xFF1D9BF0);

  // Score colors
  static const scoreExcellent = Color(0xFF00BA7C);
  static const scoreGood = Color(0xFF1D9BF0);
  static const scoreMedium = Color(0xFFFFD400);
  static const scoreLow = Color(0xFFF4212E);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF1D9BF0), Color(0xFF1A8CD8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const scoreGradient = LinearGradient(
    colors: [Color(0xFFF4212E), Color(0xFFFFD400), Color(0xFF1D9BF0), Color(0xFF00BA7C)],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  static Color getScoreColor(double score) {
    if (score >= 80) return scoreExcellent;
    if (score >= 60) return scoreGood;
    if (score >= 40) return scoreMedium;
    return scoreLow;
  }
}
