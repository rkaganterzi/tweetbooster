import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

extension BuildContextExtensions on BuildContext {
  // Localization
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // Theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // MediaQuery
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // Snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }
}

extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  int get hashtagCount {
    return RegExp(r'#\w+').allMatches(this).length;
  }

  int get mentionCount {
    return RegExp(r'@\w+').allMatches(this).length;
  }

  int get emojiCount {
    return RegExp(
      r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
      unicode: true,
    ).allMatches(this).length;
  }

  bool get hasQuestion {
    return contains('?');
  }

  bool get hasLink {
    return RegExp(r'https?://\S+').hasMatch(this);
  }
}

extension DoubleExtensions on double {
  String toPercentString({int decimals = 0}) {
    return '${toStringAsFixed(decimals)}%';
  }

  String toScoreString() {
    return toInt().toString();
  }
}

extension IntExtensions on int {
  String toCharacterCountString(int max) {
    return '$this/$max';
  }
}

extension DateTimeExtensions on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} yıl önce';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  String get formattedDate {
    return '$day/$month/$year';
  }

  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
