import 'package:flutter/material.dart';

class GeneratedPost {
  final String id;
  final String content;
  final double score;
  final String style;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  GeneratedPost({
    required this.id,
    required this.content,
    required this.score,
    required this.style,
    required this.createdAt,
    this.metadata,
  });

  factory GeneratedPost.fromJson(Map<String, dynamic> json) {
    // Backend returns 0-1, UI expects 0-100
    final rawScore = (json['score'] as num?)?.toDouble() ?? 0;
    final normalizedScore = rawScore <= 1 ? rawScore * 100 : rawScore;

    return GeneratedPost(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      score: normalizedScore,
      style: json['style'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'score': score,
      'style': style,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

enum PostStyle {
  informative,
  controversial,
  question,
  thread,
  story,
  hook,
}

extension PostStyleExtension on PostStyle {
  String get label {
    switch (this) {
      case PostStyle.informative:
        return 'Bilgilendirici';
      case PostStyle.controversial:
        return 'Tartışmalı';
      case PostStyle.question:
        return 'Soru';
      case PostStyle.thread:
        return 'Thread';
      case PostStyle.story:
        return 'Hikaye';
      case PostStyle.hook:
        return 'Hook';
    }
  }

  String get labelEn {
    switch (this) {
      case PostStyle.informative:
        return 'Informative';
      case PostStyle.controversial:
        return 'Controversial';
      case PostStyle.question:
        return 'Question';
      case PostStyle.thread:
        return 'Thread';
      case PostStyle.story:
        return 'Story';
      case PostStyle.hook:
        return 'Hook';
    }
  }

  String get value => name;

  IconData get icon {
    switch (this) {
      case PostStyle.informative:
        return Icons.lightbulb_outline;
      case PostStyle.controversial:
        return Icons.local_fire_department;
      case PostStyle.question:
        return Icons.help_outline;
      case PostStyle.thread:
        return Icons.format_list_numbered;
      case PostStyle.story:
        return Icons.auto_stories;
      case PostStyle.hook:
        return Icons.bolt;
    }
  }
}
