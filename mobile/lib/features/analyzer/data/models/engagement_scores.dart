class EngagementScores {
  final double likeability;
  final double replyability;
  final double retweetability;
  final double quoteability;
  final double shareability;
  final double dwellPotential;
  final double followPotential;

  EngagementScores({
    this.likeability = 0,
    this.replyability = 0,
    this.retweetability = 0,
    this.quoteability = 0,
    this.shareability = 0,
    this.dwellPotential = 0,
    this.followPotential = 0,
  });

  factory EngagementScores.fromJson(Map<String, dynamic> json) {
    // Backend returns 0-1, UI expects 0-100
    double normalize(num? value) {
      final v = value?.toDouble() ?? 0;
      return v <= 1 ? v * 100 : v;
    }

    return EngagementScores(
      likeability: normalize(json['likeability'] as num?),
      replyability: normalize(json['replyability'] as num?),
      retweetability: normalize(json['retweetability'] as num?),
      quoteability: normalize(json['quoteability'] as num?),
      shareability: normalize(json['shareability'] as num?),
      dwellPotential: normalize(json['dwellPotential'] as num?),
      followPotential: normalize(json['followPotential'] as num?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likeability': likeability,
      'replyability': replyability,
      'retweetability': retweetability,
      'quoteability': quoteability,
      'shareability': shareability,
      'dwellPotential': dwellPotential,
      'followPotential': followPotential,
    };
  }

  double get average =>
      (likeability + replyability + retweetability + quoteability + shareability + dwellPotential + followPotential) / 7;

  /// Primary scores shown in main UI
  List<EngagementScoreItem> toList() {
    return [
      EngagementScoreItem('likeability', likeability, 'likeability'),
      EngagementScoreItem('replyability', replyability, 'replyability'),
      EngagementScoreItem('retweetability', retweetability, 'retweetability'),
      EngagementScoreItem('quoteability', quoteability, 'quoteability'),
    ];
  }

  /// All scores for detailed view
  List<EngagementScoreItem> toFullList() {
    return [
      EngagementScoreItem('likeability', likeability, 'likeability'),
      EngagementScoreItem('replyability', replyability, 'replyability'),
      EngagementScoreItem('retweetability', retweetability, 'retweetability'),
      EngagementScoreItem('quoteability', quoteability, 'quoteability'),
      EngagementScoreItem('shareability', shareability, 'shareability'),
      EngagementScoreItem('dwellPotential', dwellPotential, 'dwellPotential'),
      EngagementScoreItem('followPotential', followPotential, 'followPotential'),
    ];
  }
}

class EngagementScoreItem {
  final String label;
  final double value;
  final String key;

  EngagementScoreItem(this.label, this.value, this.key);
}
