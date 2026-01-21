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
    // Backend returns: type, priority, message, action, potentialScoreIncrease
    final typeStr = json['type'] as String? ?? '';
    final message = json['message'] as String? ?? '';
    final action = json['action'] as String? ?? '';

    return Suggestion(
      id: json['id'] as String? ?? typeStr,
      title: json['title'] as String? ?? _translateMessage(typeStr, message),
      description: json['description'] as String? ?? _translateAction(typeStr, action),
      type: _parseType(typeStr),
      priority: _parsePriority(json['priority'] as String?),
      impactScore: (json['impactScore'] as num?)?.toDouble() ??
                   (json['potentialScoreIncrease'] as num?)?.toDouble(),
      example: json['example'] as String?,
    );
  }

  static String _translateMessage(String type, String fallback) {
    final translations = {
      'increase_length': 'Post çok kısa. 80-280 karakter hedefleyin.',
      'reduce_length': 'Post çok uzun. Kısaltmayı veya thread yapmayı düşünün.',
      'add_question': 'Etkileşimi artırmak için soru ekleyin.',
      'add_cta': 'Eylem çağrısı (CTA) ekleyin.',
      'add_media': 'Görsel veya video eklemek etkileşimi artırabilir.',
      'add_hook': 'Dikkat çekici bir giriş ekleyin.',
      'add_value': 'Değer odaklı içerik ekleyin.',
      'remove_hashtags': 'Hashtag sayısını azaltın (max 2).',
      'fix_formatting': 'Formatı düzeltin.',
      'add_controversy': 'Daha güçlü bir görüş alıntıları artırabilir.',
    };
    return translations[type] ?? fallback;
  }

  static String _translateAction(String type, String fallback) {
    final translations = {
      'increase_length': 'Daha fazla bağlam, örnek veya hook ekleyin.',
      'reduce_length': 'Thread formatına geçmeyi düşünün.',
      'add_question': 'Açık uçlu bir soru ile bitirin.',
      'add_cta': 'Beğeni, retweet veya yorum isteyin.',
      'add_media': 'İlgili görsel içerik ekleyin.',
      'add_hook': '"İşte...", "Durma...", veya cesur bir açıklama ile başlayın.',
      'add_value': '"Öğrendiğim şey...", "X ipucu..." gibi ifadeler kullanın.',
      'remove_hashtags': '2 veya daha az hashtag kullanın.',
      'fix_formatting': 'Cümle yapısını düzeltin.',
      'add_controversy': 'Tartışmaya açık bir görüş belirtin.',
    };
    return translations[type] ?? fallback;
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
      case 'add_value':
      case 'add_hook':
        return SuggestionType.content;
      case 'engagement':
        return SuggestionType.engagement;
      case 'timing':
        return SuggestionType.timing;
      case 'format':
      case 'fix_formatting':
        return SuggestionType.format;
      case 'hashtag':
      case 'remove_hashtags':
        return SuggestionType.hashtag;
      case 'mention':
        return SuggestionType.mention;
      case 'media':
      case 'add_media':
        return SuggestionType.media;
      case 'length':
      case 'increase_length':
      case 'reduce_length':
        return SuggestionType.length;
      case 'callToAction':
      case 'add_cta':
        return SuggestionType.callToAction;
      case 'question':
      case 'add_question':
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
