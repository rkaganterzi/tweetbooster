import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: ApiConfig.defaultHeaders,
    ));

    // Only log in debug mode
    assert(() {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
      return true;
    }());

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        // Handle errors globally
        return handler.next(error);
      },
    ));
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.',
          statusCode: null,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'İnternet bağlantısı bulunamadı.',
          statusCode: null,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _getErrorMessage(error.response);
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'İstek iptal edildi.',
          statusCode: null,
        );
      default:
        return ApiException(
          message: 'Beklenmeyen bir hata oluştu.',
          statusCode: null,
        );
    }
  }

  String _getErrorMessage(Response? response) {
    if (response?.data is Map) {
      final data = response!.data as Map;
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data.containsKey('error')) {
        return data['error'].toString();
      }
    }

    switch (response?.statusCode) {
      case 400:
        return 'Geçersiz istek.';
      case 401:
        return 'Oturum süreniz doldu. Lütfen tekrar giriş yapın.';
      case 403:
        return 'Bu işlem için yetkiniz yok.';
      case 404:
        return 'İstenen kaynak bulunamadı.';
      case 500:
        return 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}
