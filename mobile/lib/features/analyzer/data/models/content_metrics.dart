class ContentMetrics {
  final int characterCount;
  final int wordCount;
  final int hashtagCount;
  final int mentionCount;
  final int emojiCount;
  final int linkCount;
  final bool hasMedia;

  ContentMetrics({
    this.characterCount = 0,
    this.wordCount = 0,
    this.hashtagCount = 0,
    this.mentionCount = 0,
    this.emojiCount = 0,
    this.linkCount = 0,
    this.hasMedia = false,
  });

  factory ContentMetrics.fromJson(Map<String, dynamic> json) {
    return ContentMetrics(
      characterCount: json['characterCount'] as int? ?? 0,
      wordCount: json['wordCount'] as int? ?? 0,
      hashtagCount: json['hashtagCount'] as int? ?? 0,
      mentionCount: json['mentionCount'] as int? ?? 0,
      emojiCount: json['emojiCount'] as int? ?? 0,
      linkCount: json['linkCount'] as int? ?? 0,
      hasMedia: json['hasMedia'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'characterCount': characterCount,
      'wordCount': wordCount,
      'hashtagCount': hashtagCount,
      'mentionCount': mentionCount,
      'emojiCount': emojiCount,
      'linkCount': linkCount,
      'hasMedia': hasMedia,
    };
  }

  factory ContentMetrics.fromContent(String content) {
    return ContentMetrics(
      characterCount: content.length,
      wordCount: content.trim().isEmpty
          ? 0
          : content.trim().split(RegExp(r'\s+')).length,
      hashtagCount: RegExp(r'#\w+').allMatches(content).length,
      mentionCount: RegExp(r'@\w+').allMatches(content).length,
      emojiCount: RegExp(
        r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
        unicode: true,
      ).allMatches(content).length,
      linkCount: RegExp(r'https?://\S+').allMatches(content).length,
      hasMedia: false,
    );
  }
}
