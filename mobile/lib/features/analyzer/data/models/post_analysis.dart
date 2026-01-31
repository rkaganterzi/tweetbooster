import 'engagement_scores.dart';
import 'content_metrics.dart';
import 'suggestion.dart';
import 'warning.dart';

class PostAnalysis {
  final String content;
  final double overallScore;
  final EngagementScores engagementScores;
  final ContentMetrics metrics;
  final AlgorithmSignals signals;
  final List<Suggestion> suggestions;
  final List<Warning> warnings;
  final DateTime? analyzedAt;

  PostAnalysis({
    required this.content,
    required this.overallScore,
    required this.engagementScores,
    required this.metrics,
    required this.signals,
    required this.suggestions,
    required this.warnings,
    this.analyzedAt,
  });

  factory PostAnalysis.fromJson(Map<String, dynamic> json) {
    // Backend uses 'contentMetrics' and 'algorithmSignals'
    final metricsData = json['contentMetrics'] ?? json['metrics'] ?? {};
    final signalsData = json['algorithmSignals'] ?? json['signals'] ?? {};

    // Backend returns 0-1, UI expects 0-100
    final rawScore = (json['overallScore'] as num?)?.toDouble() ?? 0;
    final normalizedScore = rawScore <= 1 ? rawScore * 100 : rawScore;

    return PostAnalysis(
      content: json['content'] as String? ?? '',
      overallScore: normalizedScore,
      engagementScores: EngagementScores.fromJson(
        json['engagementScores'] as Map<String, dynamic>? ?? {},
      ),
      metrics: ContentMetrics.fromJson(
        metricsData as Map<String, dynamic>,
      ),
      signals: AlgorithmSignals.fromJson(
        signalsData as Map<String, dynamic>,
      ),
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => Suggestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => Warning.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      analyzedAt: json['analyzedAt'] != null
          ? DateTime.parse(json['analyzedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'overallScore': overallScore,
      'engagementScores': engagementScores.toJson(),
      'metrics': metrics.toJson(),
      'signals': signals.toJson(),
      'suggestions': suggestions.map((e) => e.toJson()).toList(),
      'warnings': warnings.map((e) => e.toJson()).toList(),
      'analyzedAt': analyzedAt?.toIso8601String(),
    };
  }

  String get scoreLabel {
    if (overallScore >= 80) return 'Mükemmel';
    if (overallScore >= 60) return 'İyi';
    if (overallScore >= 40) return 'Orta';
    return 'Düşük';
  }
}

class AlgorithmSignals {
  final bool hasQuestion;
  final bool hasCallToAction;
  final bool hasHashtags;
  final bool hasMentions;
  final bool hasMedia;
  final bool hasLinks;
  final bool hasEmojis;
  final bool isOptimalLength;
  final bool hasControversialTone;
  final bool hasValueProposition;

  AlgorithmSignals({
    this.hasQuestion = false,
    this.hasCallToAction = false,
    this.hasHashtags = false,
    this.hasMentions = false,
    this.hasMedia = false,
    this.hasLinks = false,
    this.hasEmojis = false,
    this.isOptimalLength = false,
    this.hasControversialTone = false,
    this.hasValueProposition = false,
  });

  factory AlgorithmSignals.fromJson(Map<String, dynamic> json) {
    // Backend returns positiveSignals/negativeSignals arrays
    final positiveSignals = (json['positiveSignals'] as List<dynamic>?) ?? [];
    final signalNames = positiveSignals
        .map((s) => (s as Map<String, dynamic>)['name'] as String?)
        .whereType<String>()
        .toSet();

    return AlgorithmSignals(
      hasQuestion: json['hasQuestion'] as bool? ?? signalNames.contains('has_question'),
      hasCallToAction: json['hasCallToAction'] as bool? ?? signalNames.contains('has_cta'),
      hasHashtags: json['hasHashtags'] as bool? ?? signalNames.contains('has_hashtags'),
      hasMentions: json['hasMentions'] as bool? ?? signalNames.contains('has_mentions'),
      hasMedia: json['hasMedia'] as bool? ?? signalNames.contains('has_media'),
      hasLinks: json['hasLinks'] as bool? ?? signalNames.contains('has_links'),
      hasEmojis: json['hasEmojis'] as bool? ?? signalNames.contains('has_emojis'),
      isOptimalLength: json['isOptimalLength'] as bool? ?? signalNames.contains('optimal_length'),
      hasControversialTone: json['hasControversialTone'] as bool? ?? signalNames.contains('controversial_tone'),
      hasValueProposition: json['hasValueProposition'] as bool? ?? signalNames.contains('value_proposition'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasQuestion': hasQuestion,
      'hasCallToAction': hasCallToAction,
      'hasHashtags': hasHashtags,
      'hasMentions': hasMentions,
      'hasMedia': hasMedia,
      'hasLinks': hasLinks,
      'hasEmojis': hasEmojis,
      'isOptimalLength': isOptimalLength,
      'hasControversialTone': hasControversialTone,
      'hasValueProposition': hasValueProposition,
    };
  }

  List<SignalItem> toList() {
    return [
      SignalItem('Soru', hasQuestion, 'hasQuestion'),
      SignalItem('CTA', hasCallToAction, 'hasCallToAction'),
      SignalItem('Hashtag', hasHashtags, 'hasHashtags'),
      SignalItem('Mention', hasMentions, 'hasMentions'),
      SignalItem('Medya', hasMedia, 'hasMedia'),
      SignalItem('Link', hasLinks, 'hasLinks'),
      SignalItem('Emoji', hasEmojis, 'hasEmojis'),
      SignalItem('Uzunluk', isOptimalLength, 'isOptimalLength'),
      SignalItem('Tartışmalı', hasControversialTone, 'hasControversialTone'),
      SignalItem('Değer', hasValueProposition, 'hasValueProposition'),
    ];
  }
}

class SignalItem {
  final String label;
  final bool isActive;
  final String key;

  SignalItem(this.label, this.isActive, this.key);
}
