import '../../../analyzer/data/models/post_analysis.dart';

class CompetitorAnalysis {
  final String? id;
  final String competitorContent;
  final String? sourceUrl;
  final String? notes;
  final PostAnalysis analysis;
  final DateTime createdAt;

  CompetitorAnalysis({
    this.id,
    required this.competitorContent,
    this.sourceUrl,
    this.notes,
    required this.analysis,
    required this.createdAt,
  });

  factory CompetitorAnalysis.fromJson(Map<String, dynamic> json) {
    final analysisData = json['analysis'] as Map<String, dynamic>? ?? {};
    // Merge competitorContent into analysis for PostAnalysis parsing
    analysisData['content'] = json['competitorContent'] as String? ?? '';

    return CompetitorAnalysis(
      id: json['id'] as String?,
      competitorContent: json['competitorContent'] as String? ?? '',
      sourceUrl: json['sourceUrl'] as String?,
      notes: json['notes'] as String?,
      analysis: PostAnalysis.fromJson(analysisData),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competitorContent': competitorContent,
      'sourceUrl': sourceUrl,
      'notes': notes,
      'analysis': analysis.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CompetitorAnalysis copyWith({
    String? id,
    String? competitorContent,
    String? sourceUrl,
    String? notes,
    PostAnalysis? analysis,
    DateTime? createdAt,
  }) {
    return CompetitorAnalysis(
      id: id ?? this.id,
      competitorContent: competitorContent ?? this.competitorContent,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      notes: notes ?? this.notes,
      analysis: analysis ?? this.analysis,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CompetitorComparison {
  final CompetitorAnalysis competitor;
  final PostAnalysis? myPost;

  CompetitorComparison({
    required this.competitor,
    this.myPost,
  });

  double get scoreDifference {
    if (myPost == null) return 0;
    return myPost!.overallScore - competitor.analysis.overallScore;
  }

  bool get isMyPostBetter => scoreDifference > 0;

  Map<String, double> get engagementComparison {
    if (myPost == null) return {};

    return {
      'likes': myPost!.engagementScores.likeability -
          competitor.analysis.engagementScores.likeability,
      'retweets': myPost!.engagementScores.retweetability -
          competitor.analysis.engagementScores.retweetability,
      'replies': myPost!.engagementScores.replyability -
          competitor.analysis.engagementScores.replyability,
      'quotes': myPost!.engagementScores.quoteability -
          competitor.analysis.engagementScores.quoteability,
    };
  }
}
