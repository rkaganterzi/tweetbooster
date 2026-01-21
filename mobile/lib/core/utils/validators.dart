import '../constants/algorithm_weights.dart';

class Validators {
  Validators._();

  static String? validatePost(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Post içeriği boş olamaz';
    }
    if (value.length > AlgorithmWeights.maxLength) {
      return 'Post ${AlgorithmWeights.maxLength} karakterden uzun olamaz';
    }
    return null;
  }

  static String? validateTopic(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Konu boş olamaz';
    }
    if (value.length < 3) {
      return 'Konu en az 3 karakter olmalı';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName boş olamaz';
    }
    return null;
  }

  static bool isWithinCharacterLimit(String text) {
    return text.length <= AlgorithmWeights.maxLength;
  }

  static bool isOptimalLength(String text) {
    return text.length >= AlgorithmWeights.optimalLengthMin &&
        text.length <= AlgorithmWeights.optimalLengthMax;
  }

  static bool hasExcessiveHashtags(String text) {
    final count = RegExp(r'#\w+').allMatches(text).length;
    return count > AlgorithmWeights.maxHashtags;
  }

  static bool hasExcessiveMentions(String text) {
    final count = RegExp(r'@\w+').allMatches(text).length;
    return count > AlgorithmWeights.maxMentions;
  }

  static bool hasExcessiveEmojis(String text) {
    final count = RegExp(
      r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
      unicode: true,
    ).allMatches(text).length;
    return count > AlgorithmWeights.maxEmojis;
  }
}
