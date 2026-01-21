import 'generated_post.dart';

class GenerationRequest {
  final String topic;
  final PostStyle style;
  final EngagementTarget? targetEngagement;
  final GenerationConstraints constraints;

  GenerationRequest({
    required this.topic,
    required this.style,
    this.targetEngagement,
    GenerationConstraints? constraints,
  }) : constraints = constraints ?? GenerationConstraints();

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'style': style.value,
      'targetEngagement': targetEngagement?.value,
      'constraints': constraints.toJson(),
    };
  }
}

enum EngagementTarget {
  likes,
  replies,
  retweets,
  bookmarks,
  viral,
}

extension EngagementTargetExtension on EngagementTarget {
  String get label {
    switch (this) {
      case EngagementTarget.likes:
        return 'Beğeni';
      case EngagementTarget.replies:
        return 'Yanıt';
      case EngagementTarget.retweets:
        return 'Retweet';
      case EngagementTarget.bookmarks:
        return 'Kaydet';
      case EngagementTarget.viral:
        return 'Viral';
    }
  }

  String get labelEn {
    switch (this) {
      case EngagementTarget.likes:
        return 'Likes';
      case EngagementTarget.replies:
        return 'Replies';
      case EngagementTarget.retweets:
        return 'Retweets';
      case EngagementTarget.bookmarks:
        return 'Bookmarks';
      case EngagementTarget.viral:
        return 'Viral';
    }
  }

  String get value => name;
}

class GenerationConstraints {
  final bool includeHashtags;
  final bool includeEmojis;
  final String? tone;
  final int? maxLength;

  GenerationConstraints({
    this.includeHashtags = true,
    this.includeEmojis = true,
    this.tone,
    this.maxLength,
  });

  Map<String, dynamic> toJson() {
    return {
      'includeHashtags': includeHashtags,
      'includeEmojis': includeEmojis,
      if (tone != null) 'tone': tone,
      if (maxLength != null) 'maxLength': maxLength,
    };
  }

  GenerationConstraints copyWith({
    bool? includeHashtags,
    bool? includeEmojis,
    String? tone,
    int? maxLength,
  }) {
    return GenerationConstraints(
      includeHashtags: includeHashtags ?? this.includeHashtags,
      includeEmojis: includeEmojis ?? this.includeEmojis,
      tone: tone ?? this.tone,
      maxLength: maxLength ?? this.maxLength,
    );
  }
}
