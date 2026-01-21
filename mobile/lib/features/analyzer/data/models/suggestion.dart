enum SuggestionType {
  content,
  engagement,
  timing,
  format,
  hashtag,
  mention,
  media,
  length,
  callToAction,
  question,
}

enum SuggestionPriority {
  high,
  medium,
  low,
}

class Suggestion {
  final String id;
  final String title;
  final String description;
  final SuggestionType type;
  final SuggestionPriority priority;
  final double? impactScore;
  final String? example;

  Suggestion({
    required this.id,
    required this.title,
    required this.description,
    this.type = SuggestionType.content,
    this.priority = SuggestionPriority.medium,
    this.impactScore,
    this.example,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: _parseType(json['type'] as String?),
      priority: _parsePriority(json['priority'] as String?),
      impactScore: (json['impactScore'] as num?)?.toDouble(),
      example: json['example'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'priority': priority.name,
      'impactScore': impactScore,
      'example': example,
    };
  }

  static SuggestionType _parseType(String? type) {
    switch (type) {
      case 'content':
        return SuggestionType.content;
      case 'engagement':
        return SuggestionType.engagement;
      case 'timing':
        return SuggestionType.timing;
      case 'format':
        return SuggestionType.format;
      case 'hashtag':
        return SuggestionType.hashtag;
      case 'mention':
        return SuggestionType.mention;
      case 'media':
        return SuggestionType.media;
      case 'length':
        return SuggestionType.length;
      case 'callToAction':
        return SuggestionType.callToAction;
      case 'question':
        return SuggestionType.question;
      default:
        return SuggestionType.content;
    }
  }

  static SuggestionPriority _parsePriority(String? priority) {
    switch (priority) {
      case 'high':
        return SuggestionPriority.high;
      case 'medium':
        return SuggestionPriority.medium;
      case 'low':
        return SuggestionPriority.low;
      default:
        return SuggestionPriority.medium;
    }
  }

  String get typeLabel {
    switch (type) {
      case SuggestionType.content:
        return 'İçerik';
      case SuggestionType.engagement:
        return 'Etkileşim';
      case SuggestionType.timing:
        return 'Zamanlama';
      case SuggestionType.format:
        return 'Format';
      case SuggestionType.hashtag:
        return 'Hashtag';
      case SuggestionType.mention:
        return 'Mention';
      case SuggestionType.media:
        return 'Medya';
      case SuggestionType.length:
        return 'Uzunluk';
      case SuggestionType.callToAction:
        return 'CTA';
      case SuggestionType.question:
        return 'Soru';
    }
  }
}
