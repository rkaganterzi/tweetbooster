class EngagementScores {
  final double likeability;
  final double replyability;
  final double retweetability;
  final double bookmarkability;

  EngagementScores({
    this.likeability = 0,
    this.replyability = 0,
    this.retweetability = 0,
    this.bookmarkability = 0,
  });

  factory EngagementScores.fromJson(Map<String, dynamic> json) {
    return EngagementScores(
      likeability: (json['likeability'] as num?)?.toDouble() ?? 0,
      replyability: (json['replyability'] as num?)?.toDouble() ?? 0,
      retweetability: (json['retweetability'] as num?)?.toDouble() ?? 0,
      bookmarkability: (json['bookmarkability'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likeability': likeability,
      'replyability': replyability,
      'retweetability': retweetability,
      'bookmarkability': bookmarkability,
    };
  }

  double get average =>
      (likeability + replyability + retweetability + bookmarkability) / 4;

  List<EngagementScoreItem> toList() {
    return [
      EngagementScoreItem('Beğeni', likeability, 'likeability'),
      EngagementScoreItem('Yanıt', replyability, 'replyability'),
      EngagementScoreItem('Retweet', retweetability, 'retweetability'),
      EngagementScoreItem('Kaydet', bookmarkability, 'bookmarkability'),
    ];
  }
}

class EngagementScoreItem {
  final String label;
  final double value;
  final String key;

  EngagementScoreItem(this.label, this.value, this.key);
}
