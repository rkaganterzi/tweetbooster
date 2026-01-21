class ApiConfig {
  ApiConfig._();

  // Base URL for the API (Render deployment)
  static const String baseUrl = 'https://tweetboost-api.onrender.com';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  static const String analyzeEndpoint = '/api/analyze';
  static const String analyzeHistoryEndpoint = '/api/analyze/history';
  static const String generateEndpoint = '/api/generate';
  static const String templatesEndpoint = '/api/templates';
  static const String timingEndpoint = '/api/timing';
  static const String timingNowEndpoint = '/api/timing/now';

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
