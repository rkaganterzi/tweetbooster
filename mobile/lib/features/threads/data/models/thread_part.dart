class ThreadPart {
  final int index;
  final String content;
  final double? score;
  final bool isEdited;

  ThreadPart({
    required this.index,
    required this.content,
    this.score,
    this.isEdited = false,
  });

  factory ThreadPart.fromJson(Map<String, dynamic> json) {
    return ThreadPart(
      index: json['index'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble(),
      isEdited: json['isEdited'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'content': content,
      'score': score,
      'isEdited': isEdited,
    };
  }

  ThreadPart copyWith({
    int? index,
    String? content,
    double? score,
    bool? isEdited,
  }) {
    return ThreadPart(
      index: index ?? this.index,
      content: content ?? this.content,
      score: score ?? this.score,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  int get characterCount => content.length;
  bool get isOverLimit => characterCount > 280;
  int get partNumber => index + 1;
}

class Thread {
  final String id;
  final List<ThreadPart> parts;
  final DateTime createdAt;
  final double? averageScore;

  Thread({
    required this.id,
    required this.parts,
    required this.createdAt,
    this.averageScore,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'] as String? ?? '',
      parts: (json['parts'] as List<dynamic>?)
              ?.map((e) => ThreadPart.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      averageScore: (json['averageScore'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parts': parts.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'averageScore': averageScore,
    };
  }

  int get totalParts => parts.length;

  String get fullContent => parts.map((p) => p.content).join('\n\n');

  double get calculatedAverageScore {
    if (parts.isEmpty) return 0;
    final scores = parts.where((p) => p.score != null).map((p) => p.score!);
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }
}
