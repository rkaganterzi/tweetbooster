class TimingRecommendation {
  final int hour;
  final int dayOfWeek;
  final double score;
  final String label;
  final String description;

  TimingRecommendation({
    required this.hour,
    required this.dayOfWeek,
    required this.score,
    required this.label,
    required this.description,
  });

  factory TimingRecommendation.fromJson(Map<String, dynamic> json) {
    return TimingRecommendation(
      hour: json['hour'] as int? ?? 0,
      dayOfWeek: json['dayOfWeek'] as int? ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      label: json['label'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'dayOfWeek': dayOfWeek,
      'score': score,
      'label': label,
      'description': description,
    };
  }

  String get formattedTime {
    final hourStr = hour.toString().padLeft(2, '0');
    return '$hourStr:00';
  }

  String get dayName {
    const days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];
    return days[dayOfWeek];
  }
}

class TimingAnalysis {
  final double currentScore;
  final bool isGoodTime;
  final String recommendation;
  final TimingRecommendation? bestTime;
  final List<TimingRecommendation> topTimes;
  final List<List<double>> heatmapData;

  TimingAnalysis({
    required this.currentScore,
    required this.isGoodTime,
    required this.recommendation,
    this.bestTime,
    this.topTimes = const [],
    this.heatmapData = const [],
  });

  factory TimingAnalysis.fromJson(Map<String, dynamic> json) {
    return TimingAnalysis(
      currentScore: (json['currentScore'] as num?)?.toDouble() ?? 0,
      isGoodTime: json['isGoodTime'] as bool? ?? false,
      recommendation: json['recommendation'] as String? ?? '',
      bestTime: json['bestTime'] != null
          ? TimingRecommendation.fromJson(
              json['bestTime'] as Map<String, dynamic>)
          : null,
      topTimes: (json['topTimes'] as List<dynamic>?)
              ?.map((e) =>
                  TimingRecommendation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      heatmapData: (json['heatmapData'] as List<dynamic>?)
              ?.map((row) => (row as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentScore': currentScore,
      'isGoodTime': isGoodTime,
      'recommendation': recommendation,
      'bestTime': bestTime?.toJson(),
      'topTimes': topTimes.map((e) => e.toJson()).toList(),
      'heatmapData': heatmapData,
    };
  }

  // Generate mock heatmap data
  static List<List<double>> generateMockHeatmap() {
    // 7 days x 24 hours
    return List.generate(7, (day) {
      return List.generate(24, (hour) {
        // Simulate engagement patterns
        if (hour >= 9 && hour <= 11) {
          return 0.6 + (day < 5 ? 0.3 : 0.1);
        } else if (hour >= 12 && hour <= 14) {
          return 0.7 + (day < 5 ? 0.2 : 0.15);
        } else if (hour >= 17 && hour <= 21) {
          return 0.75 + (day >= 5 ? 0.2 : 0.15);
        } else if (hour >= 22 || hour <= 6) {
          return 0.2 + (hour * 0.01);
        }
        return 0.4 + (hour * 0.02);
      });
    });
  }
}
