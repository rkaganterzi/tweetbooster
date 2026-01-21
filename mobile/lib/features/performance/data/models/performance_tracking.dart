class ExtractedMetrics {
  final int? likes;
  final int? retweets;
  final int? replies;
  final int? quotes;
  final int? impressions;
  final int? bookmarks;
  final int? totalEngagement;
  final double confidence;
  final String? rawText;

  ExtractedMetrics({
    this.likes,
    this.retweets,
    this.replies,
    this.quotes,
    this.impressions,
    this.bookmarks,
    this.totalEngagement,
    this.confidence = 0,
    this.rawText,
  });

  factory ExtractedMetrics.fromJson(Map<String, dynamic> json) {
    return ExtractedMetrics(
      likes: json['likes'] as int?,
      retweets: json['retweets'] as int?,
      replies: json['replies'] as int?,
      quotes: json['quotes'] as int?,
      impressions: json['impressions'] as int?,
      bookmarks: json['bookmarks'] as int?,
      totalEngagement: json['totalEngagement'] as int?,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      rawText: json['rawText'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'retweets': retweets,
      'replies': replies,
      'quotes': quotes,
      'impressions': impressions,
      'bookmarks': bookmarks,
      'totalEngagement': totalEngagement,
      'confidence': confidence,
      'rawText': rawText,
    };
  }

  ExtractedMetrics copyWith({
    int? likes,
    int? retweets,
    int? replies,
    int? quotes,
    int? impressions,
    int? bookmarks,
    int? totalEngagement,
    double? confidence,
    String? rawText,
  }) {
    return ExtractedMetrics(
      likes: likes ?? this.likes,
      retweets: retweets ?? this.retweets,
      replies: replies ?? this.replies,
      quotes: quotes ?? this.quotes,
      impressions: impressions ?? this.impressions,
      bookmarks: bookmarks ?? this.bookmarks,
      totalEngagement: totalEngagement ?? this.totalEngagement,
      confidence: confidence ?? this.confidence,
      rawText: rawText ?? this.rawText,
    );
  }
}

class PerformanceTracking {
  final String? id;
  final String? originalAnalysisId;
  final double predictedScore;
  final int? actualLikes;
  final int? actualRetweets;
  final int? actualReplies;
  final int? actualQuotes;
  final int? actualImpressions;
  final int? actualBookmarks;
  final String? postContent;
  final double? accuracyScore;
  final DateTime createdAt;

  PerformanceTracking({
    this.id,
    this.originalAnalysisId,
    required this.predictedScore,
    this.actualLikes,
    this.actualRetweets,
    this.actualReplies,
    this.actualQuotes,
    this.actualImpressions,
    this.actualBookmarks,
    this.postContent,
    this.accuracyScore,
    required this.createdAt,
  });

  factory PerformanceTracking.fromJson(Map<String, dynamic> json) {
    return PerformanceTracking(
      id: json['id'] as String?,
      originalAnalysisId: json['originalAnalysisId'] as String?,
      predictedScore: (json['predictedScore'] as num?)?.toDouble() ?? 0,
      actualLikes: json['actualLikes'] as int?,
      actualRetweets: json['actualRetweets'] as int?,
      actualReplies: json['actualReplies'] as int?,
      actualQuotes: json['actualQuotes'] as int?,
      actualImpressions: json['actualImpressions'] as int?,
      actualBookmarks: json['actualBookmarks'] as int?,
      postContent: json['postContent'] as String?,
      accuracyScore: (json['accuracyScore'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalAnalysisId': originalAnalysisId,
      'predictedScore': predictedScore,
      'actualLikes': actualLikes,
      'actualRetweets': actualRetweets,
      'actualReplies': actualReplies,
      'actualQuotes': actualQuotes,
      'actualImpressions': actualImpressions,
      'actualBookmarks': actualBookmarks,
      'postContent': postContent,
      'accuracyScore': accuracyScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int get totalEngagement =>
      (actualLikes ?? 0) +
      (actualRetweets ?? 0) +
      (actualReplies ?? 0) +
      (actualQuotes ?? 0) +
      (actualBookmarks ?? 0);
}

class PerformanceTrends {
  final double? averageAccuracy;
  final int totalAnalyses;
  final double? averageEngagement;
  final List<TrendPoint> trend;

  PerformanceTrends({
    this.averageAccuracy,
    required this.totalAnalyses,
    this.averageEngagement,
    required this.trend,
  });

  factory PerformanceTrends.fromJson(Map<String, dynamic> json) {
    return PerformanceTrends(
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble(),
      totalAnalyses: json['totalAnalyses'] as int? ?? 0,
      averageEngagement: (json['averageEngagement'] as num?)?.toDouble(),
      trend: (json['trend'] as List<dynamic>?)
              ?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TrendPoint {
  final DateTime date;
  final int likes;
  final int retweets;
  final int replies;
  final double? accuracy;

  TrendPoint({
    required this.date,
    required this.likes,
    required this.retweets,
    required this.replies,
    this.accuracy,
  });

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      date: DateTime.parse(json['date'] as String),
      likes: json['likes'] as int? ?? 0,
      retweets: json['retweets'] as int? ?? 0,
      replies: json['replies'] as int? ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
    );
  }
}
