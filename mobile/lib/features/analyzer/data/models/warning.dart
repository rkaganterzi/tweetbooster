enum WarningType {
  characterLimit,
  hashtagOveruse,
  mentionOveruse,
  emojiOveruse,
  linkOveruse,
  tooShort,
  noEngagement,
  spammy,
  sensitive,
}

enum WarningSeverity {
  critical,
  warning,
  info,
}

class Warning {
  final String id;
  final String title;
  final String description;
  final WarningType type;
  final WarningSeverity severity;
  final String? recommendation;

  Warning({
    required this.id,
    required this.title,
    required this.description,
    this.type = WarningType.noEngagement,
    this.severity = WarningSeverity.warning,
    this.recommendation,
  });

  factory Warning.fromJson(Map<String, dynamic> json) {
    // Backend returns: type, severity, message, scoreImpact
    final typeStr = json['type'] as String? ?? '';
    return Warning(
      id: json['id'] as String? ?? typeStr,
      title: json['title'] as String? ?? _getWarningTitle(typeStr),
      description: json['description'] as String? ?? json['message'] as String? ?? '',
      type: _parseType(typeStr),
      severity: _parseSeverity(json['severity'] as String?),
      recommendation: json['recommendation'] as String?,
    );
  }

  static String _getWarningTitle(String type) {
    switch (type) {
      case 'too_short':
        return 'Çok Kısa';
      case 'too_long':
        return 'Çok Uzun';
      case 'too_many_hashtags':
        return 'Fazla Hashtag';
      case 'too_many_mentions':
        return 'Fazla Mention';
      case 'all_caps':
        return 'Tümü Büyük Harf';
      case 'link_only':
        return 'Sadece Link';
      case 'spam_pattern':
        return 'Spam Riski';
      default:
        return 'Uyarı';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'severity': severity.name,
      'recommendation': recommendation,
    };
  }

  static WarningType _parseType(String? type) {
    switch (type) {
      case 'characterLimit':
      case 'too_long':
        return WarningType.characterLimit;
      case 'hashtagOveruse':
      case 'too_many_hashtags':
        return WarningType.hashtagOveruse;
      case 'mentionOveruse':
      case 'too_many_mentions':
        return WarningType.mentionOveruse;
      case 'emojiOveruse':
      case 'too_many_emojis':
        return WarningType.emojiOveruse;
      case 'linkOveruse':
      case 'too_many_links':
      case 'link_only':
        return WarningType.linkOveruse;
      case 'tooShort':
      case 'too_short':
      case 'suboptimal_length':
        return WarningType.tooShort;
      case 'noEngagement':
      case 'low_engagement_pattern':
        return WarningType.noEngagement;
      case 'spammy':
      case 'spam_pattern':
      case 'follow_for_follow':
        return WarningType.spammy;
      case 'sensitive':
      case 'all_caps':
      case 'negative_sentiment':
        return WarningType.sensitive;
      default:
        return WarningType.noEngagement;
    }
  }

  static WarningSeverity _parseSeverity(String? severity) {
    switch (severity) {
      case 'critical':
      case 'high':
        return WarningSeverity.critical;
      case 'warning':
      case 'medium':
        return WarningSeverity.warning;
      case 'info':
      case 'low':
        return WarningSeverity.info;
      default:
        return WarningSeverity.warning;
    }
  }

  String get typeLabel {
    switch (type) {
      case WarningType.characterLimit:
        return 'Karakter Limiti';
      case WarningType.hashtagOveruse:
        return 'Fazla Hashtag';
      case WarningType.mentionOveruse:
        return 'Fazla Mention';
      case WarningType.emojiOveruse:
        return 'Fazla Emoji';
      case WarningType.linkOveruse:
        return 'Fazla Link';
      case WarningType.tooShort:
        return 'Çok Kısa';
      case WarningType.noEngagement:
        return 'Düşük Etkileşim';
      case WarningType.spammy:
        return 'Spam Riski';
      case WarningType.sensitive:
        return 'Hassas İçerik';
    }
  }
}
