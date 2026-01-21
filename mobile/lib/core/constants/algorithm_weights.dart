/// Algorithm weights based on X algorithm research
/// Mirrors the weights from PostMaker X shared package
class AlgorithmWeights {
  AlgorithmWeights._();

  // Engagement weights
  static const Map<String, double> engagementWeights = {
    'like': 0.5,
    'reply': 1.0,
    'retweet': 1.5,
    'bookmark': 2.0,
    'profileClick': 1.5,
    'linkClick': 0.5,
    'dwell': 1.0,
  };

  // Content weights
  static const Map<String, double> contentWeights = {
    'hashtags': 0.3,
    'mentions': 0.5,
    'media': 1.5,
    'links': 0.5,
    'emojis': 0.2,
    'questions': 0.8,
    'callToAction': 0.7,
  };

  // Optimal length
  static const int optimalLengthMin = 71;
  static const int optimalLengthMax = 280;
  static const int maxLength = 280;
  static const int threadPartMaxLength = 280;

  // Limits
  static const int maxHashtags = 2;
  static const int maxMentions = 3;
  static const int maxEmojis = 3;

  // Time-based multipliers
  static const Map<String, double> peakHoursMultiplier = {
    '9': 1.2,
    '10': 1.3,
    '11': 1.25,
    '12': 1.35,
    '13': 1.3,
    '14': 1.2,
    '17': 1.25,
    '18': 1.35,
    '19': 1.4,
    '20': 1.35,
    '21': 1.25,
  };
}
