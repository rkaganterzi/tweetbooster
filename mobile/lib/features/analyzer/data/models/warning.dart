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
    return Warning(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: _parseType(json['type'] as String?),
      severity: _parseSeverity(json['severity'] as String?),
      recommendation: json['recommendation'] as String?,
    );
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
        return WarningType.characterLimit;
      case 'hashtagOveruse':
        return WarningType.hashtagOveruse;
      case 'mentionOveruse':
        return WarningType.mentionOveruse;
      case 'emojiOveruse':
        return WarningType.emojiOveruse;
      case 'linkOveruse':
        return WarningType.linkOveruse;
      case 'tooShort':
        return WarningType.tooShort;
      case 'noEngagement':
        return WarningType.noEngagement;
      case 'spammy':
        return WarningType.spammy;
      case 'sensitive':
        return WarningType.sensitive;
      default:
        return WarningType.noEngagement;
    }
  }

  static WarningSeverity _parseSeverity(String? severity) {
    switch (severity) {
      case 'critical':
        return WarningSeverity.critical;
      case 'warning':
        return WarningSeverity.warning;
      case 'info':
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
