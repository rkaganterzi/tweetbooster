class ApiConfig {
  ApiConfig._();

  // Base URL for the API (Render deployment)
  static const String baseUrl = 'https://tweetbooster-api.onrender.com';

  // Timeouts (increased for Render.com cold start)
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);

  // Endpoints
  static const String analyzeEndpoint = '/api/analyze';
  static const String analyzeHistoryEndpoint = '/api/analyze/history';
  static const String generateEndpoint = '/api/generate';
  static const String templatesEndpoint = '/api/templates';
  static const String timingEndpoint = '/api/timing';
  static const String timingNowEndpoint = '/api/timing/now';

  // Competitor Analysis Endpoints
  static const String competitorAnalyzeEndpoint = '/api/competitor/analyze';
  static const String competitorHistoryEndpoint = '/api/competitor/history';
  static String competitorByIdEndpoint(String id) => '/api/competitor/$id';

  // Performance Tracking Endpoints
  static const String performanceExtractEndpoint = '/api/performance/extract';
  static const String performanceHistoryEndpoint = '/api/performance/history';
  static const String performanceTrendsEndpoint = '/api/performance/trends';
  static String performanceByIdEndpoint(String id) => '/api/performance/$id';

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
